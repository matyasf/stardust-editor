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
import flash.geom.Rectangle;
import flash.utils.ByteArray;
import flash.utils.Dictionary;

import idv.cjcat.stardustextended.flashdisplay.handlers.DisplayObjectSpriteSheetHandler;
import idv.cjcat.stardustextended.flashdisplay.handlers.SpriteSheetBitmapSlicedCache;
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
            Alert.show("Unable to load simulation. " + err.toString() + err.getStackTrace(), "ERROR");
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
        var hasAtlas : Boolean = false;
        for (var i : int = 0; i < loadedZip.getFileCount(); i++)
        {
            var loadedFileName : String = loadedZip.getFileAt(i).filename;
            if (SDEConstants.isAtlasImageName(loadedFileName))
            {
                hasAtlas = true;
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
        if (!hasAtlas)
        {
            Alert.show("The simulation was created with an old version of the editor. " +
                       "It has been upgraded to the latest format(which batches textures). " +
                       "Save the simulation to apply this latest change, old simulations will not be supported for long");
            sequenceLoader = new SequenceLoader();
            for (var j:int = 0; j < loadedZip.getFileCount(); j++)
            {
                var loadedFileName2 : String = loadedZip.getFileAt(j).filename;
                if (SDEConstants.isEmitterXMLName(loadedFileName2))
                {
                    var emitterId : uint = SDEConstants.getEmitterID(loadedFileName2);
                    const loadImageJob : LoadByteArrayJob = new LoadByteArrayJob(
                            emitterId.toString(),
                            SDEConstants.getImageName(emitterId),
                            loadedZip.getFileByName(SDEConstants.getImageName(emitterId)).content );
                    sequenceLoader.addJob( loadImageJob );
                }
            }
            sequenceLoader.addEventListener( Event.COMPLETE, onProjectImagesLoaded );
            sequenceLoader.loadSequence();
        }
    }

    private function onProjectImagesLoaded( event : Event ) : void
    {
        sequenceLoader.removeEventListener( Event.COMPLETE, onProjectImagesLoaded );
        for (var i:int = 0; i < loadedZip.getFileCount(); i++)
        {
            var loadedFileName : String = loadedZip.getFileAt(i).filename;
            if (SDEConstants.isEmitterXMLName(loadedFileName))
            {
                const emitterId : uint = SDEConstants.getEmitterID(loadedFileName);
                const job : LoadByteArrayJob = sequenceLoader.getJobByName( emitterId.toString() );

                var image : BitmapData = Bitmap(job.content).bitmapData;
                // slice image up
                for each (var emVO : EmitterValueObject in projectModel.stadustSim.emitters)
                {
                    if (emVO.id == emitterId)
                    {
                        var handler : ISpriteSheetHandler = ISpriteSheetHandler(emVO.emitter.particleHandler);
                        var isSpriteSheet : Boolean = (handler.spriteSheetSliceWidth > 0 && handler.spriteSheetSliceHeight > 0) &&
                                     (image.width >= handler.spriteSheetSliceWidth * 2 || image.height >= handler.spriteSheetSliceHeight * 2);
                        if (projectModel.emitterImages[emitterId] == null)
                        {
                            projectModel.emitterImages[emitterId] = new Vector.<BitmapData>();
                        }
                        if (isSpriteSheet)
                        {
                            var splicer : SpriteSheetBitmapSlicedCache = new SpriteSheetBitmapSlicedCache(image, handler.spriteSheetSliceWidth, handler.spriteSheetSliceHeight);
                            projectModel.emitterImages[emitterId] = splicer.bds;
                        }
                        else
                        {
                            projectModel.emitterImages[emitterId] = new <BitmapData>[image];
                        }
                    }
                }
            }
        }
        checkIfAllLoaded();
    }

    private function onProjectAtlasLoaded( event : Event ) : void
    {
        sequenceLoader.removeEventListener( Event.COMPLETE, onProjectAtlasLoaded );
        var job : LoadByteArrayJob = sequenceLoader.getCompletedJobs().pop();
        var atlasXMLName : String = job.fileName.substr(0, job.fileName.length - 3) + "xml";
        var atlasXMLBA : ByteArray = loadedZip.getFileByName(atlasXMLName).content;
        var atlasXml : XML = new XML(atlasXMLBA.readUTFBytes(atlasXMLBA.length));
        var atlasBD : BitmapData = Bitmap(job.content).bitmapData;
        // store images in the atlas in a model
        var scale : Number = 1;
        for each (var subTexture : XML in atlasXml.SubTexture)
        {
            var name:String        = subTexture.@name.toString();
            var x:Number           = parseFloat(subTexture.@x) / scale;
            var y:Number           = parseFloat(subTexture.@y) / scale;
            var width:Number       = parseFloat(subTexture.@width)  / scale;
            var height:Number      = parseFloat(subTexture.@height) / scale;
            var singleSprite : BitmapData = new BitmapData( width, height );
            singleSprite.copyPixels( atlasBD, new Rectangle( x, y, width, height ), new Point( 0, 0 ) );
            var emitterId : uint = name.split("_")[1];
            if (projectModel.emitterImages[emitterId] == null)
            {
                projectModel.emitterImages[emitterId] = new Vector.<BitmapData>();
            }
            projectModel.emitterImages[emitterId].push(singleSprite);
        }
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
        simLoader.dispose();

        for each (var emitterVO : EmitterValueObject in projectModel.stadustSim.emitters)
        {
            projectModel.emitterInFocus = emitterVO;
            break;
        }

        simPlayer.setProject( projectModel.stadustSim);

        const handler : ISpriteSheetHandler = ISpriteSheetHandler(projectModel.emitterInFocus.emitter.particleHandler);
        if (handler is DisplayObjectSpriteSheetHandler)
        {
            simPlayer.setRenderTarget( Globals.canvas);
        }
        else if (projectModel.emitterInFocus.emitter.particleHandler is StarlingHandler)
        {
            simPlayer.setRenderTarget( Globals.starlingCanvas);
        }

        dispatcher.dispatchEvent( new RefreshBackgroundViewEvent() );

        DisplayObject(FlexGlobals.topLevelApplication).stage.frameRate = projectModel.fps;
        dispatcher.dispatchEvent( new RefreshFPSTextEvent() );

        dispatcher.dispatchEvent( new StartSimEvent() );
    }


}
}
