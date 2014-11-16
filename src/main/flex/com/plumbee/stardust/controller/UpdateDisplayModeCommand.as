package com.plumbee.stardust.controller
{

import com.plumbee.stardust.controller.events.StartSimEvent;
import com.plumbee.stardust.controller.events.UpdateDisplayModeEvent;
import com.plumbee.stardust.helpers.Globals;
import com.plumbee.stardust.model.ProjectModel;
import com.plumbee.stardustplayer.SimPlayer;
import com.plumbee.stardustplayer.emitter.EmitterValueObject;
import com.plumbee.stardustplayer.project.DisplayModes;

import flash.events.IEventDispatcher;
import flash.utils.Dictionary;

import idv.cjcat.stardustextended.common.emitters.Emitter;

import idv.cjcat.stardustextended.sd;
import idv.cjcat.stardustextended.twoD.handlers.DisplayObjectSpriteSheetHandler;
import idv.cjcat.stardustextended.twoD.handlers.ISpriteSheetHandler;
import idv.cjcat.stardustextended.twoD.starling.StarlingHandler;

import robotlegs.bender.extensions.commandCenter.api.ICommand;

import starling.display.BlendMode;

import starling.textures.Texture;

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
            var handler : DisplayObjectSpriteSheetHandler = new DisplayObjectSpriteSheetHandler();
            copyHandlerProperties(ISpriteSheetHandler(emitter.particleHandler), handler);
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
            copyHandlerProperties(ISpriteSheetHandler(emitter.particleHandler), starlingHandler);
            starlingHandler.blendMode = getStarlingSafeBlendMode(DisplayObjectSpriteSheetHandler(emitter.particleHandler).blendMode);
            emitter.particleHandler = starlingHandler;
        }
        simPlayer.setRenderTarget(Globals.starlingCanvas);
    }

    private function copyHandlerProperties(from : ISpriteSheetHandler, toHandler : ISpriteSheetHandler) : void
    {
        toHandler.bitmapData = from.bitmapData;
        toHandler.blendMode = from.blendMode;
        toHandler.smoothing = from.smoothing;
        toHandler.spriteSheetAnimationSpeed = from.spriteSheetAnimationSpeed;
        toHandler.spriteSheetSliceHeight = from.spriteSheetSliceHeight;
        toHandler.spriteSheetSliceWidth = from.spriteSheetSliceWidth;
        toHandler.spriteSheetStartAtRandomFrame = from.spriteSheetStartAtRandomFrame;
    }

    private function getStarlingSafeBlendMode(oldBlendMode : String) : String
    {
        var starlingBlendModes : Array = Globals.blendModesStarling.source;
        for ( var i : int = 0; i < starlingBlendModes.length; i++)
        {
            if ( starlingBlendModes[i] == oldBlendMode )
            {
                return oldBlendMode
            }
        }
        return BlendMode.NORMAL;
    }
}
}
