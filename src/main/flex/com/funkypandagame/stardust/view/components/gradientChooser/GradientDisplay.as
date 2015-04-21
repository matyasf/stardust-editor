package com.funkypandagame.stardust.view.components.gradientChooser
{

import flash.display.GradientType;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Matrix;

public class GradientDisplay extends Sprite
{
    private var _width : uint;
    private var _height : uint;
    private var dat : GradientData = new GradientData();
    private var gradient : Sprite = new Sprite();
    public var onColorChanged : Function;
    public var maxColors : uint = 15;

    public function init(width : uint, height : uint, onColorChanged : Function) : void
    {
        this.onColorChanged = onColorChanged;
        _width = width;
        _height = height;
        addChild(gradient);

        gradient.addEventListener(MouseEvent.CLICK, addKnob);
    }

    public function setCurrentColor(val : uint) : void
    {
        dat.selectedItem.color = val;
        renderData();
    }

    public function get currentColor():uint
    {
        return dat.selectedItem.color;
    }

    private function addKnob(evt : MouseEvent) : void
    {
        if (dat.colors.length < maxColors)
        {
            var ratio : uint = (mouseX / _width) * 255;
            addColor(0x0, ratio);
            onColorChanged();
        }
    }

    public function addColor(color : uint, ratio : uint) : void
    {
        var newKnob : GradientComponentButton = new GradientComponentButton(color, ratio);
        dat.addItem(newKnob);
        dat.selectedItem = newKnob;
        addChild(newKnob);
        newKnob.y = _height + 2;
        newKnob.x = _width * ratio / 255;
        newKnob.addEventListener(GradientComponentButton.EVENT_DOWN, startKnobDrag);
        newKnob.addEventListener(GradientComponentButton.DELETE_CLICK, deleteKnob);
        renderData();

    }

    public function get ratios() : Array
    {
        return dat.ratios;
    }

    public function get colors() : Array
    {
        return dat.colors
    }

    public function removeAll() : void
    {
        // TODO
    }

    private function deleteKnob(evt : Event) : void
    {
        var btn : GradientComponentButton = GradientComponentButton(evt.target);
        btn.addEventListener(GradientComponentButton.EVENT_DOWN, startKnobDrag);
        btn.addEventListener(GradientComponentButton.DELETE_CLICK, deleteKnob);
        dat.deleteItem(btn);
        removeChild(btn);
        renderData();
        onColorChanged();
    }

    private function startKnobDrag(evt : Event) : void
    {
        dat.selectedItem = GradientComponentButton(evt.target);

        if (dat.selectedItem.ratio != 0 && dat.selectedItem.ratio != 255)
        {
            stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
            stage.addEventListener(MouseEvent.MOUSE_UP, stopKnobDrag);
        }
        onColorChanged();
    }

    private function stopKnobDrag(event : MouseEvent):void
    {
        stage.removeEventListener(MouseEvent.MOUSE_UP, stopKnobDrag);
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
    }

    private function onMouseMove(evt : MouseEvent) : void
    {
        var xc : Number = mouseX;
        if (xc <= 1) xc = 1;
        if (xc >= _width - 1) xc = _width -1;
        dat.selectedItem.x = xc;
        dat.selectedItem.ratio = (xc / _width) * 255;
        renderData();
        onColorChanged();
    }

    private function renderData() : void
    {
        var alphas : Array = [];
        for (var i:int = 0; i < dat.colors.length; i++)
        {
            alphas.push(1);
        }
        var mat : Matrix = new Matrix();
        mat.createGradientBox(_width, _height);
        gradient.graphics.clear();
        gradient.graphics.lineStyle();
        gradient.graphics.beginGradientFill(GradientType.LINEAR, dat.colors, alphas, dat.ratios, mat);
        gradient.graphics.drawRect(0, 0, _width, _height);
        gradient.graphics.endFill();
    }

}
}
