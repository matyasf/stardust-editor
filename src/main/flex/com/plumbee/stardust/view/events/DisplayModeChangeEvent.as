package com.plumbee.stardust.view.events
{
import flash.events.Event;

public class DisplayModeChangeEvent extends Event
{
    public static const CHANGE : String = "DisplayModeChangeEvent_CHANGE";
    private var _mode : String;

    public function DisplayModeChangeEvent( mode : String )
    {
        super( CHANGE );
        _mode = mode;
    }

    override public function clone() : Event
    {
        return new DisplayModeChangeEvent( _mode );
    }

    public function get mode() : String
    {
        return _mode;
    }
}
}
