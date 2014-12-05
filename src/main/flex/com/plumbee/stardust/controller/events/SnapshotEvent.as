package com.plumbee.stardust.controller.events {

import flash.events.Event;

public class SnapshotEvent extends Event{

    public static const TYPE : String = "SnapshotEvent";

    private var _takeSnapshot : Boolean;

    public function SnapshotEvent( __takeSnapshot : Boolean )
    {
        super( TYPE );
        _takeSnapshot = __takeSnapshot;
    }

    public function get takeSnapshot() : Boolean
    {
        return _takeSnapshot;
    }

    override public function clone() : Event
    {
        return new SnapshotEvent( _takeSnapshot );
    }
}
}
