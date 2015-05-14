package com.funkypandagame.stardust.helpers
{
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;

public class SpriteSheetBitmapSlicedCache
{
    public const bds : Vector.<BitmapData> = new Vector.<BitmapData>();
    /** chops up the sprite sheet to small images */
    public function SpriteSheetBitmapSlicedCache( bd : BitmapData, imgWidth : int, imgHeight : int ) : void
    {
        const xIter : int = Math.floor( bd.width / imgWidth );
        const yIter : int = Math.floor( bd.height / imgHeight );
        for ( var j : int = 0; j < yIter; j ++ )
        {
            for ( var i : int = 0; i < xIter; i ++ )
            {
                const singleSprite : BitmapData = new BitmapData( imgWidth, imgHeight );
                singleSprite.copyPixels( bd,
                                         new Rectangle( i * imgWidth, j * imgHeight, imgWidth, imgHeight ),
                                         new Point( 0, 0 ) );
                bds.push( singleSprite );
            }
        }
    }
}
}
