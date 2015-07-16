package com.funkypandagame.stardust.controller.events
{

import flash.events.Event;
import flash.utils.ByteArray;

public class LoadSimEvent extends Event
{
    public static const LOAD : String = "LoadSimEvent_LOAD";
    private var _sdeFile : ByteArray;
    private var _nameToDisplay : String;

    public function LoadSimEvent( sdeFileToLoad : ByteArray, nameToDisplay : String )
    {
        _sdeFile = sdeFileToLoad;
        _nameToDisplay = nameToDisplay;
        super( LOAD );
    }

    override public function clone() : Event
    {
        return new LoadSimEvent(_sdeFile, _nameToDisplay);
    }

    public function get sdeFile() : ByteArray
    {
        return _sdeFile;
    }

    public function get nameToDisplay() : String
    {
        return _nameToDisplay;
    }
}
}
