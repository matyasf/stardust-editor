package com.funkypandagame.stardust.view.components.gradientChooser
{
public class ColorUtils
{

    public static function displayInHex(c:uint):String {
        var r:String = extractRed(c).toString(16).toUpperCase();
        var g:String = extractGreen(c).toString(16).toUpperCase();
        var b:String = extractBlue(c).toString(16).toUpperCase();
        var zero:String = "0";
        if(r.length == 1)
        {
            r = zero.concat(r);
        }
        if(g.length == 1)
        {
            g = zero.concat(g);
        }
        if(b.length == 1)
        {
            b=zero.concat(b);
        }
        var hs:String = r + g + b;
        return hs;
    }

    public static function extractRed(c:uint):uint {
        return (( c >> 16 ) & 0xFF);
    }

    public static function extractGreen(c:uint):uint {
        return ( (c >> 8) & 0xFF );
    }

    public static function extractBlue(c:uint):uint {
        return ( c & 0xFF );
    }

    public static function toRad(a:Number):Number {
        return a*Math.PI/180;
    }
}
}
