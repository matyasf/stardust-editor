package com.funkypandagame.stardust.textures
{
import com.funkypandagame.stardust.helpers.Utils;
import com.funkypandagame.stardustplayer.SimLoader;
import com.funkypandagame.stardustplayer.ZipFileNames;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.display.StageQuality;
import flash.geom.Matrix;
import flash.geom.Rectangle;

public class Atlas
{
    private var _name : uint;
    private var _image : BitmapData;
    private var _atlasTextures : Vector.<AtlasTexture>;

    public function Atlas(name : uint)
    {
        _atlasTextures = new Vector.<AtlasTexture>();
        _name = name;
    }

    public function get name() : uint
    {
        return _name;
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
            // TODO merge this into the packer?
            var constructed : Sprite = new Sprite();
            var collapsedBounds : Rectangle = new Rectangle();
            _atlasTextures.forEach(function (atlasTexture : AtlasTexture, ...rest) : void
            {
                const bm : Bitmap = new Bitmap(atlasTexture.image, "auto", true);
                constructed.addChild(bm);
                bm.x = atlasTexture.positionNoPadding.x - TexturePacker.padding;
                bm.y = atlasTexture.positionNoPadding.y - TexturePacker.padding;
                collapsedBounds = collapsedBounds.union(atlasTexture.positionWithPadding);
            });

            _image = new BitmapData(
                    Utils.nextPowerOfTwo(collapsedBounds.x + collapsedBounds.width),
                    Utils.nextPowerOfTwo(collapsedBounds.y + collapsedBounds.height), true, 0x00ffffff);
            var m : Matrix = new Matrix();
            _image.drawWithQuality(constructed, m, null, null, null, true, StageQuality.BEST);
        }
        return _image;
    }

    public function getXML() : String
    {
        var xml : XML = <TextureAtlas imagePath={ZipFileNames.getAtlasName(_name)}></TextureAtlas>;
        for (var i : int = 0; i < _atlasTextures.length; i++)
        {
            var atlasTexture : AtlasTexture = _atlasTextures[i];
            var nodeXML : XML = <SubTexture name={SimLoader.SUBTEXTURE_PREFIX + atlasTexture.emitterId + "_image_" + i}
                                            x={atlasTexture.positionNoPadding.x} y={atlasTexture.positionNoPadding.y}
                                            width={atlasTexture.positionNoPadding.width} height={atlasTexture.positionNoPadding.height}/>;
            xml.appendChild(nodeXML);
        }
        return '<?xml version="1.0" encoding="UTF-8"?>\n' + xml.toString();
    }
}
}