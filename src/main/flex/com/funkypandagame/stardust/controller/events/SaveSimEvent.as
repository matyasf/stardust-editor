package com.funkypandagame.stardust.controller.events
{
import flash.events.Event;

public class SaveSimEvent extends Event
{
    public static const SAVE : String = "SaveSimEvent_SAVE";

    public function SaveSimEvent( type : String )
    {
        super( type );
    }

    override public function clone() : Event
    {
        return new SaveSimEvent( type );
    }
}
}
