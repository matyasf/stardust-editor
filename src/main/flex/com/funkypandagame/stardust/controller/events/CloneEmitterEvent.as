package com.funkypandagame.stardust.controller.events
{
import flash.events.Event;

public class CloneEmitterEvent extends Event
{

    public static const TYPE : String = "CloneEmitterEvent";

    public function CloneEmitterEvent()
    {
        super( TYPE );
    }

    override public function clone() : Event
    {
        return new CloneEmitterEvent();
    }
}
}
