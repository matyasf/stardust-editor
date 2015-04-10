package com.funkypandagame.stardust.view.mediators
{

import com.funkypandagame.stardust.controller.events.FileLoadEvent;
import com.funkypandagame.stardust.controller.events.InitCompleteEvent;
import com.funkypandagame.stardust.controller.events.LoadSimEvent;
import com.funkypandagame.stardust.controller.events.SaveSimEvent;
import com.funkypandagame.stardust.controller.events.StartSimEvent;
import com.funkypandagame.stardust.controller.events.InitalizeZoneDrawerEvent;
import com.funkypandagame.stardust.controller.events.UpdateEmitterFromViewUICollectionsEvent;
import com.funkypandagame.stardust.view.StardusttoolMainView;
import com.funkypandagame.stardust.view.events.InitializeZoneDrawerFromEmitterGroupEvent;
import com.funkypandagame.stardust.view.events.MainEnterFrameLoopEvent;
import com.funkypandagame.stardust.view.events.MainViewLoadSimEvent;
import com.funkypandagame.stardust.view.events.MainViewSaveSimEvent;
import com.funkypandagame.stardust.view.events.OnActionACChangeEvent;
import com.funkypandagame.stardust.view.events.OnInitializerACChangeEvent;

import flash.events.Event;
import flash.utils.getQualifiedClassName;

import idv.cjcat.stardustextended.common.actions.Action;

import idv.cjcat.stardustextended.common.initializers.Initializer;

import mx.events.CollectionEvent;
import mx.events.CollectionEventKind;
import mx.logging.ILogger;
import mx.logging.Log;

import robotlegs.bender.bundles.mvcs.Mediator;

public class StardusttoolMainViewMediator extends Mediator
{
    [Inject]
    public var view : StardusttoolMainView;

    private static const LOG : ILogger = Log.getLogger( getQualifiedClassName( StardusttoolMainViewMediator ).replace( "::", "." ) );

    override public function initialize() : void
    {
        addViewListener( MainViewLoadSimEvent.LOAD, handleLoadSim, MainViewLoadSimEvent );
        addViewListener( MainViewSaveSimEvent.SAVE, handleSaveSim, MainViewSaveSimEvent );
        addViewListener( StartSimEvent.START, redispatchEvent, StartSimEvent );
        addViewListener( LoadSimEvent.LOAD, redispatchEvent, LoadSimEvent );

        addContextListener( InitalizeZoneDrawerEvent.RESET, initZoneDrawer, InitalizeZoneDrawerEvent );
        addContextListener( UpdateEmitterFromViewUICollectionsEvent.UPDATE, updateEmitterFromViewUICollections, UpdateEmitterFromViewUICollectionsEvent );
        addContextListener( InitCompleteEvent.TYPE, handleSimInitComplete, InitCompleteEvent );

        //Handle standard view events.
        view.actionAC.addEventListener( CollectionEvent.COLLECTION_CHANGE, onActionACChange );
        view.initializerAC.addEventListener( CollectionEvent.COLLECTION_CHANGE, onInitializerACChange );

        view.stage.addEventListener( Event.RESIZE, onResize );

        view.updateStagePosition();
    }

    private function redispatchEvent(event : Event) : void
    {
        dispatch(event);
    }

    private function onActionACChange(event : CollectionEvent) : void
    {
        if (event.kind == CollectionEventKind.ADD)
        {
            dispatch(new OnActionACChangeEvent(OnActionACChangeEvent.ADD, Action(event.items[0])));
        }
        else if (event.kind == CollectionEventKind.REMOVE)
        {
            dispatch(new OnActionACChangeEvent(OnActionACChangeEvent.REMOVE, Action(event.items[0])));
        }
    }

    private function onInitializerACChange(event : CollectionEvent) : void
    {
        if (event.kind == CollectionEventKind.ADD)
        {
            dispatch(new OnInitializerACChangeEvent(OnInitializerACChangeEvent.ADD, Initializer(event.items[0])));
        }
        else if (event.kind == CollectionEventKind.REMOVE)
        {
            dispatch(new OnInitializerACChangeEvent(OnInitializerACChangeEvent.REMOVE, Initializer(event.items[0])));
        }
    }

    private function handleSimInitComplete( event : InitCompleteEvent ) : void
    {
        view.stage.addEventListener( Event.ENTER_FRAME, onEnterFrame );
    }

    private function handleSaveSim( event : MainViewSaveSimEvent ) : void
    {
        dispatch( new SaveSimEvent( SaveSimEvent.SAVE ) );
    }

    private function handleLoadSim( event : MainViewLoadSimEvent ) : void
    {
        dispatch( new FileLoadEvent() );
    }

    private function initZoneDrawer( event : InitalizeZoneDrawerEvent ) : void
    {
        LOG.info( "init zone drawer" );
        dispatch( new InitializeZoneDrawerFromEmitterGroupEvent( InitializeZoneDrawerFromEmitterGroupEvent.INITIALIZE, view.previewGroup.graphics ) );
    }

    private function updateEmitterFromViewUICollections( event : UpdateEmitterFromViewUICollectionsEvent ) : void
    {
        view.initializerAC.source = event.emitterInFocus.emitter.initializers.concat();
        view.actionAC.source = event.emitterInFocus.emitter.actions.concat();
    }

    private function onResize( event : Event ) : void
    {
        view.resizeStarlingViewPort();
        view.updateStagePosition();
    }

    private function onEnterFrame( event : Event ) : void
    {
        dispatch( new MainEnterFrameLoopEvent( MainEnterFrameLoopEvent.ENTER_FRAME, view ) );
    }
}
}
