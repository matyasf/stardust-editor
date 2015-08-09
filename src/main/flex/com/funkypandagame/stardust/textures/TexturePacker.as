package com.funkypandagame.stardust.textures
{

import flash.geom.Rectangle;

// TODO make new atlas based if the first one gets full. It should group textures based on emitters
public class TexturePacker
{
    public static const BORDER_SIZE : int = 1; // empty space
    public static const PADDING : int = 1;// extend the image by this many pixels
    private static const MAX_ATLAS_SIZE : int = 2048; // TODO make this a parameter
    private static const ATLAS_GROW_FACTOR : Number = 1.1; // around 21%

    protected var _atlas : Atlas;
    protected var _unpacked : Vector.<AtlasTexture>;

    public function createAtlas(unpacked : Vector.<AtlasTexture>) : Atlas
    {
        _unpacked = unpacked;
        _unpacked = _unpacked.sort(compareBitmapDatas);

        var minAtlasSize : uint = calculateMinimumSize();
        if (minAtlasSize > MAX_ATLAS_SIZE)
        {
            trace("ERROR minimum possible size is " + minAtlasSize + "x" + minAtlasSize +
                  " which is greater than the allowed maximum");
            return null;
        }
        trace("Minimum possible atlas size: " +minAtlasSize + "x" + minAtlasSize);
        packIntoAtlas(minAtlasSize);

        return _atlas;
    }

    private function packIntoAtlas(minAtlasSize : uint) : void
    {
        _atlas = new Atlas(minAtlasSize);
        // try to pack it into the given (minimum possible) size
        var packer : MaxRectPacker = new MaxRectPacker(minAtlasSize, minAtlasSize);
        for (var i : int = 0; i < _unpacked.length; i++)
        {
            var rect : Rectangle = packer.quickInsert(_unpacked[i].positionWithPadding.width, _unpacked[i].positionWithPadding.height);
            if (rect == null)
            {
                if (minAtlasSize == MAX_ATLAS_SIZE)
                {
                    trace("ERROR Unable to save texture atlas because it does not fit into " + MAX_ATLAS_SIZE + "x" + MAX_ATLAS_SIZE);
                    _atlas = null;
                    return;
                }
                var nextSize : uint = Math.ceil(minAtlasSize * ATLAS_GROW_FACTOR);
                if (nextSize > MAX_ATLAS_SIZE)
                {
                    minAtlasSize = MAX_ATLAS_SIZE;
                }
                // everything does not fit, try with a bigger one.
                trace("Elements do not fit, trying with a " + nextSize + "x" + nextSize + " texture");
                packIntoAtlas(nextSize);
                return;
            }
            else
            {
                // it fits, put into the atlas
                _atlas.addWithPadding(_unpacked[i], rect.x, rect.y);
            }
        }
    }

    // Calculates the minimum possible size to speed up calculation.
    private function calculateMinimumSize() : uint
    {
        var minSize : uint = 2;
        var area : uint = 0;
        for (var i : int = 0; i < _unpacked.length; i++)
        {
            minSize = Math.max(minSize, _unpacked[i].positionWithPadding.width, _unpacked[i].positionWithPadding.height);
            area += _unpacked[i].areaWithPadding;
        }
        var minPossibleSize : uint = Math.max(minSize, Math.sqrt(area));
        return minPossibleSize;
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
