package com.funkypandagame.stardust.view.mediators
{

import com.funkypandagame.stardust.controller.events.SetParticleHandlerEvent;
import com.funkypandagame.stardust.controller.events.StartSimEvent;
import com.funkypandagame.stardust.model.ProjectModel;
import com.funkypandagame.stardust.view.ParticleHandlerContainer;
import com.funkypandagame.stardust.view.events.LoadEmitterImageFromFileEvent;

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
        addViewListener( LoadEmitterImageFromFileEvent.TYPE, redispatchEvent, LoadEmitterImageFromFileEvent );
        addViewListener( StartSimEvent.START, redispatchEvent, StartSimEvent );

        addContextListener( SetParticleHandlerEvent.TYPE, setParticleHandler, SetParticleHandlerEvent );
    }

    private function setParticleHandler( event : SetParticleHandlerEvent ) : void
    {
        view.setHandler(event.handler, projectModel.emitterImages[projectModel.emitterInFocus.id]);
    }

    private function redispatchEvent( event : Event ) : void
    {
        dispatch( event );
    }

}
}
