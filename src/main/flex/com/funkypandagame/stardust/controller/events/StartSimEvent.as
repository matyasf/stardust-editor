package com.funkypandagame.stardust.controller.events
{
import flash.events.Event;

public class StartSimEvent extends Event
{
    public static const START : String = "StartSimEvent_START";

    public function StartSimEvent()
    {
        super( START );
    }

    override public function clone() : Event
    {
        return new StartSimEvent();
    }
}
}
