package com.funkypandagame.stardust.view.components.gradientChooser
{
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

public class GradientComponentButton extends Sprite
{
    public static const EVENT_DOWN : String = "knob_down";
    public static const DELETE_CLICK : String = "delete_click";

    [Embed(source="../../../../../../../resources/deleteIcon.png")]
    private static const DeleteImage : Class;

    private var _color : uint;
    private var _selected : Boolean;
    private var _removeButtonVisible : Boolean;
    public var ratio : uint;
    private var colorDisplay : Sprite;
    private var removeButton : Sprite;

    public function GradientComponentButton(color : uint, ratio : uint)
    {
        colorDisplay = new Sprite();
        addChild(colorDisplay);

        removeButton = new Sprite();
        var delGfx : Bitmap = new DeleteImage();
        delGfx.x = -delGfx.width / 2;
        removeButton.addChild(delGfx);
        removeButton.y = 20;

        this.color = color;
        this.ratio = ratio;

        colorDisplay.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
        removeButton.addEventListener(MouseEvent.CLICK, onMouseClick);
        removeButton.visible = false;
        removeButtonVisible = true;
    }

    private function onMouseDown(mEvent : MouseEvent) : void
    {
        dispatchEvent(new Event(EVENT_DOWN));
    }

    private function onMouseClick(mEvent : MouseEvent) : void
    {
        dispatchEvent(new Event(DELETE_CLICK));
    }

    public function get color():uint
    {
        return _color;
    }

    public function set color(value:uint):void
    {
        _color = value;
        redraw();
    }

    public function set removeButtonVisible(val : Boolean) : void
    {
        if (_removeButtonVisible == val)
        {
            return;
        }
        _removeButtonVisible = val;
        if (val)
        {
            addChild(removeButton);
        }
        else
        {
            removeChild(removeButton);
        }
    }

    public function set selected(val : Boolean) : void
    {
        if (_selected == val)
        {
            return;
        }
        removeButton.visible = val;
        _selected = val;
        redraw();
    }

    private function redraw() : void
    {
        colorDisplay.graphics.clear();
        colorDisplay.graphics.lineStyle(0,0,0);
        if (_selected)
        {
            colorDisplay.graphics.beginFill(0x0);
            colorDisplay.graphics.drawRect(-8, 0, 16, 16);
            colorDisplay.graphics.beginFill(_color);
            colorDisplay.graphics.drawRect(-6, 2, 12, 12);
        }
        else
        {
            colorDisplay.graphics.beginFill(0x0);
            colorDisplay.graphics.drawRect(-7, 1, 14, 14);
            colorDisplay.graphics.beginFill(_color);
            colorDisplay.graphics.drawRect(-6, 2, 12, 12);
        }
    }
}
}
