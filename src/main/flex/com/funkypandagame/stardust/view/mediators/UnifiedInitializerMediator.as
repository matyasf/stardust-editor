package com.funkypandagame.stardust.view.mediators
{

import com.funkypandagame.stardust.controller.events.ChangeEmitterInFocusEvent;
import com.funkypandagame.stardust.controller.events.UpdateEmitterFromViewUICollectionsEvent;
import com.funkypandagame.stardust.view.events.PositionInitializerEmitterPathEvent;
import com.funkypandagame.stardust.view.stardust.twoD.initializers.UnifiedInitializer;

import flash.events.Event;

import robotlegs.bender.bundles.mvcs.Mediator;

public class UnifiedInitializerMediator extends Mediator
{
    [Inject]
    public var view : UnifiedInitializer;

    override public function initialize() : void
    {
        addViewListener( PositionInitializerEmitterPathEvent.LOAD, redispatchEvent, PositionInitializerEmitterPathEvent);
        addContextListener( ChangeEmitterInFocusEvent.CHANGE, updateEmitterData, ChangeEmitterInFocusEvent );
        addContextListener( UpdateEmitterFromViewUICollectionsEvent.UPDATE, updateEmitterInFocus, UpdateEmitterFromViewUICollectionsEvent );
    }

    private function redispatchEvent( event : Event ) : void
    {
        dispatch(event);
    }

    private function updateEmitterData( event : ChangeEmitterInFocusEvent ) : void
    {
        view.setData( event.emitter.emitter );
    }

    private function updateEmitterInFocus( event : UpdateEmitterFromViewUICollectionsEvent ) : void
    {
        view.setData( event.emitterInFocus.emitter );
    }
}
}
