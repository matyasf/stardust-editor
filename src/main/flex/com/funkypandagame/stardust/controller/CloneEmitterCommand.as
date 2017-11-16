package com.funkypandagame.stardust.controller
{

import com.funkypandagame.stardust.controller.events.ChangeEmitterInFocusEvent;
import com.funkypandagame.stardust.controller.events.RegenerateEmitterTexturesEvent;
import com.funkypandagame.stardust.controller.events.StartSimEvent;
import com.funkypandagame.stardust.helpers.Globals;
import com.funkypandagame.stardust.model.ProjectModel;
import com.funkypandagame.stardustplayer.emitter.EmitterBuilder;
import com.funkypandagame.stardustplayer.emitter.EmitterValueObject;

import flash.display.BitmapData;

import flash.events.IEventDispatcher;
import flash.utils.ByteArray;

import idv.cjcat.stardustextended.actions.Action;

import idv.cjcat.stardustextended.emitters.Emitter;
import idv.cjcat.stardustextended.json.JsonBuilder;

import idv.cjcat.stardustextended.actions.Spawn;
import idv.cjcat.stardustextended.handlers.starling.StarlingHandler;

import robotlegs.bender.extensions.commandCenter.api.ICommand;

public class CloneEmitterCommand implements ICommand
{
    [Inject]
    public var projectModel : ProjectModel;

    [Inject]
    public var dispatcher : IEventDispatcher;

    public function execute() : void
    {
        var uniqueID : uint = 0;
        while ( projectModel.stadustSim.emitters[uniqueID] )
        {
            uniqueID++;
        }
        var originalEmitter : EmitterValueObject = projectModel.emitterInFocus;
        var emitterXml : String = JsonBuilder.buildJson( originalEmitter.emitter );
        var emitter : Emitter = EmitterBuilder.buildEmitter(emitterXml, uniqueID.toString());
        var emitterData : EmitterValueObject = new EmitterValueObject(emitter);
        emitter.name = uniqueID.toString();

        for each (var action : Action in emitter.actions)
        {
            if (action is Spawn && Spawn(action).spawnerEmitterId)
            {
                var spawnAction : Spawn = Spawn(action);
                for each (var emVO : EmitterValueObject in projectModel.stadustSim.emitters)
                {
                    if (spawnAction.spawnerEmitterId == emVO.id)
                    {
                        spawnAction.spawnerEmitter = emVO.emitter;
                    }
                }
            }
        }

        projectModel.stadustSim.emitters[emitterData.id] = emitterData;

        // TODO reuse the original one
        var images : Vector.<BitmapData> = Vector.<BitmapData>(projectModel.emitterImages[originalEmitter.id]);
        var cloneImages : Vector.<BitmapData> = new Vector.<BitmapData>();
        for (var i : int = 0; i < images.length; i++)
        {
            cloneImages.push(images[i].clone());
        }
        projectModel.emitterImages[emitterData.id] = cloneImages;
        if (originalEmitter.emitterSnapshot)
        {
            var cloneBA : ByteArray = new ByteArray();
            originalEmitter.emitterSnapshot.position = 0;
            cloneBA.writeBytes(originalEmitter.emitterSnapshot, 0, originalEmitter.emitterSnapshot.length);
            originalEmitter.emitterSnapshot.position = 0;
            cloneBA.position = 0;
            emitterData.emitterSnapshot = cloneBA;
        }

        StarlingHandler(emitterData.emitter.particleHandler).container = Globals.starlingCanvas;
        dispatcher.dispatchEvent(new RegenerateEmitterTexturesEvent());

        // display data for the new emitter
        dispatcher.dispatchEvent( new ChangeEmitterInFocusEvent( ChangeEmitterInFocusEvent.CHANGE, emitterData ) );

        dispatcher.dispatchEvent( new StartSimEvent() );
    }

}
}
