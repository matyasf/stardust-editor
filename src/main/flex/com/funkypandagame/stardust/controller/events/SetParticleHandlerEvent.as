package com.funkypandagame.stardust.controller.events
{

import flash.events.Event;

import idv.cjcat.stardustextended.twoD.starling.StarlingHandler;

public class SetParticleHandlerEvent extends Event
{
    public static const TYPE : String = "SetParticleHandlerEvent_TYPE";

    private var _handler : StarlingHandler;

    public function SetParticleHandlerEvent( handler : StarlingHandler )
    {
        super( TYPE );
        _handler = handler;
    }

    public function get handler():StarlingHandler
    {
        return _handler;
    }

    override public function clone() : Event
    {
        return new SetParticleHandlerEvent( _handler );
    }

}
}
