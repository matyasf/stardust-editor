package com.funkypandagame.stardust.controller
{

import com.funkypandagame.stardust.controller.events.StartSimEvent;
import com.funkypandagame.stardust.model.ProjectModel;
import com.funkypandagame.stardustplayer.project.ProjectValueObject;
import flash.events.IEventDispatcher;
import mx.logging.ILogger;
import mx.logging.Log;
import robotlegs.bender.extensions.commandCenter.api.ICommand;

public class ConvertOldSimCommand implements ICommand
{

    private static const LOG : ILogger = Log.getLogger( "CONVERTER" );
    [Inject]
    public var projectModel : ProjectModel;

    [Inject]
    public var dispatcher : IEventDispatcher;

    public function execute() : void
    {
        var pvo : ProjectValueObject = projectModel.stadustSim;

        dispatcher.dispatchEvent( new StartSimEvent() );
    }

}
}
