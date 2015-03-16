package com.funkypandagame.stardust.controller.events
{
import com.funkypandagame.stardustplayer.emitter.EmitterValueObject;

import flash.events.Event;

import idv.cjcat.stardustextended.twoD.emitters.Emitter2D;

public class UpdateClockContainerFromEmitter extends Event
{
    public static const UPDATE : String = "UpdateClockContainerFromEmitter";
    private var _emitter : EmitterValueObject;

    public function UpdateClockContainerFromEmitter( type : String, emitter : EmitterValueObject )
    {
        super( type );
        _emitter = emitter;
    }

    override public function clone() : Event
    {
        return new UpdateClockContainerFromEmitter( type, _emitter );
    }

    public function get emitter() : EmitterValueObject
    {
        return _emitter;
    }
}
}
