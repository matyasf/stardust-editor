package com.funkypandagame.stardust.controller
{

import com.funkypandagame.stardust.model.ProjectModel;
import com.funkypandagame.stardust.textures.Atlas;
import com.funkypandagame.stardust.textures.AtlasTexture;
import com.funkypandagame.stardust.textures.TexturePacker;
import com.funkypandagame.stardustplayer.SimLoader;
import com.funkypandagame.stardustplayer.ZipFileNames;
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
    public var projectSettings : ProjectModel;

    private function IOErrorHandler( e : IOErrorEvent ) : void
    {
        Alert.show( "Error saving the file, details:\n" + e.toString(), "ERROR" );
    }

    public function execute() : void
    {
        const saveFile : FileReference = new FileReference();
        saveFile.addEventListener( IOErrorEvent.IO_ERROR, IOErrorHandler );
        saveFile.save( constructProjectFileByteArray(), "stardustProject.sde" );
    }

    private function constructProjectFileByteArray() : ByteArray
    {
        const zip : Zip = new Zip();
        const descObj : Object = {};
        descObj.version = 2;
        descObj.fps = DisplayObject(FlexGlobals.topLevelApplication).stage.frameRate;

        createEmitterAtlas( zip );
        addEmittersToProjectFile( zip );
        addBackgroundToProjectFile( zip, descObj );

        zip.addFileFromString( SimLoader.DESCRIPTOR_FILENAME, JSON.stringify( descObj ) );
        const zippedData : ByteArray = new ByteArray();
        zip.serialize( zippedData, false );
        return zippedData;
    }

    // experimental, not working yet
    private function createEmitterAtlas( zip : Zip ) : void
    {
        /*
        Sim Loader:
           * loads image into a textureAtlas. Call setTextures, EmitterVO stores the texture.
           * FALLBACK: If no atlas call setTextures() with the images. EmitterVO stores the texture.(+draw call)
        Load command:
           * Reads BDs from the raw atlases image. Store it in a model.
           * FALLBACK: Read the old style individual images. Store it in a model.
        Add emitter:
           Generate a BD, store it in a model, call setTextures with an image. (+draw call)
           Make UI with preview to set image width/height
        Save command:
           * get textures from model, pack into atlas, save it.
        Change emitter:
           Remove the ability to change image with/height
        */
        var packer : TexturePacker = new TexturePacker();
        var textures : Vector.<AtlasTexture> = new Vector.<AtlasTexture>();
        for (var emitterId : * in projectSettings.emitterImages)
        {
            var images : Vector.<BitmapData> = projectSettings.emitterImages[emitterId];
            for each (var data : BitmapData in images)
            {
                textures.push(new AtlasTexture(data, uint(emitterId)));
            }
        }
        var atlas : Atlas = packer.createAtlas(textures);
        var pngEncoder : PNGEncoder = new PNGEncoder();
        zip.addFile(ZipFileNames.getAtlasName(atlas.name), pngEncoder.encode(atlas.toBitmap()));
        zip.addFileFromString(ZipFileNames.getAtlasXMLName(atlas.name), atlas.getXML().toString());

    }

    private function addEmittersToProjectFile( zip : Zip ) : void
    {
        for each (var emitterVO : EmitterValueObject in projectSettings.stadustSim.emitters)
        {
            if (emitterVO.emitterSnapshot)
            {
                zip.addFile( ZipFileNames.getParticleSnapshotName(emitterVO.id), emitterVO.emitterSnapshot, false );
            }
            zip.addFileFromString( ZipFileNames.getXMLName(emitterVO.id), XMLBuilder.buildXML( emitterVO.emitter ).toString() );
        }
    }

    private function addBackgroundToProjectFile( zip : Zip, descObj : Object ) : void
    {
        if ( projectSettings.backgroundImage != null )
        {
            zip.addFile( SimLoader.BACKGROUND_FILENAME, projectSettings.backgroundRawData );
        }
        if ( projectSettings.hasBackground )
        {
            descObj.hasBackground = "true";
        }
        else
        {
            descObj.hasBackground = "false";
        }
        descObj.backgroundColor = projectSettings.backgroundColor;
    }

}
}
