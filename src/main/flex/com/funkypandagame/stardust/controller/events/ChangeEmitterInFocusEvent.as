package com.funkypandagame.stardust.controller.events
{
import com.funkypandagame.stardustplayer.emitter.EmitterValueObject;

import flash.events.Event;

public class ChangeEmitterInFocusEvent extends Event
{
    public static const CHANGE : String = "ChangeEmitterInFocusEvent_CHANGE";

    private var _emitter : EmitterValueObject;

    public function ChangeEmitterInFocusEvent( type : String, emitter : EmitterValueObject )
    {
        super( type );
        _emitter = emitter;
    }

    override public function clone() : Event
    {
        return new ChangeEmitterInFocusEvent( type, emitter );
    }

    public function get emitter() : EmitterValueObject
    {
        return _emitter;
    }
}
}
