package com.funkypandagame.stardust.controller
{

import com.funkypandagame.stardust.controller.events.LoadSimEvent;
import com.funkypandagame.stardust.controller.events.RefreshFPSTextEvent;
import com.funkypandagame.stardust.controller.events.StartSimEvent;
import com.funkypandagame.stardust.helpers.Globals;
import com.funkypandagame.stardust.model.ProjectModel;
import com.funkypandagame.stardust.view.events.RefreshBackgroundViewEvent;
import com.funkypandagame.stardustplayer.ISimLoader;
import com.funkypandagame.stardustplayer.SimLoader;
import com.funkypandagame.stardustplayer.SimPlayer;
import com.funkypandagame.stardustplayer.emitter.EmitterValueObject;

import flash.display.DisplayObject;
import flash.display.Loader;
import flash.display.LoaderInfo;

import flash.events.Event;

import flash.events.IEventDispatcher;

import idv.cjcat.stardustextended.flashdisplay.handlers.DisplayObjectSpriteSheetHandler;
import idv.cjcat.stardustextended.twoD.handlers.ISpriteSheetHandler;
import idv.cjcat.stardustextended.twoD.starling.StarlingHandler;

import mx.core.FlexGlobals;

import org.as3commons.zip.Zip;

import robotlegs.bender.extensions.commandCenter.api.ICommand;

import spark.components.Alert;

public class LoadSimCommand implements ICommand
{
    [Inject]
    public var simLoader : ISimLoader;

    [Inject]
    public var dispatcher : IEventDispatcher;

    [Inject]
    public var projectSettings : ProjectModel;

    [Inject]
    public var event : LoadSimEvent;

    [Inject]
    public var simPlayer : SimPlayer;

    private var numLoaded : uint;

    public function execute() : void
    {
        if ( projectSettings.stadustSim )
        {
            projectSettings.stadustSim.destroy();
        }

        numLoaded = 0;
        try
        {
            simLoader.addEventListener(Event.COMPLETE, onSimLoadComplete);
            simLoader.loadSim( event.sdeFile );

            var loadedZip : Zip = new Zip();
            loadedZip.loadBytes( event.sdeFile );

            var descriptorJSON : Object = JSON.parse( loadedZip.getFileByName(SimLoader.DESCRIPTOR_FILENAME).getContentAsString() );
            projectSettings.hasBackground = (descriptorJSON.hasBackground == "true");
            projectSettings.fps = descriptorJSON.fps;
            projectSettings.backgroundColor = descriptorJSON.backgroundColor;

            if (loadedZip.getFileByName(SimLoader.BACKGROUND_FILENAME) != null)
            {
                projectSettings.backgroundRawData = loadedZip.getFileByName(SimLoader.BACKGROUND_FILENAME).content;
                var loader : Loader = new Loader();
                loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onBGLoadComplete );
                loader.loadBytes( projectSettings.backgroundRawData );
            }
            else
            {
                numLoaded++;
            }
        }
        catch (err: Error)
        {
            Alert.show("Unable to load simulation. " + err.toString() + err.getStackTrace(), "ERROR");
        }
    }

    private function onBGLoadComplete( event : Event ) : void
    {
        var loader : LoaderInfo = LoaderInfo(event.target);
        loader.removeEventListener( Event.COMPLETE, onBGLoadComplete );
        projectSettings.backgroundImage = loader.content;
        numLoaded++;
        if (numLoaded == 2)
        {
            onAllLoaded();
        }
    }

    private function onSimLoadComplete( event : Event ) : void
    {
        simLoader.removeEventListener(Event.COMPLETE, onSimLoadComplete);
        numLoaded++;
        if (numLoaded == 2)
        {
            onAllLoaded();
        }
    }

    private function onAllLoaded() : void
    {
        projectSettings.stadustSim = simLoader.createProjectInstance();
        simLoader.dispose();

        for each (var emitterVO : EmitterValueObject in projectSettings.stadustSim.emitters)
        {
            projectSettings.emitterInFocus = emitterVO;
            break;
        }

        simPlayer.setProject( projectSettings.stadustSim);

        const handler : ISpriteSheetHandler = ISpriteSheetHandler(projectSettings.emitterInFocus.emitter.particleHandler);
        if (handler is DisplayObjectSpriteSheetHandler)
        {
            simPlayer.setRenderTarget( Globals.canvas);
        }
        else if (projectSettings.emitterInFocus.emitter.particleHandler is StarlingHandler)
        {
            simPlayer.setRenderTarget( Globals.starlingCanvas);
        }

        dispatcher.dispatchEvent( new RefreshBackgroundViewEvent() );

        DisplayObject(FlexGlobals.topLevelApplication).stage.frameRate = projectSettings.fps;
        dispatcher.dispatchEvent( new RefreshFPSTextEvent() );

        dispatcher.dispatchEvent( new StartSimEvent() );
    }


}
}
