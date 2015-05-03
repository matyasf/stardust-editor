package com.funkypandagame.stardust.helpers
{

import com.funkypandagame.stardust.view.stardust.twoD.actions.AccelerateAction;
import com.funkypandagame.stardust.view.stardust.twoD.actions.AccelerationZoneAction;
import com.funkypandagame.stardust.view.stardust.twoD.actions.AgeAction;
import com.funkypandagame.stardust.view.stardust.twoD.actions.AlphaCurveAction;
import com.funkypandagame.stardust.view.stardust.twoD.actions.ColorCurveAction;
import com.funkypandagame.stardust.view.stardust.twoD.actions.ColorCurveAdvancedAction;
import com.funkypandagame.stardust.view.stardust.twoD.actions.DampingAction;
import com.funkypandagame.stardust.view.stardust.twoD.actions.DeathLifeAction;
import com.funkypandagame.stardust.view.stardust.twoD.actions.DeathZoneAction;
import com.funkypandagame.stardust.view.stardust.twoD.actions.DeflectAction;
import com.funkypandagame.stardust.view.stardust.twoD.actions.FollowWaypointsAction;
import com.funkypandagame.stardust.view.stardust.twoD.actions.GravityAction;
import com.funkypandagame.stardust.view.stardust.twoD.actions.MoveAction;
import com.funkypandagame.stardust.view.stardust.twoD.actions.NormalDriftAction;
import com.funkypandagame.stardust.view.stardust.twoD.actions.OrientedAction;
import com.funkypandagame.stardust.view.stardust.twoD.actions.RandomDriftAction;
import com.funkypandagame.stardust.view.stardust.twoD.actions.ScaleCurveAction;
import com.funkypandagame.stardust.view.stardust.twoD.actions.SpeedLimitAction;
import com.funkypandagame.stardust.view.stardust.twoD.actions.SpinAction;
import com.funkypandagame.stardust.view.stardust.twoD.actions.VelocityFieldAction;
import com.funkypandagame.stardust.view.stardust.twoD.initializers.AlphaInitializer;
import com.funkypandagame.stardust.view.stardust.twoD.initializers.ColorInitializer;
import com.funkypandagame.stardust.view.stardust.twoD.initializers.LifeInitializer;
import com.funkypandagame.stardust.view.stardust.twoD.initializers.MassInitializer;
import com.funkypandagame.stardust.view.stardust.twoD.initializers.OmegaInitializer;
import com.funkypandagame.stardust.view.stardust.twoD.initializers.PositionInitializer;
import com.funkypandagame.stardust.view.stardust.twoD.initializers.ScaleInitializer;
import com.funkypandagame.stardust.view.stardust.twoD.initializers.VelocityInitializer;
import com.funkypandagame.stardust.view.stardust.twoD.zones.CircleContourZone;
import com.funkypandagame.stardust.view.stardust.twoD.zones.CompositeZone;
import com.funkypandagame.stardust.view.stardust.twoD.zones.LineZone;
import com.funkypandagame.stardust.view.stardust.twoD.zones.RectContourZone;
import com.funkypandagame.stardust.view.stardust.twoD.zones.RectZone;
import com.funkypandagame.stardust.view.stardust.twoD.zones.SectorZone;
import com.funkypandagame.stardust.view.stardust.twoD.zones.SinglePointZone;

import flash.display.BlendMode;
import flash.utils.Dictionary;

import idv.cjcat.stardustextended.common.actions.Age;
import idv.cjcat.stardustextended.common.actions.AlphaCurve;
import idv.cjcat.stardustextended.common.actions.ColorCurve;
import idv.cjcat.stardustextended.common.actions.ColorGradient;
import idv.cjcat.stardustextended.common.actions.DeathLife;
import idv.cjcat.stardustextended.common.actions.ScaleCurve;
import idv.cjcat.stardustextended.common.initializers.Alpha;
import idv.cjcat.stardustextended.common.initializers.Color;
import idv.cjcat.stardustextended.common.initializers.Life;
import idv.cjcat.stardustextended.common.initializers.Mass;
import idv.cjcat.stardustextended.common.initializers.Scale;
import idv.cjcat.stardustextended.twoD.actions.Accelerate;
import idv.cjcat.stardustextended.twoD.actions.AccelerationZone;
import idv.cjcat.stardustextended.twoD.actions.Damping;
import idv.cjcat.stardustextended.twoD.actions.DeathZone;
import idv.cjcat.stardustextended.twoD.actions.Deflect;
import idv.cjcat.stardustextended.twoD.actions.FollowWaypoints;
import idv.cjcat.stardustextended.twoD.actions.Gravity;
import idv.cjcat.stardustextended.twoD.actions.Move;
import idv.cjcat.stardustextended.twoD.actions.NormalDrift;
import idv.cjcat.stardustextended.twoD.actions.Oriented;
import idv.cjcat.stardustextended.twoD.actions.RandomDrift;
import idv.cjcat.stardustextended.twoD.actions.SpeedLimit;
import idv.cjcat.stardustextended.twoD.actions.Spin;
import idv.cjcat.stardustextended.twoD.actions.VelocityField;
import idv.cjcat.stardustextended.twoD.initializers.Omega;
import idv.cjcat.stardustextended.twoD.initializers.PositionAnimated;
import idv.cjcat.stardustextended.twoD.initializers.Velocity;
import idv.cjcat.stardustextended.twoD.zones.CircleContour;
import idv.cjcat.stardustextended.twoD.zones.CircleZone;
import idv.cjcat.stardustextended.twoD.zones.Composite;
import idv.cjcat.stardustextended.twoD.zones.Line;
import idv.cjcat.stardustextended.twoD.zones.RectContour;
import idv.cjcat.stardustextended.twoD.zones.Sector;
import idv.cjcat.stardustextended.twoD.zones.SinglePoint;

import mx.collections.ArrayCollection;
import mx.collections.Sort;
import mx.collections.SortField;

import starling.display.BlendMode;

public class Globals
{

    public static const canvas : flash.display.Sprite = new flash.display.Sprite();
    public static const starlingCanvas : starling.display.Sprite = new starling.display.Sprite();

    public static const initalizerDict : Dictionary = new Dictionary();
    public static const actionDict : Dictionary = new Dictionary();
    public static const initializerDDLAC : ArrayCollection = new ArrayCollection();
    public static const actionsDDLAC : ArrayCollection = new ArrayCollection();
    public static const zonesDict : Dictionary = new Dictionary();
    public static const zonesDDLAC : ArrayCollection = new ArrayCollection();
    public static const noZeroAreaZonesDDLAC : ArrayCollection = new ArrayCollection();
    public static const blendModesDisplayList : ArrayCollection = new ArrayCollection( [
        flash.display.BlendMode.NORMAL,
        flash.display.BlendMode.LAYER,
        flash.display.BlendMode.MULTIPLY,
        flash.display.BlendMode.SCREEN,
        flash.display.BlendMode.LIGHTEN,
        flash.display.BlendMode.DARKEN,
        flash.display.BlendMode.ADD,
        flash.display.BlendMode.SUBTRACT,
        flash.display.BlendMode.DIFFERENCE,
        flash.display.BlendMode.INVERT,
        flash.display.BlendMode.OVERLAY,
        flash.display.BlendMode.HARDLIGHT,
        flash.display.BlendMode.ALPHA,
        flash.display.BlendMode.ERASE
    ] );

    public static const blendModesStarling : ArrayCollection = new ArrayCollection( [
        starling.display.BlendMode.NORMAL,
        starling.display.BlendMode.MULTIPLY,
        starling.display.BlendMode.SCREEN,
        starling.display.BlendMode.ADD,
        starling.display.BlendMode.ERASE,
        starling.display.BlendMode.BELOW
    ] );

    public static function init() : void
    {
        initalizerDict[ PositionAnimated ] = new DropdownListVO( "Position", PositionAnimated, PositionInitializer );
        initalizerDict[ Velocity ] = new DropdownListVO( "Speed", Velocity, VelocityInitializer );
        initalizerDict[ Life ] = new DropdownListVO( "Life", Life, LifeInitializer );
        initalizerDict[ Alpha ] = new DropdownListVO( "Alpha", Alpha, AlphaInitializer );
        initalizerDict[ Scale ] = new DropdownListVO( "Scale", Scale, ScaleInitializer );
        initalizerDict[ Omega ] = new DropdownListVO( "Rotation speed", Omega, OmegaInitializer );
        initalizerDict[ Mass ] = new DropdownListVO( "Mass", Mass, MassInitializer );

        initalizerDict[ Color ] = new DropdownListVO( "Color(Deprecated)", Color, ColorInitializer );
        //initalizerDict[ CollisionRadius ] = new DropdownListVO( "Collision radius", CollisionRadius, CollisionRadiusInitializer );
        //initalizerDict[ Mask ] = new DropdownListVO("Mask", Mask, MaskInitializer);

        actionDict[ Move ] = new DropdownListVO( "Simulation speed", Move, MoveAction );
        actionDict[ DeathZone ] = new DropdownListVO( "Death zone", DeathZone, DeathZoneAction );
        actionDict[ RandomDrift ] = new DropdownListVO( "Random acceleration", RandomDrift, RandomDriftAction );
        actionDict[ Oriented ] = new DropdownListVO( "Orient to velocity", Oriented, OrientedAction );
        actionDict[ Age ] = new DropdownListVO( "Change age", Age, AgeAction );
        actionDict[ DeathLife ] = new DropdownListVO( "Death on life end", DeathLife, DeathLifeAction );
        actionDict[ ScaleCurve ] = new DropdownListVO( "Change scale", ScaleCurve, ScaleCurveAction );
        actionDict[ Accelerate ] = new DropdownListVO( "Accelerate", Accelerate, AccelerateAction );
        actionDict[ SpeedLimit ] = new DropdownListVO( "Speed limit", SpeedLimit, SpeedLimitAction );
        actionDict[ Spin ] = new DropdownListVO( "Rotate", Spin, SpinAction );
        actionDict[ FollowWaypoints ] = new DropdownListVO( "Follow waypoints", FollowWaypoints, FollowWaypointsAction );
        actionDict[ Deflect ] = new DropdownListVO( "Deflect/bounce", Deflect, DeflectAction );
        actionDict[ Gravity ] = new DropdownListVO( "Gravity (acceleration) field", Gravity, GravityAction );
        actionDict[ VelocityField ] = new DropdownListVO( "Velocity field", VelocityField, VelocityFieldAction );
        actionDict[ NormalDrift ] = new DropdownListVO( "Perpendicular acceleration", NormalDrift, NormalDriftAction );
        actionDict[ AccelerationZone ] = new DropdownListVO( "Acceleration zone", AccelerationZone, AccelerationZoneAction );
        actionDict[ ColorGradient ] = new DropdownListVO( "Color/Alpha curve", ColorGradient, ColorCurveAdvancedAction );

        actionDict[ AlphaCurve ] = new DropdownListVO( "Change alpha(deprecated)", AlphaCurve, AlphaCurveAction );
        actionDict[ ColorCurve ] = new DropdownListVO( "Change color(deprecated)", ColorCurve, ColorCurveAction );
        actionDict[ Damping ] = new DropdownListVO( "Damping(Deprecated)", Damping, DampingAction );
        //actionDict[ DeathTrigger ] = new DropdownListVO("Spawn particles", DeathTrigger, DeathTriggerAction);
        //actionDict[ CompositeAction ] = new DropdownListVO("Action group", CompositeAction, CompositeActionAction);
        //actionDict[ MutualGravity ] = new DropdownListVO( "Mutual gravity (CPU intensive)", MutualGravity, MutualGravityAction );
        //actionDict[ Collide ] = new DropdownListVO( "Collide (CPU intensive)", Collide, CollideAction );

        zonesDict[Line] = new DropdownListVO("Line", Line, LineZone);
        zonesDict[SinglePoint] = new DropdownListVO("Point", SinglePoint, SinglePointZone);
        zonesDict[idv.cjcat.stardustextended.twoD.zones.RectZone] = new DropdownListVO("Rectangle", idv.cjcat.stardustextended.twoD.zones.RectZone, com.funkypandagame.stardust.view.stardust.twoD.zones.RectZone);
        zonesDict[RectContour] = new DropdownListVO("Rectangle contour", RectContour, RectContourZone);
        zonesDict[idv.cjcat.stardustextended.twoD.zones.CircleZone] = new DropdownListVO("Circle", idv.cjcat.stardustextended.twoD.zones.CircleZone, com.funkypandagame.stardust.view.stardust.twoD.zones.CircleZone);
        zonesDict[CircleContour] = new DropdownListVO("Circle contour", CircleContour, CircleContourZone);
        zonesDict[Sector] = new DropdownListVO("Circle sector", Sector, SectorZone);
        zonesDict[Composite] = new DropdownListVO("Composite zone", Composite, CompositeZone);

        for each ( var ddlVO2 : DropdownListVO in initalizerDict )
        {
            if (ddlVO2.stardustClass != Color)
            {
                initializerDDLAC.addItem( ddlVO2 );
            }
        }
        var sort : Sort = new Sort();
        sort.fields = [new SortField( "name", true )];
        initializerDDLAC.sort = sort;
        initializerDDLAC.refresh();

        for each ( var ddlVO : DropdownListVO in actionDict )
        {
            if (ddlVO.stardustClass != Damping && ddlVO.stardustClass != ColorCurve)
            {
                actionsDDLAC.addItem( ddlVO );
            }
        }
        actionsDDLAC.sort = sort;
        actionsDDLAC.refresh();

        for each ( var ddlVO4 : DropdownListVO in zonesDict )
        {
            zonesDDLAC.addItem( ddlVO4 );
        }
        zonesDDLAC.sort = sort;
        zonesDDLAC.refresh();

        noZeroAreaZonesDDLAC.addItem(zonesDict[idv.cjcat.stardustextended.twoD.zones.RectZone]);
        noZeroAreaZonesDDLAC.addItem(zonesDict[idv.cjcat.stardustextended.twoD.zones.CircleZone]);
        noZeroAreaZonesDDLAC.addItem(zonesDict[Sector]);
        noZeroAreaZonesDDLAC.addItem(zonesDict[Composite]);
        noZeroAreaZonesDDLAC.refresh();

        canvas.mouseChildren = canvas.mouseEnabled = false;
        starlingCanvas.touchable = false;
    }


}
}
