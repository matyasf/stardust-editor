package com.funkypandagame.stardust.view.events
{
import flash.events.Event;

import idv.cjcat.stardustextended.initializers.Initializer;

public class OnInitializerACChangeEvent extends Event
{
    public static const CHANGE : String = "OnInitializerACChangeEvent_CHANGE";
    public static const ADD : String = "OnInitializerACChangeEvent_ADD";
    public static const REMOVE : String = "OnInitializerACChangeEvent_REMOVE";

    private var _initializer : Initializer;

    public function OnInitializerACChangeEvent( type : String, initializer : Initializer )
    {
        super( type );
        _initializer = initializer;
    }

    override public function clone() : Event
    {
        return new OnInitializerACChangeEvent( type, _initializer );
    }

    public function get initializer() : Initializer
    {
        return _initializer;
    }
}
}
