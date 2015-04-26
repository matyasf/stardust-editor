package com.funkypandagame.stardust.controller
{

import com.funkypandagame.stardust.model.ProjectModel;
import com.funkypandagame.stardust.textures.Atlas;
import com.funkypandagame.stardust.textures.AtlasTexture;
import com.funkypandagame.stardust.textures.TexturePacker;
import com.funkypandagame.stardustplayer.SimLoader;
import com.funkypandagame.stardustplayer.SDEConstants;
import com.funkypandagame.stardustplayer.emitter.EmitterValueObject;

import flash.display.BitmapData;

import flash.display.DisplayObject;

import flash.events.IOErrorEvent;
import flash.net.FileReference;
import flash.utils.ByteArray;

import idv.cjcat.stardustextended.common.xml.XMLBuilder;

import mx.core.FlexGlobals;
import mx.graphics.codec.PNGEncoder;

import org.as3commons.zip.Zip;

import robotlegs.bender.extensions.commandCenter.api.ICommand;

import spark.components.Alert;

public class SaveSimCommand implements ICommand
{

    [Inject]
    public var projectModel : ProjectModel;

    public function execute() : void
    {
        const saveFile : FileReference = new FileReference();
        saveFile.addEventListener( IOErrorEvent.IO_ERROR, IOErrorHandler );
        saveFile.save( constructProjectFileByteArray(), "stardustProject.sde" );
    }

    private static function IOErrorHandler( e : IOErrorEvent ) : void
    {
        Alert.show( "Error saving the file, details:\n" + e.toString(), "ERROR" );
    }

    private function constructProjectFileByteArray() : ByteArray
    {
        const zip : Zip = new Zip();
        const descObj : Object = {};
        descObj.version = 2.1;
        descObj.fps = DisplayObject(FlexGlobals.topLevelApplication).stage.frameRate;

        createEmitterAtlas( zip );
        addEmittersToProjectFile( zip );
        addBackgroundToProjectFile( zip, descObj );

        zip.addFileFromString( SimLoader.DESCRIPTOR_FILENAME, JSON.stringify( descObj ) );
        const zippedData : ByteArray = new ByteArray();
        zip.serialize( zippedData, false );
        return zippedData;
    }

    private function createEmitterAtlas( zip : Zip ) : void
    {
        var packer : TexturePacker = new TexturePacker();
        var textures : Vector.<AtlasTexture> = new Vector.<AtlasTexture>();
        for (var emitterId : * in projectModel.emitterImages)
        {
            var images : Vector.<BitmapData> = projectModel.emitterImages[emitterId];
            for each (var data : BitmapData in images)
            {
                textures.push(new AtlasTexture(data, uint(emitterId)));
            }
        }
        var atlas : Atlas = packer.createAtlas(textures);
        if (atlas)
        {
            var pngEncoder : PNGEncoder = new PNGEncoder();
            zip.addFile(SDEConstants.getAtlasName(atlas.name), pngEncoder.encode(atlas.toBitmap()));
            zip.addFileFromString(SDEConstants.getAtlasXMLName(atlas.name), '<?xml version="1.0" encoding="UTF-8"?>\n' + atlas.getXML().toString());
        }
        else
        {
            Alert.show("Failed to add images. Could not fit all images into a 2048x2048 texture atlas.");
        }
    }

    private function addEmittersToProjectFile( zip : Zip ) : void
    {
        for each (var emitterVO : EmitterValueObject in projectModel.stadustSim.emitters)
        {
            if (emitterVO.emitterSnapshot)
            {
                zip.addFile( SDEConstants.getParticleSnapshotName(emitterVO.id), emitterVO.emitterSnapshot, false );
            }
            zip.addFileFromString( SDEConstants.getXMLName(emitterVO.id), XMLBuilder.buildXML( emitterVO.emitter ).toString() );
        }
    }

    private function addBackgroundToProjectFile( zip : Zip, descObj : Object ) : void
    {
        if ( projectModel.backgroundImage != null )
        {
            zip.addFile( SimLoader.BACKGROUND_FILENAME, projectModel.backgroundRawData );
        }
        if ( projectModel.hasBackground )
        {
            descObj.hasBackground = "true";
        }
        else
        {
            descObj.hasBackground = "false";
        }
        descObj.backgroundColor = projectModel.backgroundColor;
    }

}
}
