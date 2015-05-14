package com.funkypandagame.stardust.controller
{

import com.funkypandagame.stardust.controller.events.RegenerateEmitterTexturesEvent;
import com.funkypandagame.stardust.controller.events.StartSimEvent;
import com.funkypandagame.stardust.controller.events.UpdateDisplayModeEvent;
import com.funkypandagame.stardust.helpers.Globals;
import com.funkypandagame.stardust.helpers.ParticleHandlerCopyHelper;
import com.funkypandagame.stardust.model.ProjectModel;
import com.funkypandagame.stardustplayer.SimPlayer;
import com.funkypandagame.stardust.model.DisplayModes;
import com.funkypandagame.stardustplayer.emitter.EmitterValueObject;

import flash.events.IEventDispatcher;

import idv.cjcat.stardustextended.common.emitters.Emitter;
import idv.cjcat.stardustextended.flashdisplay.handlers.DisplayObjectSpriteSheetHandler;
import idv.cjcat.stardustextended.twoD.handlers.ISpriteSheetHandler;
import idv.cjcat.stardustextended.twoD.starling.StarlingHandler;
import robotlegs.bender.extensions.commandCenter.api.ICommand;

public class UpdateDisplayModeCommand implements ICommand
{
    [Inject]
    public var event : UpdateDisplayModeEvent;

    [Inject]
    public var dispatcher : IEventDispatcher;

    [Inject]
    public var projectSettings : ProjectModel;

    [Inject]
    public var simPlayer : SimPlayer;

    public function execute() : void
    {
        Globals.starlingCanvas.removeChildren();
        projectSettings.stadustSim.resetSimulation();
        switch ( event.mode )
        {
            case DisplayModes.DISPLAY_LIST :
                setDisplayModeDisplayList();
                break;
            case DisplayModes.STARLING :
                setDisplayModeStarling();
            break;
        }

        dispatcher.dispatchEvent(new RegenerateEmitterTexturesEvent());

        dispatcher.dispatchEvent( new StartSimEvent());
    }

    private function setDisplayModeDisplayList() : void
    {
        for each( var emVO : EmitterValueObject in projectSettings.stadustSim.emitters )
        {
            if (emVO.emitter.particleHandler is StarlingHandler)
            {
                StarlingHandler(emVO.emitter.particleHandler).textures[0].root.dispose();
            }
            var handler : DisplayObjectSpriteSheetHandler = new DisplayObjectSpriteSheetHandler();
            ParticleHandlerCopyHelper.copyHandlerProperties(ISpriteSheetHandler(emVO.emitter.particleHandler), handler);
            emVO.emitter.particleHandler = handler;
        }
        simPlayer.setRenderTarget(Globals.canvas);
    }

    private function setDisplayModeStarling() : void
    {
        for each( var emitter : Emitter in projectSettings.stadustSim.emittersArr )
        {
            var starlingHandler : StarlingHandler = new StarlingHandler();
            ParticleHandlerCopyHelper.copyHandlerProperties(ISpriteSheetHandler(emitter.particleHandler), starlingHandler);
            emitter.particleHandler = starlingHandler;
        }
        simPlayer.setRenderTarget(Globals.starlingCanvas);
    }


}
}
