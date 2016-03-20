package com.funkypandagame.stardust.controller.events
{

import flash.events.Event;

public class ConvertOldSimEvent extends Event
{
    public static const TYPE : String = "ConvertOldSimEvent";

    public function ConvertOldSimEvent( )
    {
        super( TYPE );
    }

    override public function clone() : Event
    {
        return new ConvertOldSimEvent();
    }
}
}
