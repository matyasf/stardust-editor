package com.funkypandagame.stardust.view.components.gradientChooser {

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.GradientType;
import flash.display.Shape;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Matrix;

import mx.core.FlexGlobals;

public class ColorPicker extends Sprite
{

    private var bd : BitmapData;
    private var nWidth : Number;
    private var nHeight : Number;
    private var posIndicator : Sprite;
    public var onColorChanged : Function;
    private var _color : uint;

    public function ColorPicker(_width : uint, _height : uint)
    {
        nWidth = _width;
        nHeight = _height;
        var grayHeight : uint = 30;
        var rainbowHeight : uint = _height - grayHeight;

        var container:Sprite=new Sprite();
        var rainbow:Shape=new Shape();
        container.addChild(rainbow);
        var shadeBlack:Shape=new Shape();
        container.addChild(shadeBlack);
        shadeBlack.y=rainbowHeight/2;
        var shadeWhite:Shape=new Shape();
        container.addChild(shadeWhite);
        var grayscale:Shape=new Shape();
        container.addChild(grayscale);
        grayscale.y=rainbowHeight;

        var mat:Matrix = new Matrix();
        var colors:Array = [0xFF0000,0xFFFF00,0x00FF00,0x00FFFF,0x0000FF,0xFF00FF];
        var alphas:Array = [1,1,1,1,1,1];
        var ratios:Array = [5,51,102,153,204,250];
        mat.createGradientBox(nWidth,rainbowHeight);
        rainbow.graphics.lineStyle();
        rainbow.graphics.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,mat);
        rainbow.graphics.drawRect(0,0,nWidth,rainbowHeight);
        rainbow.graphics.endFill();

        mat = new Matrix();
        colors = [0x000000,0x000000];
        alphas = [1,0];
        ratios = [0,255];
        mat.createGradientBox(nWidth,rainbowHeight/2, ColorUtils.toRad(-90));
        shadeBlack.graphics.lineStyle();
        shadeBlack.graphics.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,mat);
        shadeBlack.graphics.drawRect(0,0,nWidth,rainbowHeight/2);
        shadeBlack.graphics.endFill();

        mat=new Matrix();
        colors=[0xFFFFFF,0xFFFFFF];
        alphas=[1,0];
        ratios=[0,255];
        mat.createGradientBox(nWidth,rainbowHeight/2, ColorUtils.toRad(90));
        shadeWhite.graphics.lineStyle();
        shadeWhite.graphics.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,mat);
        shadeWhite.graphics.drawRect(0,0,nWidth,rainbowHeight/2);
        shadeWhite.graphics.endFill();

        mat=new Matrix();
        colors=[0x000000,0xFFFFFF];
        alphas=[1,1];
        ratios=[5,250];
        mat.createGradientBox(nWidth, grayHeight);
        grayscale.graphics.lineStyle();
        grayscale.graphics.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,mat);
        grayscale.graphics.drawRect(0,0,nWidth,grayHeight);
        grayscale.graphics.endFill();

        bd = new BitmapData(nWidth, nHeight);
        bd.draw(container);

        addChild(new Bitmap(bd));

        posIndicator = new Sprite();
        posIndicator.graphics.lineStyle(2, 0x0);
        posIndicator.graphics.drawCircle(0, 0, 6);
        posIndicator.graphics.lineStyle(2, 0xffffff);
        posIndicator.graphics.drawCircle(0, 0, 8);
        addChild(posIndicator);

        addEventListener(MouseEvent.MOUSE_DOWN, addListener);
    }

    private function addListener(event : Event) : void
    {
        var st : Stage = FlexGlobals.topLevelApplication.stage;
        st.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
        st.addEventListener(MouseEvent.MOUSE_UP, finishSetColor);
        st.addEventListener(MouseEvent.ROLL_OUT, finishSetColor);
    }

    private function onMouseMove(evt : Event) : void
    {
       setColorViaMouse();
    }

    private function finishSetColor(evt : Event) : void
    {
        setColorViaMouse();

        var st : Stage = FlexGlobals.topLevelApplication.stage;
        st.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
        st.removeEventListener(MouseEvent.MOUSE_UP, finishSetColor);
        st.removeEventListener(MouseEvent.ROLL_OUT, finishSetColor);
    }

    private function setColorViaMouse() : void
    {
        var mx : Number = mouseX;
        if (mx >= nWidth) mx = nWidth - 1;
        else if (mx < 0) mx = 0;

        var my : Number = mouseY;
        if (my >= nHeight) my = nHeight - 1;
        else if (my < 0) my = 0;

        posIndicator.x = mx;
        posIndicator.y = my;
        _color = bd.getPixel(posIndicator.x, posIndicator.y);
        if (onColorChanged != null)
        {
            onColorChanged();
        }
    }

    public function set color(val : uint) : void
    {
        _color = val;
        var colorR : uint = ColorUtils.extractRed(val);
        var colorG : uint = ColorUtils.extractGreen(val);
        var colorB : uint = ColorUtils.extractBlue(val);
        var colorR2 : uint;
        var colorG2 : uint;
        var colorB2 : uint;
        var bestFit : uint = 999999999;
        var bestFitXc : uint;
        var bestFitYc : uint;
        var current : uint;
        var currentFit : uint;
        for (var i : int = 0; i < nWidth; i++)
        {
            for (var j : int = 0; j < nHeight; j++)
            {
                current = bd.getPixel(i, j);
                colorR2 = ColorUtils.extractRed(current);
                colorG2 = ColorUtils.extractGreen(current);
                colorB2 = ColorUtils.extractBlue(current);
                currentFit = Math.abs(colorR - colorR2) +
                             Math.abs(colorG - colorG2) +
                             Math.abs(colorB - colorB2);
                if (currentFit < bestFit)
                {
                    bestFit = currentFit;
                    bestFitXc = i;
                    bestFitYc = j;
                }
            }
            if (bestFit < 3)
            {
                break;
            }
        }
        posIndicator.x = bestFitXc;
        posIndicator.y = bestFitYc;
    }

    public function get color() : uint
    {
        return _color;
    }
}
}
