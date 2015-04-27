package com.funkypandagame.stardust.controller
{
import com.funkypandagame.stardust.model.ProjectModel;
import com.funkypandagame.stardust.textures.Atlas;
import com.funkypandagame.stardust.textures.AtlasTexture;
import com.funkypandagame.stardust.textures.TexturePacker;
import com.funkypandagame.stardustplayer.SDEConstants;
import com.funkypandagame.stardustplayer.emitter.EmitterValueObject;

import flash.display.BitmapData;

import idv.cjcat.stardustextended.twoD.starling.StarlingHandler;

import spark.components.Alert;

import starling.textures.SubTexture;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

public class RegenerateEmitterTexturesCommand
{
    [Inject]
    public var model : ProjectModel;

    public function execute() : void
    {
        var oldTexture : Texture = StarlingHandler(model.emitterInFocus.emitter.particleHandler).textures[0].root;
        var packer : TexturePacker = new TexturePacker();
        var tmpTextures : Vector.<AtlasTexture> = new Vector.<AtlasTexture>();
        for (var emitterId : * in model.emitterImages)
        {
            var images : Vector.<BitmapData> = model.emitterImages[emitterId];
            for (var i : int = 0; i < images.length; i++)
            {
                tmpTextures.push(new AtlasTexture(images[i], uint(emitterId), i));
            }
        }
        var atlas : Atlas = packer.createAtlas(tmpTextures);
        if (!atlas)
        {
            Alert.show("Failed to add images. Could not fit all images into a 2048x2048 texture atlas.");
        }
        var atlasTex : Texture = Texture.fromBitmapData(atlas.toBitmap());
        var tmpAtlas : TextureAtlas = new TextureAtlas(atlasTex, atlas.getXML());
        // set the new texture on all handlers
        for each (var emitterVO : EmitterValueObject in model.stadustSim.emitters)
        {
            var texs : Vector.<Texture> = tmpAtlas.getTextures(SDEConstants.getSubTexturePrefix(emitterVO.id));
            var texs2 : Vector.<SubTexture> = new Vector.<SubTexture>();
            for (var k : int = 0; k < texs.length; k++)
            {
                texs2.push(texs[k]);
            }
            StarlingHandler(emitterVO.emitter.particleHandler).setTextures(texs2);
        }
        oldTexture.dispose();
    }
}
}
