/**
 * Created with IntelliJ IDEA.
 * User: BenP
 * Date: 14/01/14
 * Time: 10:29
 * To change this template use File | Settings | File Templates.
 */
package com.funkypandagame.stardust.view.mediators
{

import com.funkypandagame.stardust.controller.events.UpdateClockContainerFromEmitter;
import com.funkypandagame.stardust.view.events.ClockTypeChangeEvent;
import com.funkypandagame.stardust.view.stardust.common.clocks.ClockContainer;

import robotlegs.bender.bundles.mvcs.Mediator;

public class ClockContainerMediator extends Mediator
{
    [Inject]
    public var view : ClockContainer;

    override public function initialize() : void
    {
        addViewListener( ClockTypeChangeEvent.STEADY_CLOCK, handleClockTypeChange, ClockTypeChangeEvent );
        addViewListener( ClockTypeChangeEvent.IMPULSE_CLOCK, handleClockTypeChange, ClockTypeChangeEvent );

        addContextListener( UpdateClockContainerFromEmitter.UPDATE, handleClockContainerUpdateFromEmitter, UpdateClockContainerFromEmitter );
    }

    private function handleClockContainerUpdateFromEmitter( event : UpdateClockContainerFromEmitter ) : void
    {
        view.setData( event.emitter.emitter );
    }

    private function handleClockTypeChange( event : ClockTypeChangeEvent ) : void
    {
        dispatch( event );
    }
}
}
