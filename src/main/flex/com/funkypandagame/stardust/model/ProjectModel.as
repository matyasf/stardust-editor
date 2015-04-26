package com.funkypandagame.stardust.model
{

import com.funkypandagame.stardustplayer.emitter.EmitterValueObject;
import com.funkypandagame.stardustplayer.project.ProjectValueObject;

import flash.display.DisplayObject;

import flash.utils.ByteArray;
import flash.utils.Dictionary;

public class ProjectModel
{

    public var emitterInFocus : EmitterValueObject;

    public var stadustSim : ProjectValueObject;

    public var backgroundColor : uint;

    public var hasBackground : Boolean;

    public var backgroundImage : DisplayObject;

    public var backgroundRawData : ByteArray;

    public var fps : Number;

    public var emitterImages : Dictionary;

}
}