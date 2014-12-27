package com.funkypandagame.stardust.controller
{
import com.funkypandagame.stardust.controller.events.SetResultsForEmitterDropDownListEvent;
import com.funkypandagame.stardust.model.ProjectModel;
import com.funkypandagame.stardustplayer.emitter.EmitterValueObject;

import flash.events.IEventDispatcher;

import robotlegs.bender.extensions.commandCenter.api.ICommand;

public class UpdateEmitterDropDownListCommand implements ICommand
{

    [Inject]
    public var dispatcher : IEventDispatcher;

    [Inject]
    public var project : ProjectModel;

    public function execute() : void
    {
        var list : Array = [];
        for each (var emitterVO : EmitterValueObject in project.stadustSim.emitters)
        {
            list.push( emitterVO );
        }
        dispatcher.dispatchEvent( new SetResultsForEmitterDropDownListEvent( SetResultsForEmitterDropDownListEvent.UPDATE, list, project.emitterInFocus ) );
    }
}
}
