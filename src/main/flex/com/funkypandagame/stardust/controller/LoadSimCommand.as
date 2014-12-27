package com.funkypandagame.stardust.controller
{

import com.funkypandagame.stardust.controller.events.LoadSimEvent;
import com.funkypandagame.stardust.controller.events.RefreshFPSTextEvent;
import com.funkypandagame.stardust.controller.events.StartSimEvent;
import com.funkypandagame.stardust.helpers.Globals;
import com.funkypandagame.stardust.model.ProjectModel;
import com.funkypandagame.stardust.view.events.RefreshBackgroundViewEvent;
import com.funkypandagame.stardustplayer.ISimLoader;
import com.funkypandagame.stardustplayer.SimPlayer;
import com.funkypandagame.stardustplayer.emitter.EmitterValueObject;

import flash.display.DisplayObject;

import flash.events.Event;

import flash.events.IEventDispatcher;

import idv.cjcat.stardustextended.twoD.handlers.DisplayObjectSpriteSheetHandler;
import idv.cjcat.stardustextended.twoD.handlers.ISpriteSheetHandler;
import idv.cjcat.stardustextended.twoD.starling.StarlingHandler;

import mx.core.FlexGlobals;

import robotlegs.bender.extensions.commandCenter.api.ICommand;

import spark.components.Alert;

public class LoadSimCommand implements ICommand
{
    [Inject]
    public var simLoader : ISimLoader;

    [Inject]
    public var dispatcher : IEventDispatcher;

    [Inject]
    public var projectSettings : ProjectModel;

    [Inject]
    public var event : LoadSimEvent;

    [Inject]
    public var simPlayer : SimPlayer;

    public function execute() : void
    {
        try
        {
            simLoader.addEventListener(Event.COMPLETE, onLoaded);
            simLoader.loadSim( event.sdeFile );
        }
        catch (err: Error)
        {
            Alert.show("Unable to load simulation. " + err.toString(), "ERROR");
        }
    }

    private function onLoaded(event : Event) : void
    {
        simLoader.removeEventListener(Event.COMPLETE, onLoaded);

        if ( projectSettings.stadustSim )
        {
            for each (var oldEmitterVO : EmitterValueObject in projectSettings.stadustSim.emitters)
            {
                oldEmitterVO.emitter.clearActions();
                oldEmitterVO.emitter.clearInitializers();
                oldEmitterVO.emitter.clearParticles();
                if (oldEmitterVO.emitter.particleHandler is StarlingHandler)
                {
                    const sh : StarlingHandler = StarlingHandler(oldEmitterVO.emitter.particleHandler);
                    sh.texture.dispose();
                    Globals.starlingCanvas.removeChild(sh.renderer);
                }
            }
        }

        projectSettings.stadustSim = simLoader.project;
        for each (var emitterVO : EmitterValueObject in projectSettings.stadustSim.emitters)
        {
            projectSettings.emitterInFocus = emitterVO;
            break;
        }
        const handler : ISpriteSheetHandler = ISpriteSheetHandler(projectSettings.emitterInFocus.emitter.particleHandler);
        if (handler is DisplayObjectSpriteSheetHandler)
        {
            simPlayer.setSimulation( projectSettings.stadustSim, Globals.canvas);
        }
        else if (projectSettings.emitterInFocus.emitter.particleHandler is StarlingHandler)
        {
            simPlayer.setSimulation( projectSettings.stadustSim, Globals.starlingCanvas);
        }

        dispatcher.dispatchEvent( new RefreshBackgroundViewEvent() );

        DisplayObject(FlexGlobals.topLevelApplication).stage.frameRate = projectSettings.stadustSim.fps;
        dispatcher.dispatchEvent( new RefreshFPSTextEvent() );

        dispatcher.dispatchEvent( new StartSimEvent() );
    }


}
}
