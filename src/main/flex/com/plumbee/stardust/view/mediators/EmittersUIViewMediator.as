/**
 * Created with IntelliJ IDEA.
 * User: BenP
 * Date: 23/12/13
 * Time: 14:35
 * To change this template use File | Settings | File Templates.
 */
package com.plumbee.stardust.view.mediators
{
import com.plumbee.stardust.controller.events.ChangeEmitterInFocusEvent;
import com.plumbee.stardust.controller.events.EmitterChangeEvent;
import com.plumbee.stardust.controller.events.SetParticleHandlerEvent;
import com.plumbee.stardust.controller.events.SetResultsForEmitterDropDownListEvent;
import com.plumbee.stardust.controller.events.UpdateDisplayModeEvent;
import com.plumbee.stardust.view.EmittersUIView;
import com.plumbee.stardust.view.events.EmitterChangeUIViewEvent;
import com.plumbee.stardust.view.events.EmitterNameChangeEvent;

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
        addViewListener( EmitterNameChangeEvent.CHANGE, redispatchEvent, EmitterNameChangeEvent );
        addViewListener( ChangeEmitterInFocusEvent.CHANGE, redispatchEvent, ChangeEmitterInFocusEvent );

        addContextListener( SetResultsForEmitterDropDownListEvent.UPDATE, handleSetResultsDropDownListEvent, SetResultsForEmitterDropDownListEvent );
        addContextListener( SetParticleHandlerEvent.TYPE, setParticleHandler, SetParticleHandlerEvent );
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
}
}
