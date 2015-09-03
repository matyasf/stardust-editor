package com.funkypandagame.stardust.controller
{

import com.funkypandagame.stardust.model.ProjectModel;
import com.funkypandagame.stardust.view.events.OnActionACChangeEvent;

import idv.cjcat.stardustextended.actions.Action;

import robotlegs.bender.extensions.commandCenter.api.ICommand;

public class OnActionACAddCommand implements ICommand
{

    [Inject]
    public var event : OnActionACChangeEvent;

    [Inject]
    public var project : ProjectModel;

    public function execute() : void
    {
        project.emitterInFocus.emitter.addAction( Action( event.action ) );
    }
}
}
