package com.funkypandagame.stardust.controller
{

import com.funkypandagame.stardust.controller.events.ChangeEmitterInFocusEvent;
import com.funkypandagame.stardust.controller.events.RegenerateEmitterTexturesEvent;
import com.funkypandagame.stardust.controller.events.StartSimEvent;
import com.funkypandagame.stardust.helpers.Globals;
import com.funkypandagame.stardust.model.ProjectModel;
import com.funkypandagame.stardustplayer.emitter.EmitterBuilder;
import com.funkypandagame.stardustplayer.emitter.EmitterValueObject;

import flash.display.BitmapData;

import flash.events.IEventDispatcher;

import idv.cjcat.stardustextended.emitters.Emitter;

import idv.cjcat.stardustextended.handlers.starling.StarlingHandler;

import robotlegs.bender.extensions.commandCenter.api.ICommand;

import starling.display.BlendMode;

public class AddEmitterCommand implements ICommand
{

    [Inject]
    public var projectModel : ProjectModel;

    [Inject]
    public var dispatcher : IEventDispatcher;

    private static const DEFAULT_EMITTER : String = ( <![CDATA[
            {
                "name": "0",
                "particleHandler": {
                    "name": "StarlingHandler_2",
                    "$type": "StarlingHandler",
                    "spriteSheetStartAtRandomFrame": false,
                    "blendMode": "normal",
                    "premultiplyAlpha": true,
                    "smoothing": true,
                    "spriteSheetAnimationSpeed": 1
                },
                "$type": "Emitter",
                "active": true,
                "clock": {
                    "$type": "SteadyClock",
                    "name": "SteadyClock_5",
                    "ticksPerCall": 50,
                    "initialDelay": {
                        "$type": "UniformRandom",
                        "name": "UniformRandom_69",
                        "center": 0,
                        "radius": 0
                    }
                },
                "fps": 60,
                "initializers": {
                    "$values": [
                        {
                            "name": "PositionAnimated_2",
                            "inheritVelocity": false,
                            "$type": "PositionAnimated",
                            "positions": null,
                            "active": true,
                            "priority": 0,
                            "zones": {
                                "$values": [
                                    {
                                        "name": "Line_10",
                                        "$type": "Line",
                                        "x2": 300,
                                        "y2": 10,
                                        "rotation": 0,
                                        "x": 10,
                                        "y": 10,
                                        "random": {
                                            "$type": "UniformRandom",
                                            "name": "UniformRandom_67",
                                            "center": 0.5,
                                            "radius": 0.5
                                        },
                                        "virtualThickness": 1
                                    }
                                ],
                                "$type": "Array.Zone"
                            }
                        },
                        {
                            "$type": "Velocity",
                            "name": "Velocity_2",
                            "active": true,
                            "priority": 0,
                            "zones": {
                                "$values": [
                                    {
                                        "name": "SinglePoint_5",
                                        "$type": "SinglePoint",
                                        "rotation": 0,
                                        "virtualThickness": 1,
                                        "x": 0,
                                        "y": 100
                                    }
                                ],
                                "$type": "Array.Zone"
                            }
                        },
                        {
                            "$type": "Life",
                            "name": "Life_2",
                            "active": true,
                            "priority": 0,
                            "random": {
                                "$type": "UniformRandom",
                                "name": "UniformRandom_70",
                                "center": 3,
                                "radius": 1
                            }
                        },
                        {
                            "$type": "Alpha",
                            "name": "Alpha_2",
                            "active": true,
                            "priority": 0,
                            "random": {
                                "$type": "UniformRandom",
                                "name": "UniformRandom_71",
                                "center": 1,
                                "radius": 0
                            }
                        },
                        {
                            "$type": "Scale",
                            "name": "Scale_2",
                            "active": true,
                            "priority": 0,
                            "random": {
                                "$type": "UniformRandom",
                                "name": "UniformRandom_72",
                                "center": 1,
                                "radius": 0
                            }
                        },
                        {
                            "$type": "Rotation",
                            "name": "Rotation_2",
                            "active": true,
                            "priority": 0,
                            "random": {
                                "$type": "UniformRandom",
                                "name": "UniformRandom_73",
                                "center": 0,
                                "radius": 0
                            }
                        },
                        {
                            "$type": "Omega",
                            "name": "Omega_2",
                            "active": true,
                            "priority": 0,
                            "random": {
                                "$type": "UniformRandom",
                                "name": "UniformRandom_74",
                                "center": 0,
                                "radius": 0
                            }
                        },
                        {
                            "$type": "Mass",
                            "name": "Mass_2",
                            "active": true,
                            "priority": 0,
                            "random": {
                                "$type": "UniformRandom",
                                "name": "UniformRandom_75",
                                "center": 1,
                                "radius": 0
                            }
                        }
                    ],
                    "$type": "Array.Initializer"
                },
                "actions": {
                    "$values": [
                        {
                            "$type": "DeathLife",
                            "name": "DeathLife_2",
                            "active": true,
                            "priority": 0
                        },
                        {
                            "$type": "Age",
                            "name": "Age_2",
                            "active": true,
                            "multiplier": 1,
                            "priority": 0
                        },
                        {
                            "$type": "Move",
                            "name": "Move_2",
                            "active": true,
                            "multiplier": 1,
                            "priority": -4
                        }
                    ],
                    "$type": "Array.Action"
                }
            } ]]> ).toString();;

    public function execute() : void
    {
        var uniqueID : uint = 0;
        while ( projectModel.stadustSim.emitters[uniqueID] )
        {
            uniqueID++;
        }
        var emitter : Emitter = EmitterBuilder.buildEmitter(DEFAULT_EMITTER, uniqueID.toString());
        const emitterData : EmitterValueObject = new EmitterValueObject(emitter);
        emitter.name = uniqueID.toString();
        projectModel.stadustSim.emitters[emitterData.id] = emitterData;
        var bd : BitmapData = new BitmapData( 10, 10, false, Math.random()*16777215 );
        projectModel.emitterImages[emitterData.id] = new <BitmapData>[bd];

        var starlingHandler : StarlingHandler = new StarlingHandler();
        starlingHandler.blendMode = BlendMode.NORMAL;
        starlingHandler.spriteSheetAnimationSpeed = 1;
        starlingHandler.container = Globals.starlingCanvas;
        emitterData.emitter.particleHandler = starlingHandler;

        dispatcher.dispatchEvent(new RegenerateEmitterTexturesEvent());

        // display data for the new emitter
        dispatcher.dispatchEvent( new ChangeEmitterInFocusEvent( ChangeEmitterInFocusEvent.CHANGE, emitterData ) );

        dispatcher.dispatchEvent( new StartSimEvent() );
    }

}
}
