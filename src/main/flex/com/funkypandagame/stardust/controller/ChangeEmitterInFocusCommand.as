package com.funkypandagame.stardust.controller
{

import com.funkypandagame.stardust.controller.events.ChangeEmitterInFocusEvent;
import com.funkypandagame.stardust.controller.events.StartSimEvent;
import com.funkypandagame.stardust.controller.events.UpdateEmitterDropDownListEvent;
import com.funkypandagame.stardust.model.ProjectModel;

import flash.events.IEventDispatcher;

import robotlegs.bender.extensions.commandCenter.api.ICommand;

public class ChangeEmitterInFocusCommand implements ICommand
{

    [Inject]
    public var dispatcher : IEventDispatcher;

    [Inject]
    public var project : ProjectModel;

    [Inject]
    public var event : ChangeEmitterInFocusEvent;

    public function execute() : void
    {
        project.emitterInFocus = event.emitter;

        //refresh the emitter dropdown list.
        dispatcher.dispatchEvent( new UpdateEmitterDropDownListEvent( UpdateEmitterDropDownListEvent.UPDATE ) );

        dispatcher.dispatchEvent( new StartSimEvent() );
    }
}
}
