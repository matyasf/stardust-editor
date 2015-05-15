package com.funkypandagame.stardust.controller
{

import com.funkypandagame.stardust.helpers.ZoneDrawer;
import com.funkypandagame.stardust.model.ProjectModel;
import com.funkypandagame.stardust.view.StardusttoolMainView;
import com.funkypandagame.stardust.view.events.MainEnterFrameLoopEvent;
import com.funkypandagame.stardustplayer.SimPlayer;
import flash.utils.getTimer;

import idv.cjcat.stardustextended.twoD.starling.StardustStarlingRenderer;

import robotlegs.bender.extensions.commandCenter.api.ICommand;

// TODO this needs to be a service, since calcTime needs to be preserved between runs
public class MainEnterFrameLoopCommand implements ICommand
{

    [Inject]
    public var event : MainEnterFrameLoopEvent;

    [Inject]
    public var project : ProjectModel;

    [Inject]
    public var simPlayer : SimPlayer;

    public static var calcTime : uint;
    private static var count : uint;

    public function execute() : void
    {
        const view : StardusttoolMainView = event.view;
        const startTime : Number = getTimer();
        if ( calcTime > 1000 )
        {
            view.infoLabel.text = "ERROR:Simulation time above 1000ms (" + calcTime + "ms), stopping. Change the sim and restart";
            return;
        }

        simPlayer.stepSimulation();

        calcTime = (getTimer() - startTime);
        if (count % 4 == 0)
        {
            view.infoLabel.text = "num particles: " + project.stadustSim.numberOfParticles + " sim time: " + calcTime;
        }
        if (project.stadustSim.numberOfParticles > StardustStarlingRenderer.MAX_POSSIBLE_PARTICLES)
        {
            view.infoLabel.text += " Particles over " + StardustStarlingRenderer.MAX_POSSIBLE_PARTICLES + " will not be rendered.";
        }
        if ( view.zonesVisibleCheckBox.selected )
        {
            ZoneDrawer.drawZones();
        }
        else
        {
            view.previewGroup.graphics.clear();
        }
        count++;
    }
}
}
