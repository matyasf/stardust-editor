package com.funkypandagame.stardust.controller
{

import com.funkypandagame.stardust.controller.events.StartSimEvent;
import com.funkypandagame.stardust.model.ProjectModel;
import com.funkypandagame.stardustplayer.project.ProjectValueObject;


import flash.events.IEventDispatcher;

import idv.cjcat.stardustextended.actions.Accelerate;

import idv.cjcat.stardustextended.actions.Action;
import idv.cjcat.stardustextended.actions.AlphaCurve;
import idv.cjcat.stardustextended.actions.FollowWaypoints;
import idv.cjcat.stardustextended.actions.Gravity;
import idv.cjcat.stardustextended.actions.IFieldContainer;
import idv.cjcat.stardustextended.actions.RandomDrift;
import idv.cjcat.stardustextended.actions.ScaleCurve;
import idv.cjcat.stardustextended.actions.SpeedLimit;
import idv.cjcat.stardustextended.actions.waypoints.Waypoint;
import idv.cjcat.stardustextended.clocks.ImpulseClock;

import idv.cjcat.stardustextended.clocks.SteadyClock;

import idv.cjcat.stardustextended.emitters.Emitter;
import idv.cjcat.stardustextended.fields.Field;
import idv.cjcat.stardustextended.fields.RadialField;
import idv.cjcat.stardustextended.fields.UniformField;
import idv.cjcat.stardustextended.handlers.ISpriteSheetHandler;

import idv.cjcat.stardustextended.initializers.Initializer;
import idv.cjcat.stardustextended.initializers.Life;
import idv.cjcat.stardustextended.initializers.Omega;
import idv.cjcat.stardustextended.initializers.Velocity;
import idv.cjcat.stardustextended.math.AveragedRandom;
import idv.cjcat.stardustextended.math.Random;
import idv.cjcat.stardustextended.math.UniformRandom;
import idv.cjcat.stardustextended.zones.CircleContour;
import idv.cjcat.stardustextended.zones.CircleZone;
import idv.cjcat.stardustextended.zones.Composite;
import idv.cjcat.stardustextended.zones.Line;
import idv.cjcat.stardustextended.zones.RectContour;
import idv.cjcat.stardustextended.zones.RectZone;
import idv.cjcat.stardustextended.zones.Sector;
import idv.cjcat.stardustextended.zones.Zone;

import mx.logging.ILogger;

import mx.logging.Log;

import robotlegs.bender.extensions.commandCenter.api.ICommand;

public class ConvertOldSimCommand implements ICommand
{

    private static const LOG : ILogger = Log.getLogger( "CONVERTER" );
    [Inject]
    public var projectModel : ProjectModel;

    [Inject]
    public var dispatcher : IEventDispatcher;

    public function execute() : void
    {
        var pvo : ProjectValueObject = projectModel.stadustSim;
        // TODO convert fps
        for each (var em : Emitter in pvo.emittersArr)
        {
            if (em.particleHandler is ISpriteSheetHandler)
            {
                var sh : ISpriteSheetHandler = ISpriteSheetHandler(em.particleHandler);
                sh.spriteSheetAnimationSpeed = 60 / sh.spriteSheetAnimationSpeed;
            }
            if (em.clock is SteadyClock)
            {
                var sClock : SteadyClock = SteadyClock(em.clock);
                convertRandom(sClock.initialDelay, 1/60);
                sClock.ticksPerCall = sClock.ticksPerCall * 60;
            }
            else if (em.clock is ImpulseClock)
            {
                var iClock : ImpulseClock = ImpulseClock(em.clock);
                convertRandom(iClock.initialDelay, 1/60);
                convertRandom(iClock.impulseLength, 1/60);
                convertRandom(iClock.impulseInterval, 1/60);
                iClock.ticksPerCall = iClock.ticksPerCall * 60;
            }
            for each (var init : Initializer in em.initializers)
            {
                if (init is Life)
                {
                    convertRandom(Life(init).random, 1/60);
                }
                else if (init is Velocity)
                {
                    convertZones( Velocity(init).zones, 60 );
                }
                else if (init is Omega)
                {
                    convertRandom( Omega(init).random, 60 );
                }
            }
            for each (var act : Action in em.actions)
            {
                if (act is ScaleCurve)
                {
                    var sc : ScaleCurve = ScaleCurve(act);
                    sc.inLifespan = reducePrecision(sc.inLifespan / 60);
                    sc.outLifespan = reducePrecision(sc.outLifespan / 60);
                }
                if (act is AlphaCurve)
                {
                    var ac : AlphaCurve = AlphaCurve(act);
                    ac.inLifespan = reducePrecision(ac.inLifespan / 60);
                    ac.outLifespan = reducePrecision(ac.outLifespan / 60);
                }
                else if (act is SpeedLimit)
                {
                    SpeedLimit(act).limit = SpeedLimit(act).limit * 60;
                }
                else if (act is RandomDrift)
                {
                    RandomDrift(act).maxX = reducePrecision(RandomDrift(act).maxX * 60);
                    RandomDrift(act).maxY = reducePrecision(RandomDrift(act).maxY * 60);
                }
                else if (act is Gravity)
                {
                    convertFields( Gravity(act), 30); // not accurate
                }
                else if (act is Accelerate)
                {
                    Accelerate(act).acceleration = reducePrecision(Accelerate(act).acceleration * 60);
                }
                else if (act is FollowWaypoints)
                {
                    var wp : FollowWaypoints = FollowWaypoints(act);
                    for each (var waypoint:Waypoint in wp.waypoints)
                    {
                        waypoint.strength = reducePrecision(waypoint.strength * 60);
                    }
                }
            }
        }
        dispatcher.dispatchEvent( new StartSimEvent() );
    }

    private static function convertFields(fieldContainer : IFieldContainer, mult : Number) : void
    {
        for each (var field:Field in fieldContainer.fields)
        {
            if (field is UniformField)
            {
                UniformField(field).x = reducePrecision(UniformField(field).x * mult);
                UniformField(field).y = reducePrecision(UniformField(field).y * mult);
            }
            else if (field is RadialField)
            {
                RadialField(field).x = reducePrecision(RadialField(field).x * mult);
                RadialField(field).y = reducePrecision(RadialField(field).y * mult);
                // strength, attenuationPower are OK?
            }
            else
            {
                // cannot convert
            }
        }
    }

    private static function convertRandom(rnd : Random, mult : Number) : void
    {
        if (rnd is UniformRandom)
        {
            var ur : UniformRandom = UniformRandom(rnd);
            ur.center = reducePrecision(ur.center * mult);
            ur.radius = reducePrecision(ur.radius * mult);
        }
        else if (rnd is AveragedRandom)
        {
            convertRandom( AveragedRandom(rnd).randomObj, mult);
        }
        else
        {
            LOG.error( "unknown Random " + rnd );
        }
    }

    private static function convertZones(zones : Vector.<Zone>, mult : Number) : void
    {
        for each (var z:Zone in zones)
        {
            z.x = reducePrecision(z.x * mult);
            z.y = reducePrecision(z.y * mult);
            if ( z is Line )
            {
                var li : Line = Line( z );
                li.x2 = reducePrecision(li.x2 * mult);
                li.y2 = reducePrecision(li.y2 * mult);
            }
            else if ( z is RectZone )
            {
                var re : RectZone = RectZone( z );
                re.height = reducePrecision(re.height * mult);
                re.width = reducePrecision(re.width * mult);
            }
            else if ( z is RectContour )
            {
                var rc : RectContour = RectContour( z );
                rc.height = reducePrecision(rc.height * mult);
                rc.width = reducePrecision(rc.width * mult);
            }
            else if ( z is CircleZone )
            {
                var cz : CircleZone = CircleZone( z );
                cz.radius = reducePrecision(cz.radius * mult);
            }
            else if ( z is CircleContour )
            {
                var cc : CircleContour = CircleContour( z );
                cc.radius = reducePrecision(cc.radius * mult);
            }
            else if ( z is Sector )
            {
                var se : Sector = Sector( z );
                se.maxRadius = reducePrecision(se.maxRadius * mult);
                se.minRadius = reducePrecision(se.minRadius * mult);
            }
            else if ( z is Composite )
            {
                convertZones(Composite( z ).zones, mult);
            }
            else
            {
                LOG.error( "unknown zone " + z );
            }
        }
    }

    private static function reducePrecision(num : Number) : Number
    {
        return Math.round(num * 100) / 100;
    }

}
}
