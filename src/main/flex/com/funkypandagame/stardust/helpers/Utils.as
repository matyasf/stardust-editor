package com.funkypandagame.stardust.helpers
{

public class Utils
{
    public static function toNiceString(num:Number, precision:int = 2):String
    {
        var decimalPlaces:Number = Math.pow(10, precision);
        return (Math.round(decimalPlaces * num) / decimalPlaces).toString();
    }
}
}
