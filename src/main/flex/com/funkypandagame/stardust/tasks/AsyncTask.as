package com.funkypandagame.stardust.tasks
{

import flash.events.Event;
import flash.utils.Dictionary;

import org.osflash.signals.ISignal;

import org.osflash.signals.Signal;

import robotlegs.bender.extensions.commandCenter.api.ICommand;
import robotlegs.bender.extensions.localEventMap.api.IEventMap;
import robotlegs.bender.framework.api.IContext;

public class AsyncTask extends Task
{
    protected var _waitingForEventString : String;

    protected var _waitingForEventClass : Class;

    private var _complete : Signal = new Signal(Task);

    private static var allTasks : Dictionary = new Dictionary();

    [Inject]
    public var eventMap : IEventMap;

    [Inject]
    public var context : IContext;

    // Destroys all the currently existing command chains
    public static function destroyAllTasks() : void
    {
        for each (var task : AsyncTask in allTasks)
        {
            task.context.release(task);
            task._complete.removeAll();
        }
    }

    [PostConstruct]
    public function onInit() : void
    {
        context.detain(this);
        allTasks[this] = this;
    }

    public function get complete() : ISignal // use dispatchCompleteSignal() to dispatch complete signal!
    {
        return _complete;
    }

    public function dispatchCompleteSignal() : void
    {
        delete allTasks[this];
        _complete.dispatch(this);
        context.release(this);
        if (_waitingForEventClass)
        {
            eventMap.unmapListener(eventDispatcher, _waitingForEventString, waitForEventHandler, _waitingForEventClass);
        }
    }

    protected function waitForEvent(eventString : String, eventClass : Class) : ICommand
    {
        _waitingForEventString = eventString;
        _waitingForEventClass = eventClass;

        eventMap.mapListener(eventDispatcher, eventString, waitForEventHandler, eventClass);

        return this;
    }

    private function waitForEventHandler(event : Event) : void
    {
        trace(getLabel() + ": Event " + event.type + " received.");

        eventMap.unmapListener(eventDispatcher, _waitingForEventString, waitForEventHandler, _waitingForEventClass);

        onEventReceived(event);

        dispatchCompleteSignal();
    }

    protected function onEventReceived(event : Event) : void
    {

    }
}
}
