package com.funkypandagame.stardust.view.events
{
import flash.events.Event;

public class LoadEmitterImageFromFileEvent extends Event
{
    public static const TYPE : String = "LoadEmitterImageFromFileEvent_LOAD";

    public function LoadEmitterImageFromFileEvent()
    {
        super( TYPE );
    }

    override public function clone() : Event
    {
        return new LoadEmitterImageFromFileEvent();
    }
}
}
