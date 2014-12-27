package com.funkypandagame.stardust.controller
{

import com.funkypandagame.stardust.model.ProjectModel;
import com.funkypandagame.stardust.view.events.OnActionACChangeEvent;

import idv.cjcat.stardustextended.common.actions.Action;

import robotlegs.bender.extensions.commandCenter.api.ICommand;

public class OnActionACRemoveCommand implements ICommand
{

    [Inject]
    public var project : ProjectModel;

    [Inject]
    public var event : OnActionACChangeEvent;

    public function execute() : void
    {
        project.emitterInFocus.emitter.removeAction( Action( event.action ) );
    }
}
}
