package com.funkypandagame.stardust.controller
{

import com.funkypandagame.stardust.controller.events.ChangeEmitterInFocusEvent;
import com.funkypandagame.stardust.controller.events.RegenerateEmitterTexturesEvent;
import com.funkypandagame.stardust.controller.events.StartSimEvent;
import com.funkypandagame.stardust.helpers.Globals;
import com.funkypandagame.stardust.model.ProjectModel;
import com.funkypandagame.stardustplayer.emitter.EmitterValueObject;
import com.funkypandagame.stardustplayer.project.ProjectValueObject;

import flash.events.IEventDispatcher;
import flash.utils.getQualifiedClassName;

import idv.cjcat.stardustextended.twoD.starling.StarlingHandler;

import mx.logging.ILogger;
import mx.logging.Log;

import robotlegs.bender.extensions.commandCenter.api.ICommand;

public class RemoveEmitterCommand implements ICommand
{

    [Inject]
    public var projectModel : ProjectModel;

    [Inject]
    public var dispatcher : IEventDispatcher;

    private static const LOG : ILogger = Log.getLogger( getQualifiedClassName( RemoveEmitterCommand ).replace( "::", "." ) );

    public function execute() : void
    {
        const projectObj : ProjectValueObject = projectModel.stadustSim;
        if (projectObj.numberOfEmitters > 1)
        {
            projectModel.emitterInFocus.emitter.clearParticles();
            if (projectModel.emitterInFocus.emitter.particleHandler is StarlingHandler)
            {
                const sh : StarlingHandler = StarlingHandler(projectModel.emitterInFocus.emitter.particleHandler);
                Globals.starlingCanvas.removeChild(sh.renderer);
            }
            delete projectObj.emitters[projectModel.emitterInFocus.id];
            delete projectModel.emitterImages[projectModel.emitterInFocus.id];

            for each (var emitter : EmitterValueObject in projectObj.emitters)
            {
                dispatcher.dispatchEvent( new ChangeEmitterInFocusEvent( ChangeEmitterInFocusEvent.CHANGE, emitter ) );
                break;
            }
            if (projectModel.emitterInFocus.emitter.particleHandler is StarlingHandler)
            {
                dispatcher.dispatchEvent(new RegenerateEmitterTexturesEvent());
            }

            dispatcher.dispatchEvent( new StartSimEvent() );
        }
        else
        {
            LOG.warn( "Emitter not removed, must be at least one." );
        }
    }
}
}
