package com.funkypandagame.stardust.controller
{
import com.funkypandagame.stardust.controller.events.InitCompleteEvent;
import com.funkypandagame.stardust.controller.events.InitalizeZoneDrawerEvent;
import com.funkypandagame.stardust.controller.events.SetClockEvent;
import com.funkypandagame.stardust.controller.events.SetParticleHandlerEvent;
import com.funkypandagame.stardust.controller.events.UpdateEmitterDropDownListEvent;
import com.funkypandagame.stardust.controller.events.UpdateEmitterFromViewUICollectionsEvent;
import com.funkypandagame.stardust.model.ProjectModel;
import com.funkypandagame.stardustplayer.emitter.EmitterValueObject;

import flash.events.IEventDispatcher;
import flash.utils.getQualifiedClassName;

import idv.cjcat.stardustextended.handlers.starling.StarlingHandler;

import mx.logging.ILogger;
import mx.logging.Log;

import robotlegs.bender.extensions.commandCenter.api.ICommand;

public class StartSimCommand implements ICommand
{

    [Inject]
    public var dispatcher : IEventDispatcher;

    private static const LOG : ILogger = Log.getLogger( getQualifiedClassName( StartSimCommand ).replace( "::", "." ) );

    [Inject]
    public var projectSettings : ProjectModel;

    [Inject]
    public var mainEnterLoop : MainEnterFrameLoopService;

    public function execute() : void
    {
        LOG.info( "Restart SIM" );

        projectSettings.stadustSim.resetSimulation();

        mainEnterLoop.calcTime = 0;
        // refresh the initializer/action arrayCollections
        dispatcher.dispatchEvent( new UpdateEmitterFromViewUICollectionsEvent( UpdateEmitterFromViewUICollectionsEvent.UPDATE, projectSettings.emitterInFocus ) );

        dispatcher.dispatchEvent( new SetClockEvent() );

        //refresh the emitter dropdown lists and the actions/initializer containers.
        dispatcher.dispatchEvent( new UpdateEmitterDropDownListEvent( UpdateEmitterDropDownListEvent.UPDATE ) );

        //refresh the particle handler properties
        dispatcher.dispatchEvent( new SetParticleHandlerEvent( StarlingHandler(projectSettings.emitterInFocus.emitter.particleHandler) ) );

        dispatcher.dispatchEvent( new InitalizeZoneDrawerEvent( InitalizeZoneDrawerEvent.RESET ) );

        for each (var emitterValueObject : EmitterValueObject in projectSettings.stadustSim.emitters)
        {
            if (emitterValueObject.emitterSnapshot)
            {
                emitterValueObject.addParticlesFromSnapshot();
            }
        }
        dispatcher.dispatchEvent( new InitCompleteEvent() );
    }

}
}
