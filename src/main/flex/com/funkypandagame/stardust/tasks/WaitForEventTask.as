package com.funkypandagame.stardust.tasks
{

import flash.events.Event;
import flash.utils.getQualifiedClassName;

public class WaitForEventTask extends AsyncTask
{
    private var _eventString : String;
    private var _eventClass : Class;

    public function WaitForEventTask(eventString : String, eventClass : Class = null)
    {
        if (!(eventClass.prototype instanceof Event))
        {
            throw new Error("This class can be only used with Flash events");
        }
        _eventString = eventString;
        _eventClass = eventClass;
    }

    override public function execute() : void
    {
        waitForEvent(_eventString, _eventClass);
    }

    override public function getLabel() : String
    {
        return "WaitForEventTask " + getQualifiedClassName(_eventClass) + " with type "+ _eventString;
    }
}
}
