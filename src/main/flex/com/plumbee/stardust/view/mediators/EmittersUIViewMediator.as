package com.plumbee.stardust.view.mediators
{
import com.plumbee.stardust.controller.events.ChangeEmitterInFocusEvent;
import com.plumbee.stardust.controller.events.EmitterChangeEvent;
import com.plumbee.stardust.controller.events.RefreshFPSTextEvent;
import com.plumbee.stardust.controller.events.SetParticleHandlerEvent;
import com.plumbee.stardust.controller.events.SetResultsForEmitterDropDownListEvent;
import com.plumbee.stardust.controller.events.SnapshotEvent;
import com.plumbee.stardust.controller.events.UpdateDisplayModeEvent;
import com.plumbee.stardust.view.EmittersUIView;
import com.plumbee.stardust.view.events.EmitterChangeUIViewEvent;

import flash.events.Event;

import robotlegs.bender.bundles.mvcs.Mediator;

public class EmittersUIViewMediator extends Mediator
{
    [Inject]
    public var view : EmittersUIView;

    override public function initialize() : void
    {
        addViewListener( UpdateDisplayModeEvent.UPDATE, redispatchEvent, UpdateDisplayModeEvent );
        addViewListener( EmitterChangeUIViewEvent.ADD, handleAddEmitterButton, EmitterChangeUIViewEvent );
        addViewListener( EmitterChangeUIViewEvent.REMOVE, handleRemoveEmitterButton, EmitterChangeUIViewEvent );
        addViewListener( ChangeEmitterInFocusEvent.CHANGE, redispatchEvent, ChangeEmitterInFocusEvent );
        addViewListener( SnapshotEvent.TYPE, redispatchEvent, SnapshotEvent );

        addContextListener( SetResultsForEmitterDropDownListEvent.UPDATE, handleSetResultsDropDownListEvent, SetResultsForEmitterDropDownListEvent );
        addContextListener( SetParticleHandlerEvent.TYPE, setParticleHandler, SetParticleHandlerEvent );
        addContextListener( RefreshFPSTextEvent.TYPE, setFPSText, RefreshFPSTextEvent );
    }

    private function redispatchEvent( event : Event ) : void
    {
        dispatch( event );
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

    private function setParticleHandler( event : SetParticleHandlerEvent ) : void
    {
        view.handler = event.handler;
    }

    private function setFPSText( event : RefreshFPSTextEvent ) : void
    {
        view.refreshFPSText();
    }
}
}
