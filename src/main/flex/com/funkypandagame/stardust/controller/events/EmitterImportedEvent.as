package com.funkypandagame.stardust.controller.events
{

import com.funkypandagame.stardust.view.importSim.ImportedEmitter;

import flash.events.Event;

public class EmitterImportedEvent extends Event
{
    public static const TYPE : String = "EmitterImportedEvent";
    private var _emitters : Vector.<ImportedEmitter>;

    public function EmitterImportedEvent( emitters : Vector.<ImportedEmitter> )
    {
        _emitters = emitters;
        super( TYPE );
    }

    public function get emitters() : Vector.<ImportedEmitter>
    {
        return _emitters;
    }

    override public function clone() : Event
    {
        return new EmitterImportedEvent(_emitters);
    }
}
}
