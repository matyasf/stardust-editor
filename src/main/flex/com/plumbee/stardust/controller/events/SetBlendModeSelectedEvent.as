package com.plumbee.stardust.controller.events
{

import flash.events.Event;

public class SetBlendModeSelectedEvent extends Event
{
    public static const SET_BLEND_MODE : String = "SetBlendModeSelectedEvent_SET_BLEND_MODE";
    private var _targetBlendMode : String;

    public function SetBlendModeSelectedEvent( targetBlendMode : String )
    {
        super(SET_BLEND_MODE);
        _targetBlendMode = targetBlendMode;
    }

    override public function clone() : Event
    {
        return new SetBlendModeSelectedEvent(_targetBlendMode);
    }

    public function get targetBlendMode() : String
    {
        return _targetBlendMode;
    }
}
}
