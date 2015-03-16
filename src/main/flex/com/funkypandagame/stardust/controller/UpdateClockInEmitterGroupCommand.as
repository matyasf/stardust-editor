package com.funkypandagame.stardust.controller
{

import com.funkypandagame.stardust.model.ProjectModel;
import com.funkypandagame.stardust.view.events.UpdateClockInEmitterGroupEvent;

import idv.cjcat.stardustextended.common.emitters.Emitter;

import robotlegs.bender.extensions.commandCenter.api.ICommand;

public class UpdateClockInEmitterGroupCommand implements ICommand
{
    [Inject]
    public var project : ProjectModel;

    [Inject]
    public var event : UpdateClockInEmitterGroupEvent;

    public function execute() : void
    {
        var emitter : Emitter = project.emitterInFocus.emitter;
        emitter.clock = event.clock;
    }
}
}
