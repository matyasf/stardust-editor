package com.funkypandagame.stardust.view.mediators
{
import com.funkypandagame.stardust.controller.events.ChangeEmitterInFocusEvent;
import com.funkypandagame.stardust.controller.events.CloneEmitterEvent;
import com.funkypandagame.stardust.controller.events.EmitterChangeEvent;
import com.funkypandagame.stardust.controller.events.RefreshFPSTextEvent;
import com.funkypandagame.stardust.controller.events.SetResultsForEmitterDropDownListEvent;
import com.funkypandagame.stardust.controller.events.SnapshotEvent;
import com.funkypandagame.stardust.model.ProjectModel;
import com.funkypandagame.stardust.view.EmittersUIView;
import com.funkypandagame.stardust.view.events.EmitterChangeUIViewEvent;

import robotlegs.bender.bundles.mvcs.Mediator;

public class EmittersUIViewMediator extends Mediator
{
    [Inject]
    public var view : EmittersUIView;

    [Inject]
    public var model : ProjectModel;

    override public function initialize() : void
    {
        addViewListener( EmitterChangeUIViewEvent.ADD, handleAddEmitterButton, EmitterChangeUIViewEvent );
        addViewListener( EmitterChangeUIViewEvent.REMOVE, handleRemoveEmitterButton, EmitterChangeUIViewEvent );
        addViewListener( ChangeEmitterInFocusEvent.CHANGE, dispatch, ChangeEmitterInFocusEvent );
        addViewListener( SnapshotEvent.TYPE, dispatch, SnapshotEvent );
        addViewListener( CloneEmitterEvent.TYPE, dispatch, CloneEmitterEvent );
        view.FPSChangedSignal.add(onFPSChanged);

        addContextListener( SetResultsForEmitterDropDownListEvent.UPDATE, handleSetResultsDropDownListEvent, SetResultsForEmitterDropDownListEvent );
        addContextListener( RefreshFPSTextEvent.TYPE, setFPSText, RefreshFPSTextEvent );
    }

    private function onFPSChanged( newFPS : Number ) : void
    {
        model.stadustSim.fps = newFPS;
    }

    private function handleAddEmitterButton( event : EmitterChangeUIViewEvent ) : void
    {
        dispatch( new EmitterChangeEvent( EmitterChangeEvent.ADD ) );
    }

    private function handleRemoveEmitterButton( event : EmitterChangeUIViewEvent ) : void
    {
        dispatch( new EmitterChangeEvent( EmitterChangeEvent.REMOVE ) );
    }

    private function handleSetResultsDropDownListEvent( event : SetResultsForEmitterDropDownListEvent ) : void
    {
        view.setDropDownListResult( event.list, event.emitterInFocus );
    }

    private function setFPSText( event : RefreshFPSTextEvent ) : void
    {
        view.refreshFPSText(model.stadustSim.fps);
    }
}
}
