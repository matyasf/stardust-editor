package com.funkypandagame.stardust.controller.events
{

import flash.events.Event;

public class ImportSimEvent extends Event
{
    public static const LOAD : String = "ImportSimEvent_LOAD";

    public function ImportSimEvent()
    {
        super( LOAD );
    }

    override public function clone() : Event
    {
        return new ImportSimEvent();
    }

}
}
