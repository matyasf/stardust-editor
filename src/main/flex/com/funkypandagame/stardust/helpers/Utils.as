package com.funkypandagame.stardust.helpers
{

public class Utils
{
    public static function toNiceString(num:Number, precision:int = 2):String
    {
        var decimalPlaces:Number = Math.pow(10, precision);
        return (Math.round(decimalPlaces * num) / decimalPlaces).toString();
    }

    /** Returns the smallest number >= n that is a power of two. */
    public static function nextPowerOfTwo (n :int) :int {
        var p :int = 1;
        while (p < n) p *= 2;
        return p;
    }
}
}
