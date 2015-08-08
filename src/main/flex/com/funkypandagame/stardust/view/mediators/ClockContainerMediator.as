package com.funkypandagame.stardust.view.mediators
{

import com.funkypandagame.stardust.controller.events.SetClockEvent;
import com.funkypandagame.stardust.model.ProjectModel;
import com.funkypandagame.stardust.view.stardust.common.clocks.ClockContainer;

import robotlegs.bender.bundles.mvcs.Mediator;

public class ClockContainerMediator extends Mediator
{
    [Inject]
    public var view : ClockContainer;

    [Inject]
    public var model : ProjectModel;

    override public function initialize() : void
    {
        addContextListener( SetClockEvent.TYPE, handleClockContainerUpdateFromEmitter, SetClockEvent );
    }

    private function handleClockContainerUpdateFromEmitter( event : SetClockEvent ) : void
    {
        view.setData( model.emitterInFocus.emitter );
    }

}
}
