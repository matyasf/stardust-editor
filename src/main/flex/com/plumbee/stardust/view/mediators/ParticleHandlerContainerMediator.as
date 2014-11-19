package com.plumbee.stardust.view.mediators
{

import com.plumbee.stardust.controller.events.SetParticleHandlerEvent;
import com.plumbee.stardust.controller.events.StartSimEvent;
import com.plumbee.stardust.controller.events.UpdateDisplayModeEvent;
import com.plumbee.stardust.model.ProjectModel;
import com.plumbee.stardust.view.ParticleHandlerContainer;
import com.plumbee.stardust.view.events.LoadEmitterImageFromFileEvent;

import flash.events.Event;

import robotlegs.bender.bundles.mvcs.Mediator;

public class ParticleHandlerContainerMediator extends Mediator
{
    [Inject]
    public var view : ParticleHandlerContainer;

    [Inject]
    public var projectModel : ProjectModel;

    override public function initialize() : void
    {
        addViewListener( UpdateDisplayModeEvent.UPDATE, redispatchEvent, UpdateDisplayModeEvent );
        addViewListener( LoadEmitterImageFromFileEvent.TYPE, redispatchEvent, LoadEmitterImageFromFileEvent );
        addViewListener( StartSimEvent.START, redispatchEvent, StartSimEvent );

        addContextListener( SetParticleHandlerEvent.TYPE, setParticleHandler, SetParticleHandlerEvent );
    }

    private function setParticleHandler( event : SetParticleHandlerEvent ) : void
    {
        view.handler = event.handler;
    }

    private function redispatchEvent( event : Event ) : void
    {
        dispatch( event );
    }

}
}
