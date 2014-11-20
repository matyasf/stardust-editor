package com.plumbee.stardust.helpers {
import idv.cjcat.stardustextended.twoD.handlers.ISpriteSheetHandler;
import idv.cjcat.stardustextended.twoD.starling.StarlingHandler;

import starling.display.BlendMode;

public class ParticleHandlerCopyHelper {

    public static function copyHandlerProperties(from : ISpriteSheetHandler, toHandler : ISpriteSheetHandler) : void
    {
        toHandler.bitmapData = from.bitmapData;
        if (toHandler is StarlingHandler)
        {
            toHandler.blendMode = getStarlingSafeBlendMode(from.blendMode);
        }
        else
        {
            toHandler.blendMode = from.blendMode;
        }
        toHandler.smoothing = from.smoothing;
        toHandler.spriteSheetAnimationSpeed = from.spriteSheetAnimationSpeed;
        toHandler.spriteSheetSliceHeight = from.spriteSheetSliceHeight;
        toHandler.spriteSheetSliceWidth = from.spriteSheetSliceWidth;
        toHandler.spriteSheetStartAtRandomFrame = from.spriteSheetStartAtRandomFrame;
    }

    private static function getStarlingSafeBlendMode(oldBlendMode : String) : String
    {
        var starlingBlendModes : Array = Globals.blendModesStarling.source;
        for ( var i : int = 0; i < starlingBlendModes.length; i++)
        {
            if ( starlingBlendModes[i] == oldBlendMode )
            {
                return oldBlendMode
            }
        }
        return BlendMode.NORMAL;
    }

}
}
