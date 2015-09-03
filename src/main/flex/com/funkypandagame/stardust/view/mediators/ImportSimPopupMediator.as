package com.funkypandagame.stardust.view.mediators
{

import com.funkypandagame.stardust.controller.events.EmitterImportedEvent;
import com.funkypandagame.stardust.controller.events.ImportSimEvent;
import com.funkypandagame.stardust.view.ImportSimPopup;

import robotlegs.bender.bundles.mvcs.Mediator;

public class ImportSimPopupMediator extends Mediator {

    [Inject]
    public var view : ImportSimPopup;

    override public function initialize():void
    {
        view.importClicked.add(onImportClicked);

        addContextListener(EmitterImportedEvent.TYPE, onEmitterImported, EmitterImportedEvent);
    }

    private function onImportClicked():void
    {
        dispatch(new ImportSimEvent());
    }

    private function onEmitterImported(evt : EmitterImportedEvent):void
    {
        view.onEmitterImported(evt.loadedProject, evt.emitterImages);
    }

}
}
