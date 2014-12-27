package com.funkypandagame.stardust.controller.events
{

import flash.events.Event;

public class UpdateEmitterDropDownListEvent extends Event
{
    public static const UPDATE : String = "UpdateEmitterDropDownListEvent_UPDATE";

    public function UpdateEmitterDropDownListEvent( type : String )
    {
        super( type );
    }

    override public function clone() : Event
    {
        return new UpdateEmitterDropDownListEvent( type );
    }
}
}
