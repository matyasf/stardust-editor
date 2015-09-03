package com.funkypandagame.stardust.tasks
{
import flash.events.Event;

public class DispatchEventTask extends Task
{
    private var _event : Event;

    public function DispatchEventTask(event : Event)
    {
        _event = event;
    }

    override public function execute() : void
    {
        dispatch(_event);
    }

    override public function getLabel() : String
    {
        return Event(_event).type;
    }
}
}
