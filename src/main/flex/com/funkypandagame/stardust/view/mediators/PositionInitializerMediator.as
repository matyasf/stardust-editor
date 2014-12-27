package com.funkypandagame.stardust.view.mediators
{
import com.funkypandagame.stardust.view.events.PositionInitializerEmitterPathEvent;

import robotlegs.bender.bundles.mvcs.Mediator;

public class PositionInitializerMediator extends Mediator
{
    override public function initialize() : void
    {
        addViewListener( PositionInitializerEmitterPathEvent.LOAD, handleLoadEmitterPath, PositionInitializerEmitterPathEvent );
    }

    private function handleLoadEmitterPath( event : PositionInitializerEmitterPathEvent ) : void
    {
        dispatch( event );
    }
}
}
