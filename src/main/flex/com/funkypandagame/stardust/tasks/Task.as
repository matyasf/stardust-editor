package com.funkypandagame.stardust.tasks
{

import flash.events.Event;
import flash.events.IEventDispatcher;

import flash.utils.getQualifiedClassName;

import robotlegs.bender.extensions.commandCenter.api.ICommand;
import robotlegs.bender.framework.api.IInjector;

public class Task implements ICommand
{

    [Inject]
    public var eventDispatcher : IEventDispatcher;

    public function Task(injector : IInjector = null)
    {
        if (injector)
        {
            injector.injectInto(this);
        }
    }

    public function execute() : void
    {
        trace("Task.execute() must be overridden!");
    }

    protected function dispatch(event : Event) : void
    {
        if (eventDispatcher && eventDispatcher.hasEventListener(event.type))
        {
            eventDispatcher.dispatchEvent(event);
        }
    }

    public function getLabel() : String
    {
        return getQualifiedClassName(this);
    }
}
}
