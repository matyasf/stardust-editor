package com.funkypandagame.stardust.view.events
{
import flash.events.Event;

public class PositionInitializerEmitterPathEvent extends Event
{
    public static const LOAD : String = "PositionInitializerEmitterPathEvent_LOAD";


    public function PositionInitializerEmitterPathEvent( type : String )
    {
        super( type );
    }

    override public function clone() : Event
    {
        return new PositionInitializerEmitterPathEvent( type );
    }
}
}
