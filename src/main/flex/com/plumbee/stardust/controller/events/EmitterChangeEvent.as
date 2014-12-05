package com.plumbee.stardust.controller.events
{
import flash.events.Event;

public class EmitterChangeEvent extends Event
{
    public static const ADD : String = "EmitterChangeEvent_ADD";
    public static const REMOVE : String = "EmitterChangeEvent_REMOVE";

    public function EmitterChangeEvent( type : String )
    {
        super( type );
    }

    override public function clone() : Event
    {
        return new EmitterChangeEvent( type );
    }
}
}
