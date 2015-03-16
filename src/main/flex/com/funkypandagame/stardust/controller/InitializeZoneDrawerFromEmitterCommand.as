package com.funkypandagame.stardust.controller
{
import com.funkypandagame.stardust.helpers.ZoneDrawer;
import com.funkypandagame.stardust.model.ProjectModel;
import com.funkypandagame.stardust.view.events.InitializeZoneDrawerFromEmitterGroupEvent;

import robotlegs.bender.extensions.commandCenter.api.ICommand;

public class InitializeZoneDrawerFromEmitterCommand implements ICommand
{

    [Inject]
    public var projectSettings : ProjectModel;

    [Inject]
    public var event : InitializeZoneDrawerFromEmitterGroupEvent;

    public function execute() : void
    {
        ZoneDrawer.init( projectSettings.emitterInFocus.emitter, event.targetGraphics );
    }
}
}
