package com.funkypandagame.stardust.view.events
{
import flash.display.Graphics;
import flash.events.Event;

public class InitializeZoneDrawerFromEmitterGroupEvent extends Event
{
    public static const INITIALIZE : String = "InitializeZoneDrawerFromEmitterGroupEvent_INITIALIZE";

    private var _targetGraphics : Graphics;

    public function InitializeZoneDrawerFromEmitterGroupEvent( type : String, graphics : Graphics )
    {
        super( type );
        _targetGraphics = graphics;
    }

    public function get targetGraphics() : Graphics
    {
        return _targetGraphics;
    }
}
}
