package com.funkypandagame.stardust.controller.events
{
import flash.events.Event;

public class UpdateClockValuesFromModelEvent extends Event
{
    public static const UPDATE : String = "UpdateClockValuesFromModelEvent_UPDATE";

    public function UpdateClockValuesFromModelEvent( type : String )
    {
        super( type );
    }

    override public function clone() : Event
    {
        return new UpdateClockValuesFromModelEvent( type );
    }
}
}
