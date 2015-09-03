package com.funkypandagame.stardust.tasks
{

import flash.utils.Dictionary;

import robotlegs.bender.framework.api.IInjector;

public class TaskFactory
{
    [Inject]
    public var injector : IInjector;

    private var _pools : Dictionary = new Dictionary();
    private var _instanceMap : Dictionary = new Dictionary();

    public function getTask(task : Class) : Task
    {
        _pools[task] ||= new LoanShark(task, true, 0, 0, injector);

        var instance : Task = (_pools[task] as LoanShark).borrowObject();

        _instanceMap[instance] = _pools[task];

        return instance;
    }

    public function returnTask(taskInstance : Task) : void
    {
        (_instanceMap[taskInstance] as LoanShark).returnObject(taskInstance);

        delete _instanceMap[taskInstance];
    }
}
}
