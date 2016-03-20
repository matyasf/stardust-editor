package com.funkypandagame.stardust.controller
{

import com.funkypandagame.stardust.helpers.ZoneDrawer;
import com.funkypandagame.stardust.model.ProjectModel;
import com.funkypandagame.stardust.view.StardusttoolMainView;
import com.funkypandagame.stardustplayer.SimPlayer;
import flash.utils.getTimer;

import idv.cjcat.stardustextended.handlers.starling.StardustStarlingRenderer;

public class MainEnterFrameLoopService
{

    [Inject]
    public var project : ProjectModel;

    [Inject]
    public var simPlayer : SimPlayer;

    public var calcTime : uint;
    private var count : uint;
    private var frameTime : Number = 0;

    public function onEnterFrame(view : StardusttoolMainView) : void
    {
        const startTime : Number = getTimer();
        frameTime = startTime - frameTime;
        if ( frameTime > 1000 )
        {
            frameTime = 0;
        }
        if ( calcTime > 1000 )
        {
            view.infoLabel.text = "ERROR: Simulation time above 1000ms (" + calcTime + "ms), stopping. Change the sim and restart";
            return;
        }

        simPlayer.stepSimulation(frameTime / 1000);

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
            ZoneDrawer.drawEmitterZones();
        }
        else
        {
            view.previewGroup.graphics.clear();
        }
        count++;
        frameTime = getTimer();
    }
}
}
