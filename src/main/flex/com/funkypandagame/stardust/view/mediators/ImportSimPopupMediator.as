package com.funkypandagame.stardust.view.mediators
{

import com.funkypandagame.stardust.controller.events.ChangeEmitterInFocusEvent;
import com.funkypandagame.stardust.controller.events.EmitterImportedEvent;
import com.funkypandagame.stardust.controller.events.ImportSimEvent;
import com.funkypandagame.stardust.controller.events.RegenerateEmitterTexturesEvent;
import com.funkypandagame.stardust.controller.events.StartSimEvent;
import com.funkypandagame.stardust.helpers.Globals;
import com.funkypandagame.stardust.model.ProjectModel;
import com.funkypandagame.stardust.view.importSim.ImportSimPopup;
import com.funkypandagame.stardust.view.importSim.ImportedEmitter;
import com.funkypandagame.stardustplayer.emitter.EmitterBuilder;
import com.funkypandagame.stardustplayer.emitter.EmitterValueObject;

import flash.display.BitmapData;

import idv.cjcat.stardustextended.emitters.Emitter;

import idv.cjcat.stardustextended.handlers.starling.StarlingHandler;

import mx.managers.PopUpManager;

import robotlegs.bender.bundles.mvcs.Mediator;

import starling.display.BlendMode;

public class ImportSimPopupMediator extends Mediator {

    [Inject]
    public var view : ImportSimPopup;

    [Inject]
    public var projectModel : ProjectModel;

    override public function initialize():void
    {
        view.importClicked.add(onImportClicked);
        view.importSelectedClicked.add(onImportSelectedClicked);

        addContextListener(EmitterImportedEvent.TYPE, onEmitterImported, EmitterImportedEvent);
    }

    private function onImportClicked():void
    {
        dispatch(new ImportSimEvent());
    }

    // Vector of ImportedEmitters, cannot strong type because compiler limitations
    private function onImportSelectedClicked(items : Vector.<Object>):void
    {
        // TODO move this to a command
        for each (var importedEmitter : ImportedEmitter in items) {
            var uniqueID : uint = 0;
            while ( projectModel.stadustSim.emitters[uniqueID] )
            {
                uniqueID++;
            }
            var emitterVo : EmitterValueObject = importedEmitter.emitterVo;
            emitterVo.emitter.name = uniqueID.toString();
            StarlingHandler(emitterVo.emitter.particleHandler).container = Globals.starlingCanvas;

            projectModel.stadustSim.emitters[emitterVo.id] = emitterVo;
            projectModel.emitterImages[emitterVo.id] = importedEmitter.emitterImages;
        }

        dispatch(new RegenerateEmitterTexturesEvent());

        // display data for the new emitter
        dispatch( new ChangeEmitterInFocusEvent( ChangeEmitterInFocusEvent.CHANGE, emitterVo ) );

        dispatch( new StartSimEvent() );

        view.onClose();
    }

    private function onEmitterImported(evt : EmitterImportedEvent):void
    {
        view.onEmitterImported(evt.emitters);
    }

}
}
