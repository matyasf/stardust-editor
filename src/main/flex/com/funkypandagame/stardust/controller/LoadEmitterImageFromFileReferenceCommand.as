package com.funkypandagame.stardust.controller
{

import com.funkypandagame.stardust.controller.events.StartSimEvent;
import com.funkypandagame.stardust.model.ProjectModel;
import com.funkypandagame.stardustplayer.emitter.EmitterValueObject;
import com.funkypandagame.stardustplayer.sequenceLoader.ISequenceLoader;
import com.funkypandagame.stardustplayer.sequenceLoader.LoadByteArrayJob;

import flash.display.Bitmap;

import flash.events.Event;
import flash.events.IEventDispatcher;

import flash.net.FileFilter;
import flash.net.FileReference;

import idv.cjcat.stardustextended.twoD.starling.StarlingHandler;

import robotlegs.bender.extensions.commandCenter.api.ICommand;

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
        const emitterVO : EmitterValueObject = projectSettings.emitterInFocus;
        if (emitterVO.emitter.particleHandler is StarlingHandler)
        {
            StarlingHandler(emitterVO.emitter.particleHandler).texture.dispose();
        }
        const loadJob : LoadByteArrayJob = sequenceLoader.getJobByName( emitterVO.id.toString() );
        emitterVO.image = ( loadJob.content as Bitmap ).bitmapData;
        // If the image changes the animation frames are recalculated and there might be particles on the screen which
        // are now at a non-existent frame number.
        dispatcher.dispatchEvent( new StartSimEvent() );
    }

}
}
