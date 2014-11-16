package com.plumbee.stardust.controller.events
{
import flash.events.Event;

public class UpdateDisplayModeEvent extends Event
{
    public static const UPDATE : String = "UpdateDisplayModeEvent_UPDATE";

    private var _mode : String;

    public function UpdateDisplayModeEvent(mode : String )
    {
        super( UPDATE );
        _mode = mode;
    }

    override public function clone() : Event
    {
        return new UpdateDisplayModeEvent( _mode );
    }

    public function get mode() : String
    {
        return _mode;
    }
}
}
