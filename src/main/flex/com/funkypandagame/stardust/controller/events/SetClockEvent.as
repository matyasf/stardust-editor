package com.funkypandagame.stardust.controller.events
{

import flash.events.Event;

import idv.cjcat.stardustextended.handlers.starling.StarlingHandler;

public class SetClockEvent extends Event
{
    public static const TYPE : String = "SetClockEvent_TYPE";

    private var _handler : StarlingHandler;

    public function SetClockEvent()
    {
        super( TYPE );
    }

    override public function clone() : Event
    {
        return new SetClockEvent();
    }

}
}
