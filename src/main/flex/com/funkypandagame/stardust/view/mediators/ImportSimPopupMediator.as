package com.funkypandagame.stardust.view.mediators
{

import com.funkypandagame.stardust.controller.events.EmitterImportedEvent;
import com.funkypandagame.stardust.controller.events.ImportSimEvent;
import com.funkypandagame.stardust.view.importSim.ImportSimPopup;
import com.funkypandagame.stardust.view.importSim.ImportedEmitter;

import robotlegs.bender.bundles.mvcs.Mediator;

public class ImportSimPopupMediator extends Mediator {

    [Inject]
    public var view : ImportSimPopup;

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
        var it = items;
        trace("TODO");
        // add emitters
        // trigger refresh?
        // trigger restart sim?
    }

    private function onEmitterImported(evt : EmitterImportedEvent):void
    {
        view.onEmitterImported(evt.emitters);
    }

}
}
