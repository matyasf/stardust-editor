/**
 * Created with IntelliJ IDEA.
 * User: BenP
 * Date: 20/12/13
 * Time: 12:40
 * To change this template use File | Settings | File Templates.
 */
package com.plumbee.stardust.view.mediators
{

import com.plumbee.stardust.controller.events.SetBlendModeSelectedEvent;
import com.plumbee.stardust.controller.events.UpdateDisplayModeEvent;
import com.plumbee.stardust.controller.events.SetSmoothingCheckBoxEvent;
import com.plumbee.stardust.helpers.Globals;
import com.plumbee.stardust.model.ProjectModel;
import com.plumbee.stardust.view.ParticleHandlerContainer;
import com.plumbee.stardust.view.events.DisplayModeChangeEvent;
import com.plumbee.stardust.view.events.ParticleHandlerUpdateTextInputFromProjectSettingsEvent;
import com.plumbee.stardust.view.events.UpdateBlendModeEvent;
import com.plumbee.stardust.view.events.UpdateSmoothingEvent;
import com.plumbee.stardustplayer.project.DisplayModes;

import robotlegs.bender.bundles.mvcs.Mediator;

public class ParticleHandlerContainerMediator extends Mediator
{
    [Inject]
    public var view : ParticleHandlerContainer;

    [Inject]
    public var projectModel : ProjectModel;

    override public function initialize() : void
    {
        addViewListener( DisplayModeChangeEvent.CHANGE, handleDisplayModeChange, DisplayModeChangeEvent );
        addViewListener( ParticleHandlerUpdateTextInputFromProjectSettingsEvent.UPDATE, dispatchUpdateTextInput, ParticleHandlerUpdateTextInputFromProjectSettingsEvent );
        addViewListener( UpdateBlendModeEvent.UPDATE, handleUpdateBlendMode, UpdateBlendModeEvent );
        addViewListener( UpdateSmoothingEvent.UPDATE, handleUpdateSmoothing, UpdateSmoothingEvent );

        addContextListener( SetBlendModeSelectedEvent.SET_BLEND_MODE, handleBlendModeChanged, SetBlendModeSelectedEvent );
        addContextListener( SetSmoothingCheckBoxEvent.SET, handleUpdateSmoothingCheckBox, SetSmoothingCheckBoxEvent );
    }

    private function handleDisplayModeChange( event : DisplayModeChangeEvent ) : void
    {
        dispatch( new UpdateDisplayModeEvent( UpdateDisplayModeEvent.UPDATE, event.mode ) );
    }

    private function dispatchUpdateTextInput( event : ParticleHandlerUpdateTextInputFromProjectSettingsEvent ) : void
    {
        dispatch( event );
    }

    private function handleUpdateBlendMode( event : UpdateBlendModeEvent ) : void
    {
        dispatch( event );
    }

    private function handleUpdateSmoothing( event : UpdateSmoothingEvent ) : void
    {
        dispatch( event );
    }

    private function handleBlendModeChanged( event : SetBlendModeSelectedEvent ) : void
    {
        if (projectModel.getDisplayMode() == DisplayModes.STARLING)
        {
            if ( view.blendModesAC != Globals.blendModesStarling )
            {
                view.blendModesAC = Globals.blendModesStarling;
            }
        }
        else
        {
            if ( view.blendModesAC != Globals.blendModesDisplayList )
            {
                view.blendModesAC = Globals.blendModesDisplayList;
            }
        }
        view.setBlendModeListSelectedItem( event.targetBlendMode );
    }

    private function handleUpdateSmoothingCheckBox( event : SetSmoothingCheckBoxEvent ) : void
    {
        view.useSmoothingCheckBox.selected = event.smoothing;
    }
}
}
