package com.funkypandagame.stardust.controller.events
{

import com.funkypandagame.stardustplayer.project.ProjectValueObject;

import flash.events.Event;
import flash.utils.Dictionary;

public class EmitterImportedEvent extends Event
{
    public static const TYPE : String = "EmitterImportedEvent";
    private var _loadedProject : ProjectValueObject;
    private var _emitterImages : Dictionary;

    public function EmitterImportedEvent( loadedProject : ProjectValueObject, emitterImages : Dictionary )
    {
        _loadedProject = loadedProject;
        _emitterImages = emitterImages;
        super( TYPE );
    }

    public function get loadedProject() : ProjectValueObject
    {
        return _loadedProject;
    }

    public function get emitterImages() : Dictionary
    {
        return _emitterImages;
    }

    override public function clone() : Event
    {
        return new EmitterImportedEvent(_loadedProject, _emitterImages);
    }
}
}
