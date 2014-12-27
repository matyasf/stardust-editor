package com.funkypandagame.stardust.controller
{

import com.funkypandagame.stardust.model.ProjectModel;
import com.funkypandagame.stardust.view.events.UpdateEmitterInfoTicksPerCallEvent;

import idv.cjcat.stardustextended.common.clocks.ImpulseClock;
import idv.cjcat.stardustextended.common.clocks.SteadyClock;

import robotlegs.bender.extensions.commandCenter.api.ICommand;

public class UpdateEmitterInfoTicksPerCallCommand implements ICommand
{

    [Inject]
    public var projectSettings : ProjectModel;

    [Inject]
    public var event : UpdateEmitterInfoTicksPerCallEvent;

    public function execute() : void
    {
        if ( projectSettings.emitterInFocus.emitter.clock is ImpulseClock)
        {
            ImpulseClock(projectSettings.emitterInFocus.emitter.clock).impulseCount = event.ticksPerCall;
        }
        else if (projectSettings.emitterInFocus.emitter.clock is SteadyClock)
        {
            SteadyClock(projectSettings.emitterInFocus.emitter.clock).ticksPerCall = event.ticksPerCall;
        }
    }
}
}
