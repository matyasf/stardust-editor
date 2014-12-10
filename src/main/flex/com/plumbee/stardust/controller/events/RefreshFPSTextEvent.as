package com.plumbee.stardust.controller.events
{
import flash.events.Event;

public class RefreshFPSTextEvent extends Event
{
    public static const TYPE : String = "RefreshFPSTextEvent";

    public function RefreshFPSTextEvent()
    {
        super( TYPE );
    }

    override public function clone() : Event
    {
        return new RefreshFPSTextEvent();
    }
}
}
