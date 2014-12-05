package com.plumbee.stardust.controller.events
{
import com.plumbee.stardustplayer.emitter.EmitterValueObject;

import flash.events.Event;

import idv.cjcat.stardustextended.twoD.emitters.Emitter2D;

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
