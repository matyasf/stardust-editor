package com.funkypandagame.stardust.tasks
{
import flash.events.TimerEvent;
import flash.utils.Timer;

public class WaitTask extends AsyncTask
{

    private var _timer : Timer;

    public function WaitTask(time : Number)
    {
        _timer = new Timer(time, 1);
        _timer.addEventListener(TimerEvent.TIMER, onTimer);
    }

    override public function execute() : void
    {
        _timer.start();
    }

    private function onTimer(event : TimerEvent) : void
    {
        _timer.reset();
        dispatchCompleteSignal();
    }

    override public function getLabel() : String
    {
        return "WaitTask with delay " + _timer.delay;
    }
}
}
