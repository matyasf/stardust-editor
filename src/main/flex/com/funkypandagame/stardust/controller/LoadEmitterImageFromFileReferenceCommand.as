package com.funkypandagame.stardust.controller
{

import com.funkypandagame.stardust.controller.events.StartSimEvent;
import com.funkypandagame.stardust.model.ProjectModel;
import com.funkypandagame.stardust.view.SetEmitterImagePopup;
import com.funkypandagame.stardustplayer.emitter.EmitterValueObject;
import com.funkypandagame.stardustplayer.sequenceLoader.ISequenceLoader;
import com.funkypandagame.stardustplayer.sequenceLoader.LoadByteArrayJob;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;

import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.geom.Rectangle;

import flash.net.FileFilter;
import flash.net.FileReference;

import idv.cjcat.stardustextended.twoD.starling.StarlingHandler;

import mx.core.FlexGlobals;

import mx.managers.PopUpManager;

import robotlegs.bender.extensions.commandCenter.api.ICommand;

import starling.textures.SubTexture;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

public class LoadEmitterImageFromFileReferenceCommand implements ICommand
{
    [Inject]
    public var sequenceLoader : ISequenceLoader;

    [Inject]
    public var projectSettings : ProjectModel;

    [Inject]
    public var dispatcher : IEventDispatcher;

    private var _emitterImageFile : FileReference;

    public function execute() : void
    {
        var loadFile : FileReference = new FileReference();
        var fileFilter : FileFilter = new FileFilter( "Images", ".gif;*.jpeg;*.jpg;*.png" );
        loadFile.browse( [fileFilter] );

        _emitterImageFile = loadFile;
        _emitterImageFile.addEventListener( Event.SELECT, emitterSelectHandler );
    }

    private function emitterSelectHandler( event : Event ) : void
    {
        _emitterImageFile.removeEventListener( Event.SELECT, emitterSelectHandler );
        _emitterImageFile.addEventListener( Event.COMPLETE, loadEmitterFromByteArray );
        _emitterImageFile.load();
    }

    private function loadEmitterFromByteArray( event : Event ) : void
    {
        var emitterName : String = projectSettings.emitterInFocus.id.toString();
        sequenceLoader.removeCompletedJobByName( emitterName );
        var job : LoadByteArrayJob = new LoadByteArrayJob( emitterName, _emitterImageFile.name, _emitterImageFile.data );
        sequenceLoader.addJob( job );
        sequenceLoader.addEventListener( Event.COMPLETE, onEmitterImageLoaded );
        sequenceLoader.loadSequence();
    }

    private function onEmitterImageLoaded( event : Event ) : void
    {
        sequenceLoader.removeEventListener( Event.COMPLETE, onEmitterImageLoaded );

        var imageProps : SetEmitterImagePopup = new SetEmitterImagePopup();
        PopUpManager.addPopUp(imageProps, FlexGlobals.topLevelApplication as DisplayObject, true);
        imageProps.setImageSlices(onImagePropsClosed);
    }

    private function onImagePropsClosed(spWidth : Number, spHeight : Number) : void
    {
        const emitterVO : EmitterValueObject = projectSettings.emitterInFocus;
        const loadJob : LoadByteArrayJob = sequenceLoader.getCompletedJobs().pop();
        var rawData : BitmapData = Bitmap(loadJob.content).bitmapData;
        var allTextures : Vector.<SubTexture> = new Vector.<SubTexture>();

        var isSpriteSheet : Boolean = (spWidth > 0 && spHeight > 0) &&
                (rawData.width >= spWidth * 2 || rawData.height >= spHeight * 2);
        if (isSpriteSheet)
        {
            var tmpAtlas : TextureAtlas = new TextureAtlas(Texture.fromBitmapData(rawData, false));
            const xIter : int = Math.floor( rawData.width / spWidth );
            const yIter : int = Math.floor( rawData.height / spHeight );
            for ( var j : int = 0; j < yIter; j ++ )
            {
                for ( var i : int = 0; i < xIter; i ++ )
                {
                    tmpAtlas.addRegion(j + "_" + i, new Rectangle( i * spWidth, j * spHeight, spWidth, spHeight ));
                }
            }
            var texs : Vector.<Texture> = tmpAtlas.getTextures("");
            for each (var tex : SubTexture in texs)
            {
                allTextures.push(tex);
            }
        }
        else
        {
            var subTex : SubTexture = new SubTexture(Texture.fromBitmapData(rawData, false), null);
            allTextures.push(subTex);
        }

        StarlingHandler(emitterVO.emitter.particleHandler).setTextures(allTextures);
        // If the image changes the animation frames are recalculated and there might be particles on the screen which
        // are now at a non-existent frame number.
        dispatcher.dispatchEvent( new StartSimEvent() );
    }

}
}
