package com.funkypandagame.stardust.textures
{

import com.funkypandagame.stardustplayer.SDEConstants;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.display.StageQuality;
import flash.geom.Matrix;

public class Atlas
{
    private var _image : BitmapData;
    private var _atlasTextures : Vector.<AtlasTexture>;
    private var _size : uint;

    public function Atlas(size : uint)
    {
        _size = size;
        _atlasTextures = new Vector.<AtlasTexture>();
    }

    public function addWithPadding(src : AtlasTexture, x : uint, y : uint) : void
    {
       src.setPositionWithPadding(x, y);
        _atlasTextures.push(src);
    }

    public function toBitmap() : BitmapData
    {
        if (_image == null)
        {
            var constructed : Sprite = new Sprite();
            for each (var atlasTexture : AtlasTexture in _atlasTextures)
            {
                const bm : Bitmap = new Bitmap(atlasTexture.image, "auto", true);
                constructed.addChild(bm);
                bm.x = atlasTexture.positionNoPadding.x - TexturePacker.PADDING;
                bm.y = atlasTexture.positionNoPadding.y - TexturePacker.PADDING;
            }

            _image = new BitmapData(_size, _size, true, 0x00ffffff);
            var m : Matrix = new Matrix();
            _image.drawWithQuality(constructed, m, null, null, null, true, StageQuality.BEST);
        }
        return _image;
    }

    public function getXML() : XML
    {
        var xml : XML = <TextureAtlas imagePath={SDEConstants.ATLAS_IMAGE_NAME}></TextureAtlas>;
        var len : uint = _atlasTextures.length;
        for (var i : int = 0; i < len; i++)
        {
            var atlasTexture : AtlasTexture = _atlasTextures[i];
            var name : String = SDEConstants.getSubTextureName(atlasTexture.emitterId, atlasTexture.imagePosition, len);
            var nodeXML : XML = <SubTexture name={name}
                                            x={atlasTexture.positionNoPadding.x} y={atlasTexture.positionNoPadding.y}
                                            width={atlasTexture.positionNoPadding.width} height={atlasTexture.positionNoPadding.height}/>;
            xml.appendChild(nodeXML);
        }
        return xml;
    }
}
}