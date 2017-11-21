package com.funkypandagame.stardust.helpers
{

import com.funkypandagame.stardust.view.stardust.twoD.actions.AccelerationZoneAction;
import com.funkypandagame.stardust.view.stardust.twoD.actions.AgeAction;
import com.funkypandagame.stardust.view.stardust.twoD.actions.ColorCurveAdvancedAction;
import com.funkypandagame.stardust.view.stardust.twoD.actions.DeathLifeAction;
import com.funkypandagame.stardust.view.stardust.twoD.actions.DeathZoneAction;
import com.funkypandagame.stardust.view.stardust.twoD.actions.DeflectAction;
import com.funkypandagame.stardust.view.stardust.twoD.actions.FollowWaypointsAction;
import com.funkypandagame.stardust.view.stardust.twoD.actions.GravityAction;
import com.funkypandagame.stardust.view.stardust.twoD.actions.MoveAction;
import com.funkypandagame.stardust.view.stardust.twoD.actions.NormalDriftAction;
import com.funkypandagame.stardust.view.stardust.twoD.actions.OrientedAction;
import com.funkypandagame.stardust.view.stardust.twoD.actions.RandomDriftAction;
import com.funkypandagame.stardust.view.stardust.twoD.actions.ScaleAnimatedAction;
import com.funkypandagame.stardust.view.stardust.twoD.actions.SpawnAction;
import com.funkypandagame.stardust.view.stardust.twoD.actions.SpeedLimitAction;
import com.funkypandagame.stardust.view.stardust.twoD.actions.SpinAction;
import com.funkypandagame.stardust.view.stardust.twoD.actions.VelocityFieldAction;
import com.funkypandagame.stardust.view.stardust.twoD.actions.areas.CircleAreaView;
import com.funkypandagame.stardust.view.stardust.twoD.actions.areas.EverythingAreaView;
import com.funkypandagame.stardust.view.stardust.twoD.actions.areas.RectAreaView;
import com.funkypandagame.stardust.view.stardust.twoD.actions.areas.SectorAreaView;
import com.funkypandagame.stardust.view.stardust.twoD.actions.triggers.DeathTriggerRenderer;
import com.funkypandagame.stardust.view.stardust.twoD.actions.triggers.LifeTriggerRenderer;
import com.funkypandagame.stardust.view.stardust.twoD.zones.CircleContourZone;
import com.funkypandagame.stardust.view.stardust.twoD.zones.LineZone;
import com.funkypandagame.stardust.view.stardust.twoD.zones.RectContourZone;
import com.funkypandagame.stardust.view.stardust.twoD.zones.RectZone;
import com.funkypandagame.stardust.view.stardust.twoD.zones.SectorZone;
import com.funkypandagame.stardust.view.stardust.twoD.zones.SinglePointZone;

import flash.events.Event;

import flash.events.IEventDispatcher;
import flash.events.TextEvent;

import flash.utils.Dictionary;

import idv.cjcat.stardustextended.actions.Age;
import idv.cjcat.stardustextended.actions.ColorGradient;
import idv.cjcat.stardustextended.actions.DeathLife;
import idv.cjcat.stardustextended.actions.ScaleAnimated;
import idv.cjcat.stardustextended.actions.areas.CircleArea;
import idv.cjcat.stardustextended.actions.areas.EverythingArea;
import idv.cjcat.stardustextended.actions.areas.RectArea;
import idv.cjcat.stardustextended.actions.areas.SectorArea;
import idv.cjcat.stardustextended.actions.triggers.DeathTrigger;
import idv.cjcat.stardustextended.actions.triggers.LifeTrigger;
import idv.cjcat.stardustextended.actions.AccelerationArea;
import idv.cjcat.stardustextended.actions.DeathArea;
import idv.cjcat.stardustextended.actions.Deflect;
import idv.cjcat.stardustextended.actions.FollowWaypoints;
import idv.cjcat.stardustextended.actions.Gravity;
import idv.cjcat.stardustextended.actions.Move;
import idv.cjcat.stardustextended.actions.NormalDrift;
import idv.cjcat.stardustextended.actions.Oriented;
import idv.cjcat.stardustextended.actions.RandomDrift;
import idv.cjcat.stardustextended.actions.Spawn;
import idv.cjcat.stardustextended.actions.SpeedLimit;
import idv.cjcat.stardustextended.actions.Spin;
import idv.cjcat.stardustextended.actions.VelocityField;
import idv.cjcat.stardustextended.zones.CircleContour;
import idv.cjcat.stardustextended.zones.CircleZone;
import idv.cjcat.stardustextended.zones.Line;
import idv.cjcat.stardustextended.zones.RectContour;
import idv.cjcat.stardustextended.zones.Sector;
import idv.cjcat.stardustextended.zones.SinglePoint;

import mx.collections.ArrayCollection;
import mx.collections.Sort;
import mx.collections.SortField;

import starling.display.BlendMode;
import starling.display.Sprite;

public class Globals
{
    public static const starlingCanvas : Sprite = new Sprite();
    public static var isRunningInAIR : Boolean;

    public static const actionDict : Dictionary = new Dictionary();
    public static const actionsDDLAC : ArrayCollection = new ArrayCollection();

    public static const zonesDict : Dictionary = new Dictionary();
    public static const zonesDDLAC : ArrayCollection = new ArrayCollection();

    public static const areasDict : Dictionary = new Dictionary();
    public static const areasDDLAC : ArrayCollection = new ArrayCollection();

    public static const triggersDict : Dictionary = new Dictionary();
    public static const triggersDDLAC : ArrayCollection = new ArrayCollection();

    // caught by the AIR wrapper
    public static const EXTERNAL_SET_SIM_NAME_EVENT : String = "setSimName"; //sets the window title
    public static const EXTERNAL_LOAD_FILE_EVENT : String = "loadFile"; // wrapper loads the file, so it can cache the path

    public static var externalEventDispatcher : IEventDispatcher; // dispatches events to the external AIR app
    public static var currentFileName : String;

    public static const blendModesStarling : ArrayCollection = new ArrayCollection( [
        BlendMode.NORMAL,
        BlendMode.MULTIPLY,
        BlendMode.SCREEN,
        BlendMode.ADD,
        BlendMode.ERASE,
        BlendMode.BELOW
    ] );

    public static function init() : void
    {
        actionDict[ Move ] = new DropdownListVO( "Simulation speed", Move, MoveAction );
        actionDict[ DeathArea ] = new DropdownListVO( "Death zone", DeathArea, DeathZoneAction );
        actionDict[ RandomDrift ] = new DropdownListVO( "Random acceleration", RandomDrift, RandomDriftAction );
        actionDict[ Oriented ] = new DropdownListVO( "Orient to velocity", Oriented, OrientedAction );
        actionDict[ Age ] = new DropdownListVO( "Change age", Age, AgeAction );
        actionDict[ DeathLife ] = new DropdownListVO( "Death on life end", DeathLife, DeathLifeAction );
        actionDict[ SpeedLimit ] = new DropdownListVO( "Speed limit", SpeedLimit, SpeedLimitAction );
        actionDict[ Spin ] = new DropdownListVO( "Rotate", Spin, SpinAction );
        actionDict[ FollowWaypoints ] = new DropdownListVO( "Follow waypoints", FollowWaypoints, FollowWaypointsAction );
        actionDict[ Deflect ] = new DropdownListVO( "Deflect/bounce", Deflect, DeflectAction );
        actionDict[ Gravity ] = new DropdownListVO( "Gravity (acceleration) field", Gravity, GravityAction );
        actionDict[ VelocityField ] = new DropdownListVO( "Velocity field", VelocityField, VelocityFieldAction );
        actionDict[ NormalDrift ] = new DropdownListVO( "Perpendicular acceleration", NormalDrift, NormalDriftAction );
        actionDict[ AccelerationArea ] = new DropdownListVO( "Acceleration zone", AccelerationArea, AccelerationZoneAction );
        actionDict[ ColorGradient ] = new DropdownListVO( "Color/Alpha curve", ColorGradient, ColorCurveAdvancedAction );
        actionDict[ Spawn ] = new DropdownListVO("Spawn particles", Spawn, SpawnAction);
        actionDict[ ScaleAnimated ] = new DropdownListVO( "Change Scale", ScaleAnimated, ScaleAnimatedAction );
        //actionDict[ CompositeAction ] = new DropdownListVO("Action group", CompositeAction, CompositeActionAction);
        //actionDict[ MutualGravity ] = new DropdownListVO( "Mutual gravity (CPU intensive)", MutualGravity, MutualGravityAction );
        //actionDict[ Collide ] = new DropdownListVO( "Collide (CPU intensive)", Collide, CollideAction );

        zonesDict[Line] = new DropdownListVO("Line", Line, LineZone);
        zonesDict[SinglePoint] = new DropdownListVO("Point", SinglePoint, SinglePointZone);
        zonesDict[idv.cjcat.stardustextended.zones.RectZone] = new DropdownListVO("Rectangle", idv.cjcat.stardustextended.zones.RectZone, com.funkypandagame.stardust.view.stardust.twoD.zones.RectZone);
        zonesDict[RectContour] = new DropdownListVO("Rectangle contour", RectContour, RectContourZone);
        zonesDict[idv.cjcat.stardustextended.zones.CircleZone] = new DropdownListVO("Circle", idv.cjcat.stardustextended.zones.CircleZone, com.funkypandagame.stardust.view.stardust.twoD.zones.CircleZone);
        zonesDict[CircleContour] = new DropdownListVO("Circle contour", CircleContour, CircleContourZone);
        zonesDict[Sector] = new DropdownListVO("Circle sector", Sector, SectorZone);

        areasDict[CircleArea] = new DropdownListVO("Circle area", CircleArea, CircleAreaView);
        areasDict[RectArea] = new DropdownListVO("Rectangular area", RectArea, RectAreaView);
        areasDict[SectorArea] = new DropdownListVO("Sector area", SectorArea, SectorAreaView);
        areasDict[EverythingArea] = new DropdownListVO("Everything", EverythingArea, EverythingAreaView);

        triggersDict[DeathTrigger] = new DropdownListVO("Death trigger", DeathTrigger, DeathTriggerRenderer);
        triggersDict[LifeTrigger] = new DropdownListVO("Life trigger", LifeTrigger, LifeTriggerRenderer);

        var sort : Sort = new Sort();
        sort.fields = [new SortField( "name", true )];

        for each ( var ddlVO : DropdownListVO in actionDict )
        {
            actionsDDLAC.addItem( ddlVO );
        }
        actionsDDLAC.sort = sort;
        actionsDDLAC.refresh();

        for each ( var ddlVO4 : DropdownListVO in zonesDict )
        {
            zonesDDLAC.addItem( ddlVO4 );
        }
        zonesDDLAC.sort = sort;
        zonesDDLAC.refresh();

        for each ( var ddlVO6 : DropdownListVO in areasDict )
        {
            areasDDLAC.addItem( ddlVO6 );
        }
        areasDDLAC.sort = sort;
        areasDDLAC.refresh();

        for each ( var ddlVO5 : DropdownListVO in triggersDict )
        {
            triggersDDLAC.addItem( ddlVO5 );
        }
        triggersDDLAC.sort = sort;
        triggersDDLAC.refresh();

        starlingCanvas.touchable = false;
    }

    public static function dispatchExternalTitleChangeEvent(newTitle : String) : void
    {
        currentFileName = newTitle;
        externalEventDispatcher.dispatchEvent(new TextEvent(EXTERNAL_SET_SIM_NAME_EVENT, true, false, newTitle));
    }

    public static function dispatchExternalLoadSimEvent() : void
    {
        externalEventDispatcher.dispatchEvent(new Event(EXTERNAL_LOAD_FILE_EVENT, true));
    }
}
}
