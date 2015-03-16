package com.funkypandagame.stardust.controller
{

import com.funkypandagame.stardust.model.ProjectModel;
import com.funkypandagame.stardustplayer.SimLoader;
import com.funkypandagame.stardustplayer.ZipFileNames;
import com.funkypandagame.stardustplayer.emitter.EmitterValueObject;

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

        addEmittersToProjectFile( zip );
        addBackgroundToProjectFile( zip, descObj );

        zip.addFileFromString( SimLoader.DESCRIPTOR_FILENAME, JSON.stringify( descObj ) );
        const zippedData : ByteArray = new ByteArray();
        zip.serialize( zippedData, false );
        return zippedData;
    }

    private function addEmittersToProjectFile( zip : Zip ) : void
    {
        for each (var emitterVO : EmitterValueObject in projectSettings.stadustSim.emitters)
        {
            var pngEncoder : PNGEncoder = new PNGEncoder();
            zip.addFile( ZipFileNames.getImageName(emitterVO.id), pngEncoder.encode( emitterVO.image ), false );
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
