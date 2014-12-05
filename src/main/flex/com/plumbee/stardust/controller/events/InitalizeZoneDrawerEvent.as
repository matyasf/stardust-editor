package com.plumbee.stardust.controller.events
{
import flash.events.Event;

public class InitalizeZoneDrawerEvent extends Event
{
    public static const RESET : String = "StartSimResetEmitterPropertiesEvent_RESET";

    public function InitalizeZoneDrawerEvent( type : String )
    {
        super( type );
    }

    override public function clone() : Event
    {
        return new InitalizeZoneDrawerEvent( type );
    }
}
}
