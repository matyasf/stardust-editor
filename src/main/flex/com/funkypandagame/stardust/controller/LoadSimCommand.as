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
import com.funkypandagame.stardustplayer.SDEConstants;
import com.funkypandagame.stardustplayer.emitter.EmitterValueObject;
import com.funkypandagame.stardustplayer.sequenceLoader.LoadByteArrayJob;
import com.funkypandagame.stardustplayer.sequenceLoader.SequenceLoader;

import flash.display.Bitmap;
import flash.display.BitmapData;

import flash.display.DisplayObject;
import flash.display.Loader;
import flash.display.LoaderInfo;

import flash.events.Event;

import flash.events.IEventDispatcher;
import flash.geom.Point;
import flash.utils.ByteArray;
import flash.utils.Dictionary;

import idv.cjcat.stardustextended.emitters.Emitter;
import idv.cjcat.stardustextended.initializers.Alpha;
import idv.cjcat.stardustextended.initializers.Initializer;
import idv.cjcat.stardustextended.initializers.Life;
import idv.cjcat.stardustextended.initializers.Mass;
import idv.cjcat.stardustextended.initializers.Scale;
import idv.cjcat.stardustextended.initializers.Omega;
import idv.cjcat.stardustextended.initializers.PositionAnimated;
import idv.cjcat.stardustextended.initializers.Rotation;
import idv.cjcat.stardustextended.initializers.Velocity;

import mx.core.FlexGlobals;

import org.as3commons.zip.Zip;

import robotlegs.bender.extensions.commandCenter.api.ICommand;

import spark.components.Alert;

import starling.textures.SubTexture;

import starling.textures.Texture;

import starling.textures.TextureAtlas;

public class LoadSimCommand implements ICommand
{
    [Inject]
    public var simLoader : ISimLoader;

    [Inject]
    public var dispatcher : IEventDispatcher;

    [Inject]
    public var projectModel : ProjectModel;

    [Inject]
    public var event : LoadSimEvent;

    [Inject]
    public var simPlayer : SimPlayer;

    private var numLoaded : uint;

    private var sequenceLoader : SequenceLoader;
    private var loadedZip : Zip;

