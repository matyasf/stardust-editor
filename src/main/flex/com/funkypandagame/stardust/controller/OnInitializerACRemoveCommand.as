package com.funkypandagame.stardust.controller
{

import com.funkypandagame.stardust.model.ProjectModel;
import com.funkypandagame.stardust.view.events.OnInitializerACChangeEvent;

import idv.cjcat.stardustextended.initializers.Initializer;


import robotlegs.bender.extensions.commandCenter.api.ICommand;

public class OnInitializerACRemoveCommand implements ICommand
{
    [Inject]
    public var project : ProjectModel;

    [Inject]
    public var event : OnInitializerACChangeEvent;

    public function execute() : void
    {
        project.emitterInFocus.emitter.removeInitializer( Initializer( event.initializer ) );
    }
}
}
