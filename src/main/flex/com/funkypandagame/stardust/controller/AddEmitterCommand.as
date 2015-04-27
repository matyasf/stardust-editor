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

import idv.cjcat.stardustextended.flashdisplay.handlers.DisplayObjectSpriteSheetHandler;
import idv.cjcat.stardustextended.twoD.starling.StarlingHandler;

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
            <Age name="Age_0" active="true" mask="1" multiplier="1"/>
            <DeathLife name="DeathLife_0" active="true" mask="1"/>
            <Move name="Move_0" active="true" mask="1" multiplier="1"/>
        </actions>
        <clocks>
            <SteadyClock name="SteadyClock_6" ticksPerCall="1"/>
        </clocks>
        <emitters>
            <Emitter2D name="Default" active="true" clock="SteadyClock_6" particleHandler="DisplayObjectHandler_2">
                <actions>
                    <DeathLife name="DeathLife_0"/>
                    <Age name="Age_0"/>
                    <Move name="Move_0"/>
                </actions>
                <initializers>
                    <PositionAnimated name="PositionAnimated_0"/>
                    <Velocity name="Velocity_0"/>
                    <Life name="Life_0"/>
                </initializers>
            </Emitter2D>
        </emitters>
        <handlers>
            <StarlingHandler name="DisplayObjectHandler_2" premultiplyAlpha="true" blendMode="normal"
                     spriteSheetAnimationSpeed="1" spriteSheetStartAtRandomFrame="false" smoothing="false"/>
        </handlers>
        <initializers>
            <Life name="Life_0" active="true" random="UniformRandom_1"/>
            <PositionAnimated name="PositionAnimated_0" active="true" zone="Line_0" inheritVelocity="false"/>
            <Velocity name="Velocity_0" active="true" zone="SinglePoint_0"/>
        </initializers>
        <randoms>
            <UniformRandom name="UniformRandom_1" center="200" radius="50"/>
        </randoms>
        <zones>
            <Line name="Line_0" rotation="0" virtualThickness="1" x1="10" y1="10" x2="300" y2="10"/>
            <SinglePoint name="SinglePoint_0" rotation="0" virtualThickness="1" x="0" y="2"/>
        </zones>
    </StardustParticleSystem>;

    public function execute() : void
    {
        var uniqueID : uint = 0;
        while ( projectModel.stadustSim.emitters[uniqueID] )
        {
            uniqueID++;
        }
        const emitterData : EmitterValueObject = new EmitterValueObject( uniqueID, EmitterBuilder.buildEmitter(DEFAULT_EMITTER));
        projectModel.stadustSim.emitters[emitterData.id] = emitterData;
        if (projectModel.emitterInFocus.emitter.particleHandler is StarlingHandler)
        {
            var starlingHandler : StarlingHandler = new StarlingHandler();
            starlingHandler.blendMode = BlendMode.NORMAL;
            starlingHandler.spriteSheetAnimationSpeed = 1;
            starlingHandler.container = Globals.starlingCanvas;
            var bd : BitmapData = new BitmapData( 10, 10, false, Math.random()*16777215 );
            projectModel.emitterImages[emitterData.id] = new <BitmapData>[bd];
            emitterData.emitter.particleHandler = starlingHandler;

            dispatcher.dispatchEvent(new RegenerateEmitterTexturesEvent());
        }
        else
        {
            DisplayObjectSpriteSheetHandler(emitterData.emitter.particleHandler).container = Globals.canvas;
        }

        // display data for the new emitter
        dispatcher.dispatchEvent( new ChangeEmitterInFocusEvent( ChangeEmitterInFocusEvent.CHANGE, emitterData ) );

        dispatcher.dispatchEvent( new StartSimEvent() );
    }

}
}