    public function execute() : void
    {
        if ( projectModel.stadustSim )
        {
            projectModel.stadustSim.destroy();
            simLoader.dispose();
        }

        numLoaded = 0;
        try
        {
            simLoader.addEventListener(Event.COMPLETE, onSimLoadComplete);
            simLoader.loadSim( event.sdeFile );

            loadedZip = new Zip();
            loadedZip.loadBytes( event.sdeFile );

            var descriptorJSON : Object = JSON.parse( loadedZip.getFileByName(SimLoader.DESCRIPTOR_FILENAME).getContentAsString() );
            projectModel.hasBackground = (descriptorJSON.hasBackground == "true");
            projectModel.fps = descriptorJSON.fps;
            projectModel.backgroundColor = descriptorJSON.backgroundColor;

            if (loadedZip.getFileByName(SimLoader.BACKGROUND_FILENAME) != null)
            {
                projectModel.backgroundRawData = loadedZip.getFileByName(SimLoader.BACKGROUND_FILENAME).content;
                var loader : Loader = new Loader();
                loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onBGLoadComplete );
                loader.loadBytes( projectModel.backgroundRawData );
            }
            else
            {
                numLoaded++;
            }
        }
        catch (err: Error)
        {
            Alert.show("Unable to load simulation." + err.toString() + "\n" + err.getStackTrace(), "ERROR");
        }
    }

    private function onBGLoadComplete( event : Event ) : void
    {
        var loader : LoaderInfo = LoaderInfo(event.target);
        loader.removeEventListener( Event.COMPLETE, onBGLoadComplete );
        projectModel.backgroundImage = loader.content;
        checkIfAllLoaded();
    }

    private function onSimLoadComplete( event : Event ) : void
    {
        simLoader.removeEventListener(Event.COMPLETE, onSimLoadComplete);
        projectModel.stadustSim = simLoader.createProjectInstance();
        projectModel.emitterImages = new Dictionary();
        // Reads BDs from the raw atlases image. Store it in a model.
        for (var i : int = 0; i < loadedZip.getFileCount(); i++)
        {
            var loadedFileName : String = loadedZip.getFileAt(i).filename;
            if (loadedFileName == SDEConstants.ATLAS_IMAGE_NAME)
            {
                const loadAtlasJob : LoadByteArrayJob = new LoadByteArrayJob(
                        loadedFileName,
                        loadedFileName,
                        loadedZip.getFileAt(i).content );
                sequenceLoader = new SequenceLoader();
                sequenceLoader.addJob( loadAtlasJob );
                sequenceLoader.addEventListener( Event.COMPLETE, onProjectAtlasLoaded );
                sequenceLoader.loadSequence();
                break;
            }
        }
    }

    private function onProjectAtlasLoaded( event : Event ) : void
    {
        sequenceLoader.removeEventListener( Event.COMPLETE, onProjectAtlasLoaded );
        var job : LoadByteArrayJob = sequenceLoader.getCompletedJobs().pop();
        var atlasXMLBA : ByteArray = loadedZip.getFileByName(SDEConstants.ATLAS_XML_NAME).content;
        var atlasXml : XML = new XML(atlasXMLBA.readUTFBytes(atlasXMLBA.length));
        var atlasBD : BitmapData = Bitmap(job.content).bitmapData;
        var tmpAtlas : TextureAtlas = new TextureAtlas(Texture.empty(1, 1, false, false), atlasXml);

        for each (var emitterValueObject : EmitterValueObject in projectModel.stadustSim.emitters)
        {
            var emitterId : String = emitterValueObject.id;
            if (projectModel.emitterImages[emitterId] == null)
            {
                projectModel.emitterImages[emitterId] = new Vector.<BitmapData>();
            }
            var textures : Vector.<Texture> = tmpAtlas.getTextures(SDEConstants.getSubTexturePrefix(emitterValueObject.id));
            var len : uint = textures.length;
            for ( var k : int = 0; k < len; k++ )
            {
                var tex : SubTexture = textures[k] as SubTexture;
                var singleSprite : BitmapData = new BitmapData( tex.width, tex.height );
                singleSprite.copyPixels( atlasBD, tex.region, new Point( 0, 0 ) );
                projectModel.emitterImages[emitterId].push(singleSprite);
            }
        }
        tmpAtlas.dispose();
        checkIfAllLoaded();
    }

    private function checkIfAllLoaded() : void
    {
        numLoaded++;
        if (numLoaded == 2)
        {
            onAllLoaded();
        }
    }

    private function onAllLoaded() : void
    {
        sequenceLoader.clearAllJobs();

        projectModel.emitterInFocus = null;
        for each (var emitterVO : EmitterValueObject in projectModel.stadustSim.emitters)
        {
            if (projectModel.emitterInFocus == null)
            {
                projectModel.emitterInFocus = emitterVO;
            }
            var em : Emitter = emitterVO.emitter;
            if (!hasInitializerType(em, PositionAnimated))
            {
                em.addInitializer(new PositionAnimated());
            }
            if (!hasInitializerType(em, Life))
            {
                em.addInitializer(new Life());
            }
            if (!hasInitializerType(em, Velocity))
            {
                em.addInitializer(new Velocity());
            }
            if (!hasInitializerType(em, Alpha))
            {
                em.addInitializer(new Alpha());
            }
            if (!hasInitializerType(em, Scale))
            {
                em.addInitializer(new Scale());
            }
            if (!hasInitializerType(em, Rotation))
            {
                em.addInitializer(new Rotation());
            }
            if (!hasInitializerType(em, Omega))
            {
                em.addInitializer(new Omega());
            }
            if (!hasInitializerType(em, Mass))
            {
                em.addInitializer(new Mass());
            }
        }

        simPlayer.setRenderTarget(null); // set to null, so previous settings dont cause exception

        simPlayer.setProject( projectModel.stadustSim);

        simPlayer.setRenderTarget( Globals.starlingCanvas);

        dispatcher.dispatchEvent( new RefreshBackgroundViewEvent() );

        DisplayObject(FlexGlobals.topLevelApplication).stage.frameRate = projectModel.fps;
        dispatcher.dispatchEvent( new RefreshFPSTextEvent() );

        Globals.dispatchExternalTitleChangeEvent(event.nameToDisplay);

        dispatcher.dispatchEvent( new StartSimEvent() );
    }

    private static function hasInitializerType(em : Emitter, clazz : Class) : Boolean
    {
        for each (var initializer : Initializer in em.initializers)
        {
            if (initializer is clazz)
            {
                return true;
            }
        }
        return false;
    }
}
}
