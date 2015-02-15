package com.funkypandagame.stardust.view.mediators
{

import com.funkypandagame.stardust.controller.events.BackgroundChangeEvent;
import com.funkypandagame.stardust.model.ProjectModel;
import com.funkypandagame.stardust.view.BackgroundProvider;
import com.funkypandagame.stardust.view.events.RefreshBackgroundViewEvent;

import flash.events.Event;

import robotlegs.bender.bundles.mvcs.Mediator;

public class BackgroundProviderMediator extends Mediator
{
    [Inject]
    public var view : BackgroundProvider;

    [Inject]
    public var projectModel : ProjectModel;

    override public function initialize() : void
    {
        addContextListener( RefreshBackgroundViewEvent.CHANGE, handleModelChange, RefreshBackgroundViewEvent );

        addViewListener( BackgroundChangeEvent.TYPE, handleViewChange, BackgroundChangeEvent );
    }

    private function handleViewChange( event : BackgroundChangeEvent ) : void
    {
        dispatch( event );
    }

    private function handleModelChange( event : RefreshBackgroundViewEvent ) : void
    {
        view.setData(projectModel.hasBackground,
                     projectModel.backgroundColor,
                     projectModel.backgroundImage);
    }

}
}
