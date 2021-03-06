package com.funkypandagame.stardust.controller
{
import com.funkypandagame.stardust.model.ProjectModel;
import com.funkypandagame.stardust.textures.Atlas;
import com.funkypandagame.stardust.textures.AtlasTexture;
import com.funkypandagame.stardust.textures.TexturePacker;
import com.funkypandagame.stardustplayer.SDEConstants;
import com.funkypandagame.stardustplayer.emitter.EmitterValueObject;

import flash.display.BitmapData;

import idv.cjcat.stardustextended.handlers.starling.StarlingHandler;

import spark.components.Alert;

import starling.textures.SubTexture;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

public class RegenerateEmitterTexturesCommand
{
    [Inject]
    public var projectModel : ProjectModel;

    public function execute() : void
    {
        var packer : TexturePacker = new TexturePacker();
        var tmpTextures : Vector.<AtlasTexture> = new Vector.<AtlasTexture>();
        for (var emitterId : * in projectModel.emitterImages)
        {
            var images : Vector.<BitmapData> = projectModel.emitterImages[emitterId];
            for (var i : int = 0; i < images.length; i++)
            {
                tmpTextures.push(new AtlasTexture(images[i], emitterId, i));
            }
        }
        var atlas : Atlas = packer.createAtlas(tmpTextures);
        if (!atlas)
        {
            Alert.show("Failed to add images. Could not fit all images into a 2048x2048 texture atlas.");
        }
        var atlasTex : Texture = Texture.fromBitmapData(atlas.toBitmap(), false);
        var tmpAtlas : TextureAtlas = new TextureAtlas(atlasTex, atlas.getXML());
        // set the new texture on all handlers
        for each (var emitterVO : EmitterValueObject in projectModel.stadustSim.emitters)
        {
            var texs : Vector.<Texture> = tmpAtlas.getTextures(SDEConstants.getSubTexturePrefix(emitterVO.id));
            var texs2 : Vector.<SubTexture> = new Vector.<SubTexture>();
            for (var k : int = 0; k < texs.length; k++)
            {
                texs2.push(texs[k]);
            }
            StarlingHandler(emitterVO.emitter.particleHandler).setTextures(texs2);
        }
    }
}
}
