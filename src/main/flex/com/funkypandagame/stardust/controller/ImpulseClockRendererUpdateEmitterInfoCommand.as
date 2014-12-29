package com.funkypandagame.stardust.controller
{
import com.funkypandagame.stardust.model.ProjectModel;
import com.funkypandagame.stardust.view.events.ImpulseClockRendererUpdateEmitterInfoEvent;
import com.funkypandagame.stardustplayer.emitter.EmitterValueObject;

import idv.cjcat.stardustextended.common.clocks.ImpulseClock;

import robotlegs.bender.extensions.commandCenter.api.ICommand;

public class ImpulseClockRendererUpdateEmitterInfoCommand implements ICommand
{
    [Inject]
    public var projectSetting : ProjectModel;

    [Inject]
    public var event : ImpulseClockRendererUpdateEmitterInfoEvent;

    public function execute() : void
    {
        const info : EmitterValueObject = projectSetting.emitterInFocus;
        ImpulseClock(info.emitter.clock).impulseCount = event.numParticles;
        ImpulseClock(info.emitter.clock).repeatCount = event.numBursts;
        ImpulseClock(info.emitter.clock).burstInterval = event.burstInterval;
    }
}
}