package com.funkypandagame.stardust.controller
{

import com.funkypandagame.stardust.model.ProjectModel;
import com.funkypandagame.stardust.view.events.OnInitializerACChangeEvent;

import idv.cjcat.stardustextended.common.initializers.Initializer;

import robotlegs.bender.extensions.commandCenter.api.ICommand;

public class OnInitializerACAddCommand implements ICommand
{
    [Inject]
    public var project : ProjectModel;

    [Inject]
    public var event : OnInitializerACChangeEvent;

    public function execute() : void
    {
        //LOG.debug( "Initializer Added: " + e.items[0] );
        project.emitterInFocus.emitter.addInitializer( Initializer( event.initializer ) );
    }
}
}
