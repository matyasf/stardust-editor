package com.funkypandagame.stardust.view.events
{
import flash.events.Event;

public class MainViewLoadSimEvent extends Event
{
    public static const LOAD : String = "MainViewLoadSimEvent_LOAD";

    public function MainViewLoadSimEvent( type : String )
    {
        super( type );
    }

    override public function clone() : Event
    {
        return new MainViewLoadSimEvent( type );
    }
}
}
