package com.funkypandagame.stardust.controller.events
{

import flash.events.Event;

public class RegenerateEmitterTexturesEvent extends Event
{
    public static const TYPE : String = "RegenerateEmitterTexturesEvent";

    public function RegenerateEmitterTexturesEvent()
    {
        super( TYPE );
    }

    override public function clone() : Event
    {
        return new RegenerateEmitterTexturesEvent();
    }
}
}
