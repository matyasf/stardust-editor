package com.funkypandagame.stardust.controller
{

import com.funkypandagame.stardust.controller.events.BackgroundChangeEvent;
import com.funkypandagame.stardust.controller.events.StartSimEvent;
import com.funkypandagame.stardust.model.ProjectModel;
import com.funkypandagame.stardust.view.events.RefreshBackgroundViewEvent;
import com.funkypandagame.stardustplayer.sequenceLoader.ISequenceLoader;
import com.funkypandagame.stardustplayer.sequenceLoader.LoadByteArrayJob;

import flash.display.MovieClip;

import flash.events.Event;
import flash.events.IEventDispatcher;

import flash.net.FileFilter;
import flash.net.FileReference;

import robotlegs.bender.extensions.commandCenter.api.ICommand;

public class ChangeBackgroundCommand implements ICommand
{

    [Inject]
    public var sequenceLoader : ISequenceLoader;

    [Inject]
    public var dispatcher : IEventDispatcher;

    [Inject]
    public var event : BackgroundChangeEvent;

    [Inject]
    public var projectModel : ProjectModel;

  //  [Inject]
   // public var bgModel : BackgroundModel;

    private var _backgroundFileReference : FileReference;
    public static const BACKGROUND_JOB_ID : String = "backgroundJobId";

    public function execute() : void
    {
        if (event.property == BackgroundChangeEvent.IMAGE)
        {
            var loadFile : FileReference = new FileReference();
            var fileFilter : FileFilter = new FileFilter( "Images: (*.jpeg, *.jpg, *.gif, *.png, *.swf)", "*.jpeg; *.jpg; *.gif; *.png; *.swf" );
            loadFile.browse( [fileFilter] );

            _backgroundFileReference = loadFile;
            _backgroundFileReference.addEventListener( Event.SELECT, backgroundSelectHandler );
        }
        else if (event.property == BackgroundChangeEvent.COLOR)
        {
            projectModel.stadustSim.backgroundColor = event.value as uint;
            dispatcher.dispatchEvent( new RefreshBackgroundViewEvent() );
        }
        else if (event.property == BackgroundChangeEvent.HAS_BACKGROUND)
        {
            projectModel.stadustSim.hasBackground = event.value as Boolean;
            if (projectModel.stadustSim.hasBackground == false)
            {
                projectModel.stadustSim.backgroundColor = 0;
                projectModel.stadustSim.backgroundImage = null;
                projectModel.stadustSim.backgroundFileName = "";
                projectModel.stadustSim.backgroundRawData = null;
            }
            else
            {
                // TODO store bg settings temporarly. Sim needs to be restarted if bg is MovieClip
                projectModel.stadustSim.backgroundColor = 0;
                projectModel.stadustSim.backgroundImage = null;
                projectModel.stadustSim.backgroundFileName = "";
                projectModel.stadustSim.backgroundRawData = null;

            }
            dispatcher.dispatchEvent( new RefreshBackgroundViewEvent() );
        }
    }

    private function backgroundSelectHandler( event : Event ) : void
    {
        _backgroundFileReference.removeEventListener( Event.SELECT, backgroundSelectHandler );
        _backgroundFileReference.addEventListener( Event.COMPLETE, loadBackgroundFromByteArray );
        _backgroundFileReference.load();
    }

    private function loadBackgroundFromByteArray( event : Event ) : void
    {
        sequenceLoader.removeCompletedJobByName( BACKGROUND_JOB_ID );
        var job : LoadByteArrayJob = new LoadByteArrayJob( BACKGROUND_JOB_ID, _backgroundFileReference.name, _backgroundFileReference.data );
        sequenceLoader.addJob( job );
        sequenceLoader.addEventListener( Event.COMPLETE, onBackgroundLoaded );
        sequenceLoader.loadSequence();
    }

    private function onBackgroundLoaded( event : Event ) : void
    {
        sequenceLoader.removeEventListener( Event.COMPLETE, onBackgroundLoaded );
        var job : LoadByteArrayJob = sequenceLoader.getJobByName(BACKGROUND_JOB_ID);
        projectModel.stadustSim.backgroundImage = job.content;
        projectModel.stadustSim.backgroundRawData = job.byteArray;
        projectModel.stadustSim.backgroundFileName = job.fileName;

        dispatcher.dispatchEvent( new RefreshBackgroundViewEvent() );

        if (projectModel.stadustSim.backgroundImage is MovieClip)
        {
            dispatcher.dispatchEvent( new StartSimEvent() );
        }
    }
}
}
