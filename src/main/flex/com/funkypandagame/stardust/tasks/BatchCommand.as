package com.funkypandagame.stardust.tasks
{

import flash.utils.getQualifiedClassName;

import robotlegs.bender.framework.api.IInjector;

public class BatchCommand extends AsyncTask
{
    [Inject]
    public var factory : TaskFactory;

    [Inject]
    public var injector : IInjector;

    private var _tasks : Vector.<Task> = new Vector.<Task>();

    public var isSequence : Boolean;

    private var _current : int = 0;
    private var _desc : String;

    public function BatchCommand(__isSequence : Boolean, desc : String = null)
    {
        isSequence = __isSequence;
        _desc = desc;
    }

    override public function execute() : void
    {
        if (_tasks.length > 0)
        {
            if (isSequence)
            {
                executeTask(_tasks[0])
            }
            else
            {
                for each (var task : Task in _tasks)
                {
                    executeTask(task);
                }
            }
        }
        else
        {
            trace(getLabel() + ": has 0 tasks!");
            dispatchCompleteSignal();
        }
    }

    public function addTask(task : Task) : void
    {
        _tasks.push(task);
    }

    private function next() : void
    {
        _current++;

        if (_current < _tasks.length)
        {
            if (isSequence)
            {
                executeTask(_tasks[_current]);
            }
        }
        else
        {
            trace(getLabel() + ": All complete.");
            dispatchCompleteSignal();
        }
    }

    private function executeTask(taskInstance : Task) : void
    {
        injector.injectInto(taskInstance);

        if (isSequence)
        {
            trace(getLabel() + ": Executing Task " + (_current + 1) + " " + taskInstance.getLabel() + (isAsync ? " (async)" : ""));
        }
        else
        {
            trace(getLabel() + ": Executing Task " + taskInstance.getLabel() + (isAsync ? " (async)" : ""));
        }

        var isAsync : Boolean = taskInstance is AsyncTask;
        if (isAsync)
        {
            (taskInstance as AsyncTask).complete.addOnce(onTaskComplete);
        }
        taskInstance.execute();
        if (!isAsync)
        {
            returnTask(taskInstance);
            next();
        }
    }

    private function onTaskComplete(task : Task) : void
    {
        trace(getLabel() + ": async task " + task.getLabel() + " complete. Total complete: " + (_current + 1));

        returnTask(task);

        next();
    }

    private function returnTask(task : *) : void
    {
        if (_tasks.indexOf(task) < 0)
        {
            factory.returnTask(task);
        }
    }

    override public function getLabel() : String
    {
        var name : String = _desc == null ? getQualifiedClassName(this) : _desc;
        if (isSequence)
        {
            return name + " ("  + _tasks.length + " sequential tasks)";
        }
        return name + " ("  + _tasks.length + " parallel tasks)";
    }

}
}