package com.funkypandagame.stardust.controller
{

import com.funkypandagame.stardust.controller.events.EmitterImportedEvent;
import com.funkypandagame.stardust.tasks.AsyncTask;
import com.funkypandagame.stardustplayer.SimLoader;
import com.funkypandagame.stardustplayer.SDEConstants;
import com.funkypandagame.stardustplayer.emitter.EmitterValueObject;
import com.funkypandagame.stardustplayer.project.ProjectValueObject;
import com.funkypandagame.stardustplayer.sequenceLoader.LoadByteArrayJob;
import com.funkypandagame.stardustplayer.sequenceLoader.SequenceLoader;

import flash.display.Bitmap;
import flash.display.BitmapData;

import flash.events.Event;
import flash.geom.Point;
import flash.net.FileFilter;
import flash.net.FileReference;
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

import org.as3commons.zip.Zip;

import spark.components.Alert;

import starling.textures.SubTexture;

import starling.textures.Texture;

import starling.textures.TextureAtlas;

public class ImportEmitterCommand extends AsyncTask
{

    public var sdeFile : ByteArray;

    private var sequenceLoader : SequenceLoader;
    private var loadedZip : Zip;

    private var simLoader : SimLoader;
    private var loadedSim : ProjectValueObject;
    private var emitterImages : Dictionary;

    private var _loadFile : FileReference;

    override public function execute() : void
    {
        _loadFile = new FileReference();
        _loadFile.addEventListener( Event.SELECT, selectHandler );
        _loadFile.addEventListener( Event.CANCEL, cancelHandler );
        _loadFile.browse( [new FileFilter( "Stardust editor project (*.sde)", "*.sde" )] );
    }

    private function cancelHandler( event : Event ) : void
    {
        _loadFile.removeEventListener( Event.SELECT, selectHandler );
        _loadFile.removeEventListener( Event.CANCEL, cancelHandler );
        dispatchCompleteSignal();
    }

    private function selectHandler( event : Event ) : void
    {
        _loadFile.removeEventListener( Event.SELECT, selectHandler );
        _loadFile.removeEventListener( Event.CANCEL, cancelHandler );

        _loadFile.addEventListener( Event.COMPLETE, loadCompleteHandler );
        _loadFile.load();
    }

    private function loadCompleteHandler( event : Event ) : void
    {
        _loadFile.removeEventListener( Event.COMPLETE, loadCompleteHandler );

        sdeFile = _loadFile.data;

        try
        {
            simLoader = new SimLoader();
            simLoader.addEventListener(Event.COMPLETE, onSimLoadComplete);
            simLoader.loadSim( sdeFile );

            loadedZip = new Zip();
            loadedZip.loadBytes( sdeFile );
        }
        catch (err: Error)
        {
            Alert.show("Unable to load simulation. " + err.toString(), "ERROR");
            dispatchCompleteSignal();
        }
    }

    private function onSimLoadComplete( event : Event ) : void
    {
        simLoader.removeEventListener(Event.COMPLETE, onSimLoadComplete);
        loadedSim = simLoader.createProjectInstance();
        emitterImages = new Dictionary();
        // Reads BDs from the raw atlases image.
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

        for each (var emitterValueObject : EmitterValueObject in loadedSim.emitters)
        {
            var emitterId : String = emitterValueObject.id;
            if (emitterImages[emitterId] == null)
            {
                emitterImages[emitterId] = new Vector.<BitmapData>();
            }
            var textures : Vector.<Texture> = tmpAtlas.getTextures(SDEConstants.getSubTexturePrefix(emitterValueObject.id));
            var len : uint = textures.length;
            for ( var k : int = 0; k < len; k++ )
            {
                var tex : SubTexture = textures[k] as SubTexture;
                var singleSprite : BitmapData = new BitmapData( tex.width, tex.height );
                singleSprite.copyPixels( atlasBD, tex.region, new Point( 0, 0 ) );
                emitterImages[emitterId].push(singleSprite);
            }
        }
        tmpAtlas.dispose();

        sequenceLoader.clearAllJobs();

        for each (var emitterVO : EmitterValueObject in loadedSim.emitters)
        {
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
        dispatch(new EmitterImportedEvent(loadedSim, emitterImages));
        dispatchCompleteSignal();
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
