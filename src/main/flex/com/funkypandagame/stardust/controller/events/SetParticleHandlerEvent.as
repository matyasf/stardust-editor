package com.funkypandagame.stardust.controller.events
{

import flash.events.Event;

import idv.cjcat.stardustextended.twoD.handlers.ISpriteSheetHandler;

public class SetParticleHandlerEvent extends Event
{
    public static const TYPE : String = "SetParticleHandlerEvent_TYPE";

    private var _handler : ISpriteSheetHandler;

    public function SetParticleHandlerEvent( handler : ISpriteSheetHandler )
    {
        super( TYPE );
        _handler = handler;
    }

    public function get handler():ISpriteSheetHandler
    {
        return _handler;
    }

    override public function clone() : Event
    {
        return new SetParticleHandlerEvent( _handler );
    }

}
}
