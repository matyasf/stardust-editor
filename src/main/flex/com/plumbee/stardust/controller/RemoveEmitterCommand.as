/**
 * Created with IntelliJ IDEA.
 * User: BenP
 * Date: 23/12/13
 * Time: 15:12
 * To change this template use File | Settings | File Templates.
 */
package com.plumbee.stardust.controller
{

import com.plumbee.stardust.controller.events.ChangeEmitterInFocusEvent;
import com.plumbee.stardust.controller.events.StartSimEvent;
import com.plumbee.stardust.helpers.Globals;
import com.plumbee.stardust.model.ProjectModel;
import com.plumbee.stardustplayer.emitter.EmitterValueObject;
import com.plumbee.stardustplayer.project.ProjectValueObject;

import flash.events.IEventDispatcher;
import flash.utils.getQualifiedClassName;

import idv.cjcat.stardustextended.twoD.starling.StarlingHandler;

import mx.logging.ILogger;
import mx.logging.Log;

import robotlegs.bender.extensions.commandCenter.api.ICommand;

public class RemoveEmitterCommand implements ICommand
{

    [Inject]
    public var projectSettings : ProjectModel;

    [Inject]
    public var dispatcher : IEventDispatcher;

    private static const LOG : ILogger = Log.getLogger( getQualifiedClassName( RemoveEmitterCommand ).replace( "::", "." ) );

    public function execute() : void
    {
        const projectObj : ProjectValueObject = projectSettings.stadustSim;
        if (projectObj.numberOfEmitters > 1)
        {
            projectSettings.emitterInFocus.emitter.clearParticles();
            if (projectSettings.emitterInFocus.emitter.particleHandler is StarlingHandler)
            {
                const sh : StarlingHandler = StarlingHandler(projectSettings.emitterInFocus.emitter.particleHandler);
                sh.texture.dispose();
                Globals.starlingCanvas.removeChild(sh.renderer);
            }
            delete projectObj.emitters[projectSettings.emitterInFocus.id];

            for each (var emitter : EmitterValueObject in projectObj.emitters)
            {
                dispatcher.dispatchEvent( new ChangeEmitterInFocusEvent( ChangeEmitterInFocusEvent.CHANGE, emitter ) );
                break;
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
