package com.funkypandagame.stardust.view.events
{
import com.funkypandagame.stardust.view.StardusttoolMainView;

import flash.events.Event;

public class MainEnterFrameLoopEvent extends Event
{
    public static const ENTER_FRAME : String = "MainEnterFrameLoopEvent_ENTER_FRAME";

    private var _view : StardusttoolMainView;

    public function MainEnterFrameLoopEvent( type : String, view : StardusttoolMainView )
    {
        super( type );
        _view = view;
    }

    override public function clone() : Event
    {
        return new MainEnterFrameLoopEvent( type, _view );
    }

    public function get view() : StardusttoolMainView
    {
        return _view;
    }
}
}
