package com.funkypandagame.stardust.controller
{

import com.funkypandagame.stardust.model.ProjectModel;
import com.funkypandagame.stardust.view.events.ClockTypeChangeEvent;
import flash.events.IEventDispatcher;
import idv.cjcat.stardustextended.common.clocks.SteadyClock;

import robotlegs.bender.extensions.commandCenter.api.ICommand;

public class SetEmitterInFocusClockTypeToSteadyCommand implements ICommand
{
    [Inject]
    public var projectSettings : ProjectModel;

    [Inject]
    public var event : ClockTypeChangeEvent;

    [Inject]
    public var dispatcher : IEventDispatcher;

    public function execute() : void
    {
        projectSettings.emitterInFocus.emitter.clock = new SteadyClock( 1 );
    }
}
}
