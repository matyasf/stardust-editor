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

import idv.cjcat.stardustextended.common.emitters.Emitter;
import idv.cjcat.stardustextended.common.xml.XMLBuilder;

import idv.cjcat.stardustextended.flashdisplay.handlers.DisplayObjectSpriteSheetHandler;
import idv.cjcat.stardustextended.twoD.starling.StarlingHandler;

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
        var emitterXml : XML = XMLBuilder.buildXML( originalEmitter.emitter );
        var emitter : Emitter = EmitterBuilder.buildEmitter(emitterXml, emitterXml);
        var emitterData : EmitterValueObject = new EmitterValueObject(emitter);
        emitter.name = uniqueID.toString();
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

        if (emitterData.emitter.particleHandler is StarlingHandler)
        {
            StarlingHandler(emitterData.emitter.particleHandler).container = Globals.starlingCanvas;
            dispatcher.dispatchEvent(new RegenerateEmitterTexturesEvent());
        }
        else
        {
            DisplayObjectSpriteSheetHandler(emitterData.emitter.particleHandler).container = Globals.canvas;
        }

        // display data for the new emitter
        dispatcher.dispatchEvent( new ChangeEmitterInFocusEvent( ChangeEmitterInFocusEvent.CHANGE, emitterData ) );

        dispatcher.dispatchEvent( new StartSimEvent() );
    }

}
}
