package com.funkypandagame.stardust.view.events
{
import flash.events.Event;

import idv.cjcat.stardustextended.common.clocks.ImpulseClock;

public class UpdateClockInEmitterGroupEvent extends Event
{
    private var _clock : ImpulseClock;
    public static const UPDATE : String = "UpdateClockInEmitterGroupEvent_UPDATE";

    public function UpdateClockInEmitterGroupEvent( type : String, clock : ImpulseClock )
    {
        super( type );
        _clock = clock;
    }

    override public function clone() : Event
    {
        return new UpdateClockInEmitterGroupEvent( type, _clock );
    }

    public function get clock() : ImpulseClock
    {
        return _clock;
    }
}
}
