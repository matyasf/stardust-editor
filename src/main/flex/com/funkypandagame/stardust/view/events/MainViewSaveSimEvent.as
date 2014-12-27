package com.funkypandagame.stardust.view.events
{
import flash.events.Event;

public class MainViewSaveSimEvent extends Event
{
    public static const SAVE : String = "MainViewSaveSimEvent_SAVE";

    public function MainViewSaveSimEvent( type : String )
    {
        super( type );
    }

    override public function clone() : Event
    {
        return new MainViewSaveSimEvent( type );
    }
}
}
