package com.funkypandagame.stardust.controller
{
import com.funkypandagame.stardust.controller.events.InitCompleteEvent;
import com.funkypandagame.stardust.controller.events.InitalizeZoneDrawerEvent;
import com.funkypandagame.stardust.controller.events.SetParticleHandlerEvent;
import com.funkypandagame.stardust.controller.events.UpdateClockContainerFromEmitter;
import com.funkypandagame.stardust.controller.events.UpdateEmitterDropDownListEvent;
import com.funkypandagame.stardust.controller.events.UpdateEmitterFromViewUICollectionsEvent;
import com.funkypandagame.stardust.model.ProjectModel;
import com.funkypandagame.stardustplayer.SimPlayer;
import com.funkypandagame.stardustplayer.emitter.EmitterValueObject;

import flash.display.MovieClip;
import flash.events.IEventDispatcher;
import flash.utils.getQualifiedClassName;

import idv.cjcat.stardustextended.sd;
import idv.cjcat.stardustextended.twoD.handlers.ISpriteSheetHandler;

import mx.logging.ILogger;
import mx.logging.Log;

import robotlegs.bender.extensions.commandCenter.api.ICommand;

use namespace sd;

public class StartSimCommand implements ICommand
{

    [Inject]
    public var dispatcher : IEventDispatcher;

    [Inject]
    public var simPlayer : SimPlayer;

    private static const LOG : ILogger = Log.getLogger( getQualifiedClassName( StartSimCommand ).replace( "::", "." ) );

    [Inject]
    public var projectSettings : ProjectModel;

    public function execute() : void
    {
        LOG.info( "Restart SIM" );

        simPlayer.resetSimulation();

        // refresh the initializer/action arrayCollections
        dispatcher.dispatchEvent( new UpdateEmitterFromViewUICollectionsEvent( UpdateEmitterFromViewUICollectionsEvent.UPDATE, projectSettings.emitterInFocus ) );

        dispatcher.dispatchEvent( new UpdateClockContainerFromEmitter( UpdateClockContainerFromEmitter.UPDATE, projectSettings.emitterInFocus ) );

        //If the bg is a .swf, restart it so it syncs up with the animated emitter path.
        if (projectSettings.stadustSim.backgroundImage is MovieClip)
        {
            MovieClip(projectSettings.stadustSim.backgroundImage).gotoAndPlay(1);
        }

        //refresh the emitter dropdown list.
        dispatcher.dispatchEvent( new UpdateEmitterDropDownListEvent( UpdateEmitterDropDownListEvent.UPDATE ) );

        //refresh the particle handler properties
        dispatcher.dispatchEvent( new SetParticleHandlerEvent( ISpriteSheetHandler(projectSettings.emitterInFocus.emitter.particleHandler) ) );

        dispatcher.dispatchEvent( new InitalizeZoneDrawerEvent( InitalizeZoneDrawerEvent.RESET ) );

        for each (var emitterValueObject:EmitterValueObject in projectSettings.stadustSim.emitters) {
            if (emitterValueObject.emitterSnapshot)
            {
                emitterValueObject.addParticlesFromSnapshot();
            }
        }
        dispatcher.dispatchEvent( new InitCompleteEvent() );
    }

}
}
