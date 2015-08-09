package com.funkypandagame.stardust.textures
{

import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

public class AtlasTexture
{
    private var _image : BitmapData;
    private var _emitterId : String;
    // the position with added padding
    private var _positionWithPadding : Rectangle;
    // the image position without any padding
    private var _positionNoPadding : Rectangle;
    // position in an animation
    private var _imagePosition : uint;

    public function AtlasTexture(bData : BitmapData, emitterId : String, imagePosition : uint)
    {
        _image = bData;
        _emitterId = emitterId;
        _imagePosition = imagePosition;
        var offsets : uint =  TexturePacker.PADDING * 2 + TexturePacker.BORDER_SIZE * 2;
        _positionWithPadding = new Rectangle(0, 0, _image.width + offsets, _image.height + offsets);
        _positionNoPadding = new Rectangle(0, 0, _image.width, _image.height);
    }

    public function get image() : BitmapData
    {
        return padBitmapBorder(_image);
    }

    public function get emitterId() : String
    {
        return _emitterId;
    }

    public function get positionWithPadding() : Rectangle
    {
        return _positionWithPadding;
    }

    public function get positionNoPadding() : Rectangle
    {
        return _positionNoPadding;
    }

    public function setPositionWithPadding(xc : uint, yc : uint) : void
    {
        _positionWithPadding.x = xc;
        _positionWithPadding.y = yc;

        _positionNoPadding.x = xc + TexturePacker.PADDING + TexturePacker.BORDER_SIZE;
        _positionNoPadding.y = yc + TexturePacker.PADDING + TexturePacker.BORDER_SIZE;
    }

    public function get imagePosition() : uint
    {
        return _imagePosition;
    }

    public function get areaWithPadding() : uint
    {
        return _positionWithPadding.width * _positionWithPadding.height;
    }

    /**
     * Extends src's border pixels by the given amount.
     * (We do this to textures in an atlas in order to prevent artifacts that come from
     * the GPU sampling just beyond a texture's bounds.)
     */
    private static function padBitmapBorder(src : BitmapData) : BitmapData
    {
        var paddingSize : uint = TexturePacker.PADDING;
        var srcBounds : Rectangle = new Rectangle(0, 0, src.width, src.height);
        var w : int = Math.ceil(srcBounds.width);
        var h : int = Math.ceil(srcBounds.height);

        var bmd : BitmapData = new BitmapData(w + (paddingSize * 2), h + (paddingSize * 2), true, 0x00);

        // draw the original bitmap
        var m : Matrix = new Matrix();
        m.translate(-srcBounds.x + paddingSize, -srcBounds.y + paddingSize);
        bmd.draw(src, m, null, null, null, /*smoothing=*/false);

        var srcRect : Rectangle = new Rectangle();
        var dst : Point = new Point();
        var yy : int;
        var xx : int;

        // copy top row
        srcRect.x = paddingSize;
        srcRect.y = paddingSize;
        srcRect.width = w;
        srcRect.height = 1;
        dst.x = paddingSize;
        for (yy = 0; yy < paddingSize; ++yy)
        {
            dst.y = yy;
            bmd.copyPixels(bmd, srcRect, dst);
        }

        // copy bottom row
        srcRect.x = paddingSize;
        srcRect.y = h + paddingSize - 1;
        srcRect.width = w;
        srcRect.height = 1;
        dst.x = paddingSize;
        for (yy = 0; yy < paddingSize; ++yy)
        {
            dst.y = h + paddingSize + yy;
            bmd.copyPixels(bmd, srcRect, dst);
        }

        // copy left column
        srcRect.x = paddingSize;
        srcRect.y = paddingSize;
        srcRect.width = 1;
        srcRect.height = h;
        dst.y = paddingSize;
        for (xx = 0; xx < paddingSize; ++xx)
        {
            dst.x = xx;
            bmd.copyPixels(bmd, srcRect, dst);
        }

        // copy right column
        srcRect.x = w + paddingSize - 1;
        srcRect.y = paddingSize;
        srcRect.width = 1;
        srcRect.height = h;
        dst.y = paddingSize;
        for (xx = 0; xx < paddingSize; ++xx)
        {
            dst.x = w + paddingSize + xx;
            bmd.copyPixels(bmd, srcRect, dst);
        }
        return bmd;
    }

}
}
