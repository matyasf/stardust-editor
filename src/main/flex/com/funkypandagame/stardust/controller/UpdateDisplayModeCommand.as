package com.funkypandagame.stardust.controller
{

import com.funkypandagame.stardust.controller.events.StartSimEvent;
import com.funkypandagame.stardust.controller.events.UpdateDisplayModeEvent;
import com.funkypandagame.stardust.helpers.Globals;
import com.funkypandagame.stardust.helpers.ParticleHandlerCopyHelper;
import com.funkypandagame.stardust.model.ProjectModel;
import com.funkypandagame.stardustplayer.SimPlayer;
import com.funkypandagame.stardust.model.DisplayModes;
import flash.events.IEventDispatcher;
import idv.cjcat.stardustextended.sd;
import idv.cjcat.stardustextended.twoD.emitters.Emitter2D;
import idv.cjcat.stardustextended.twoD.handlers.DisplayObjectSpriteSheetHandler;
import idv.cjcat.stardustextended.twoD.handlers.ISpriteSheetHandler;
import idv.cjcat.stardustextended.twoD.starling.StarlingHandler;
import robotlegs.bender.extensions.commandCenter.api.ICommand;

use namespace sd;

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
        dispatcher.dispatchEvent( new StartSimEvent());
    }

    private function setDisplayModeDisplayList() : void
    {
        for each( var emitter : Emitter2D in projectSettings.stadustSim.emittersArr )
        {
            if (emitter.particleHandler is StarlingHandler)
            {
                StarlingHandler(emitter.particleHandler).texture.dispose();
            }
            var handler : DisplayObjectSpriteSheetHandler = new DisplayObjectSpriteSheetHandler();
            ParticleHandlerCopyHelper.copyHandlerProperties(ISpriteSheetHandler(emitter.particleHandler), handler);
            emitter.particleHandler = handler;
        }
        simPlayer.setRenderTarget(Globals.canvas);
    }

    private function setDisplayModeStarling() : void
    {
        for each( var emitter : Emitter2D in projectSettings.stadustSim.emittersArr )
        {
            var starlingHandler : StarlingHandler = new StarlingHandler();
            ParticleHandlerCopyHelper.copyHandlerProperties(ISpriteSheetHandler(emitter.particleHandler), starlingHandler);
            emitter.particleHandler = starlingHandler;
        }
        simPlayer.setRenderTarget(Globals.starlingCanvas);
    }


}
}
