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

    private static const DEFAULT_EMITTER : XML =
    <StardustParticleSystem version="2.1">
        <actions>
            <Age name="Age_1" active="true" multiplier="1"/>
            <DeathLife name="DeathLife_1" active="true"/>
            <Move name="Move_1" active="true" multiplier="1"/>
        </actions>
        <initializers>
            <Alpha name="Alpha_1" active="true" random="UniformRandom_42"/>
            <Life name="Life_1" active="true" random="UniformRandom_41"/>
            <Mass name="Mass_1" active="true" random="UniformRandom_46"/>
            <Omega name="Omega_1" active="true" random="UniformRandom_45"/>
            <PositionAnimated name="PositionAnimated_1" active="true" inheritVelocity="false">
                <zones>
                    <Line name="Line_5"/>
                </zones>
            </PositionAnimated>
            <Rotation name="Rotation_1" active="true" random="UniformRandom_44"/>
            <Scale name="Scale_1" active="true" random="UniformRandom_43"/>
            <Velocity name="Velocity_1" active="true">
                <zones>
                    <SinglePoint name="SinglePoint_3"/>
                </zones>
            </Velocity>
        </initializers>
        <emitters>
            <Emitter2D name="0" active="true" clock="SteadyClock_3" particleHandler="StarlingHandler_1" fps="60">
                <actions>
                    <DeathLife name="DeathLife_1"/>
                    <Age name="Age_1"/>
                    <Move name="Move_1"/>
                </actions>
                <initializers>
                    <PositionAnimated name="PositionAnimated_1"/>
                    <Velocity name="Velocity_1"/>
                    <Life name="Life_1"/>
                    <Alpha name="Alpha_1"/>
                    <Scale name="Scale_1"/>
                    <Rotation name="Rotation_1"/>
                    <Omega name="Omega_1"/>
                    <Mass name="Mass_1"/>
                </initializers>
            </Emitter2D>
        </emitters>
        <zones>
            <Line name="Line_5" rotation="0" virtualThickness="1" x1="10" y1="10" x2="300" y2="10"/>
            <SinglePoint name="SinglePoint_3" rotation="0" virtualThickness="1" x="0" y="100"/>
        </zones>
        <handlers>
            <StarlingHandler name="StarlingHandler_1" spriteSheetAnimationSpeed="1"
                             spriteSheetStartAtRandomFrame="false" smoothing="true" blendMode="normal" premultiplyAlpha="true"/>
        </handlers>
        <clocks>
            <SteadyClock name="SteadyClock_3" ticksPerCall="50" initialDelay="UniformRandom_40"/>
        </clocks>
        <randoms>
            <UniformRandom name="UniformRandom_40" center="0" radius="0"/>
            <UniformRandom name="UniformRandom_41" center="3" radius="1"/>
            <UniformRandom name="UniformRandom_42" center="1" radius="0"/>
            <UniformRandom name="UniformRandom_43" center="1" radius="0"/>
            <UniformRandom name="UniformRandom_44" center="0" radius="0"/>
            <UniformRandom name="UniformRandom_45" center="0" radius="0"/>
            <UniformRandom name="UniformRandom_46" center="1" radius="0"/>
        </randoms>
    </StardustParticleSystem>;

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
