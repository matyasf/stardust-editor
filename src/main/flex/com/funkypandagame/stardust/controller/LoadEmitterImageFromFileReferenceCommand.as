package com.funkypandagame.stardust.controller
{

import com.funkypandagame.stardust.controller.events.RegenerateEmitterTexturesEvent;
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

import flash.net.FileFilter;
import flash.net.FileReference;

import idv.cjcat.stardustextended.flashdisplay.handlers.SpriteSheetBitmapSlicedCache;

import mx.core.FlexGlobals;

import mx.managers.PopUpManager;

import robotlegs.bender.extensions.commandCenter.api.ICommand;

public class LoadEmitterImageFromFileReferenceCommand implements ICommand
{
    [Inject]
    public var sequenceLoader : ISequenceLoader;

    [Inject]
    public var projectModel : ProjectModel;

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
        var emitterName : String = projectModel.emitterInFocus.id.toString();
        sequenceLoader.removeCompletedJobByName( emitterName );
        var job : LoadByteArrayJob = new LoadByteArrayJob( emitterName, _emitterImageFile.name, _emitterImageFile.data );
        sequenceLoader.addJob( job );
        sequenceLoader.addEventListener( Event.COMPLETE, onEmitterImageLoaded );
        sequenceLoader.loadSequence();
    }

    private function onEmitterImageLoaded( event : Event ) : void
    {
        sequenceLoader.removeEventListener( Event.COMPLETE, onEmitterImageLoaded );

        const loadJob : LoadByteArrayJob = sequenceLoader.getCompletedJobs()[0];
        var rawData : BitmapData = Bitmap(loadJob.content).bitmapData;

        var imageProps : SetEmitterImagePopup = new SetEmitterImagePopup();
        PopUpManager.addPopUp(imageProps, FlexGlobals.topLevelApplication as DisplayObject, true);
        PopUpManager.centerPopUp(imageProps);
        imageProps.setImageSlices(rawData, onImagePropsClosed);
    }

    private function onImagePropsClosed(spWidth : Number, spHeight : Number) : void
    {
        const emitterVO : EmitterValueObject = projectModel.emitterInFocus;
        const loadJob : LoadByteArrayJob = sequenceLoader.getCompletedJobs().pop();
        var rawData : BitmapData = Bitmap(loadJob.content).bitmapData;

        var isSpriteSheet : Boolean = (spWidth > 0 && spHeight > 0) &&
                (rawData.width >= spWidth * 2 || rawData.height >= spHeight * 2);
        if (isSpriteSheet)
        {
            var splicer : SpriteSheetBitmapSlicedCache = new SpriteSheetBitmapSlicedCache(rawData, spWidth, spHeight);
            projectModel.emitterImages[emitterVO.id] = splicer.bds;
        }
        else
        {
            projectModel.emitterImages[emitterVO.id] = new <BitmapData>[rawData];
        }
        dispatcher.dispatchEvent(new RegenerateEmitterTexturesEvent());
        // If the image changes the animation frames are recalculated and there might be particles on the screen which
        // are now at a non-existent frame number.
        dispatcher.dispatchEvent( new StartSimEvent() );
    }

}
}
