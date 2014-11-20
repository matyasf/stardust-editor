package com.plumbee.stardust.controller
{

import com.plumbee.stardust.controller.events.StartSimEvent;
import com.plumbee.stardust.controller.events.UpdateDisplayModeEvent;
import com.plumbee.stardust.helpers.Globals;
import com.plumbee.stardust.helpers.ParticleHandlerCopyHelper;
import com.plumbee.stardust.model.ProjectModel;
import com.plumbee.stardustplayer.SimPlayer;
import com.plumbee.stardustplayer.emitter.EmitterValueObject;
import com.plumbee.stardust.model.DisplayModes;
import flash.events.IEventDispatcher;
import flash.utils.Dictionary;
import idv.cjcat.stardustextended.common.emitters.Emitter;
import idv.cjcat.stardustextended.sd;
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
        simPlayer.resetSimulation();
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
        const emitters : Dictionary = projectSettings.stadustSim.emitters;
        for each( var emitterVO : EmitterValueObject in emitters )
        {
            var emitter : Emitter = emitterVO.emitter;
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
        const emitters : Dictionary = projectSettings.stadustSim.emitters;
        for each( var emitterVO : EmitterValueObject in emitters )
        {
            var emitter : Emitter = emitterVO.emitter;
            var starlingHandler : StarlingHandler = new StarlingHandler();
            ParticleHandlerCopyHelper.copyHandlerProperties(ISpriteSheetHandler(emitter.particleHandler), starlingHandler);
            emitter.particleHandler = starlingHandler;
        }
        simPlayer.setRenderTarget(Globals.starlingCanvas);
    }


}
}
