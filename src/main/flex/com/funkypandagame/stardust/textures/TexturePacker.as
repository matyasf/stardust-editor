package com.funkypandagame.stardust.textures
{
import com.funkypandagame.stardust.helpers.Utils;

import flash.geom.Rectangle;

public class TexturePacker
{
    public static const borderSize : int = 1; // empty space
    public static const padding : int = 1;// extend the image by this many pixels
    protected var _maxAtlasSize : int = 2048;

    protected var _atlas : Atlas;
    protected var _unpacked : Vector.<AtlasTexture>;

    public function createAtlas(unpacked : Vector.<AtlasTexture>) : Atlas
    {
        _unpacked = unpacked;
        _unpacked = _unpacked.sort(compareBitmapDatas);
        validateTextureSize(_unpacked, _maxAtlasSize);

        var minAtlasSize : uint = calculateMinimumSize(0);
        packIntoAtlas(minAtlasSize, 0);

        return _atlas;
    }

    private function packIntoAtlas(atlasSize : uint, currentPos : uint) : void
    {
        _atlas = new Atlas(0);
        // try to pack it into the given (minimum possible) size
        var packer : MaxRectPacker = new MaxRectPacker(atlasSize, atlasSize);
        for (var i : int = currentPos; i < _unpacked.length; i++)
        {
            var rect : Rectangle = packer.quickInsert(_unpacked[i].positionWithPadding.width, _unpacked[i].positionWithPadding.height);
            if (rect == null)
            {
                if (Utils.nextPowerOfTwo(atlasSize + 1) <= _maxAtlasSize)
                {
                    // everything does not fit, try with a 2x big one.
                    trace("Element with size " + _unpacked[i].positionWithPadding.width + "x" +
                          _unpacked[i].positionWithPadding.height +
                          " does not fit, trying with a " + Utils.nextPowerOfTwo(atlasSize + 1) + " texture");
                    packIntoAtlas(Utils.nextPowerOfTwo(atlasSize + 1), currentPos);
                    return;
                }
                else
                {
                    // The texture size cannot grow.
                    // TODO make new atlas based if the first one gets full. It should group textures based on emitters
                    trace("Texture size " + atlasSize + " cannot grow because max size is " +_maxAtlasSize + ". Aborting");
                    _atlas = null;
                    return;
                }
            }
            else
            {
                // it fits, put into the atlas
                _atlas.addWithPadding(_unpacked[i], rect.x, rect.y);
            }
        }
    }

    // Calculates the minimum possible size to speed up calculation.
    private function calculateMinimumSize(offset : uint) : uint
    {
        var minSize : uint = 2;
        var area : uint = 0;
        for (var i : int = offset; i < _unpacked.length; i++)
        {
            minSize = Math.max(minSize, _unpacked[i].positionWithPadding.width, _unpacked[i].positionWithPadding.height);
            area += _unpacked[i].areaWithPadding;
        }
        var minPossibleSize : uint = Utils.nextPowerOfTwo(Math.max(minSize, Math.sqrt(area)));
        return Math.min(_maxAtlasSize, minPossibleSize);
    }

    private static function validateTextureSize(_unpacked : Vector.<AtlasTexture>, maxAtlasSize : uint) : void
    {
        for each (var unpacked : AtlasTexture in _unpacked)
        {
            if (unpacked.positionWithPadding.height > maxAtlasSize || unpacked.positionWithPadding.height > maxAtlasSize)
            {
                throw new Error("Too large to fit in an atlas: '" + unpacked + "' (" + unpacked.positionWithPadding + ")");
            }
        }
    }

    private static function compareBitmapDatas(bd1 : AtlasTexture, bd2 : AtlasTexture) : Number
    {
        if (bd1.areaWithPadding > bd2.areaWithPadding)
        {
            return -1;
        }
        return 1;

    }

}
}
