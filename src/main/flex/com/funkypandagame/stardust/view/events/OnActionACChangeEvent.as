package com.funkypandagame.stardust.view.events
{
import flash.events.Event;

import idv.cjcat.stardustextended.actions.Action;

public class OnActionACChangeEvent extends Event
{

    private var _action : Action;
    public static const ADD : String = "OnActionACChangeEvent_ADD";
    public static const REMOVE : String = "OnActionACChangeEvent_REMOVE";

    public function OnActionACChangeEvent( type : String, action : Action )
    {
        super( type );
        _action = action;
    }

    override public function clone() : Event
    {
        return new OnActionACChangeEvent( type, _action );
    }

    public function get action() : Action
    {
        return _action;
    }
}
}
