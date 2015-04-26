package com.funkypandagame.stardust.controller
{
import com.funkypandagame.stardust.model.ProjectModel;
import com.funkypandagame.stardust.textures.Atlas;
import com.funkypandagame.stardust.textures.AtlasTexture;
import com.funkypandagame.stardust.textures.TexturePacker;
import com.funkypandagame.stardustplayer.SimLoader;
import com.funkypandagame.stardustplayer.SDEConstants;
import com.funkypandagame.stardustplayer.emitter.EmitterValueObject;

import flash.display.BitmapData;

import idv.cjcat.stardustextended.twoD.starling.StarlingHandler;

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
        var textures : Vector.<AtlasTexture> = new Vector.<AtlasTexture>();
        for (var emitterId : * in model.emitterImages)
        {
            var images : Vector.<BitmapData> = model.emitterImages[emitterId];
            for each (var data : BitmapData in images)
            {
                textures.push(new AtlasTexture(data, uint(emitterId)));
            }
        }
        var atlas : Atlas = packer.createAtlas(textures);
        var atlasTex : Texture = Texture.fromBitmapData(atlas.toBitmap());
        var tAtlas : TextureAtlas = new TextureAtlas(atlasTex, atlas.getXML());
        // set the new texture on all handlers
        for each (var emitterVO : EmitterValueObject in model.stadustSim.emitters)
        {
            var texs : Vector.<Texture> = tAtlas.getTextures(SDEConstants.getSubTexturePrefix(emitterVO.id));
            var texs2 : Vector.<SubTexture> = new Vector.<SubTexture>();
            for each (var subTexture : SubTexture in texs)
            {
                texs2.push(subTexture);
            }
            StarlingHandler(emitterVO.emitter.particleHandler).setTextures(texs2);
        }
        oldTexture.dispose();
    }
}
}
