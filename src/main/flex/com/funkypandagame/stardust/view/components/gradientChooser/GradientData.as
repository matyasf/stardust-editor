package com.funkypandagame.stardust.view.components.gradientChooser
{
public class GradientData
{

    private const components : Vector.<GradientComponentButton> = new Vector.<GradientComponentButton>();
    private var _selectedItem : GradientComponentButton;

    public function set selectedItem(item : GradientComponentButton) : void
    {
        _selectedItem = item;
        setDeleteButtonState();
        for each (var button : GradientComponentButton in components)
        {
            button.selected = (button == _selectedItem);
        }
    }

    public function deleteItem(item : GradientComponentButton) : void
    {
        components.splice(components.indexOf(item), 1);
        components.sort(sortOnRatio);
        selectedItem = components[0];
        setDeleteButtonState();
    }

    public function addItem(item : GradientComponentButton) : void
    {
        components.push(item);
        components.sort(sortOnRatio);
        selectedItem = item;
        setDeleteButtonState();
    }

    public function get selectedItem() : GradientComponentButton
    {
        return _selectedItem;
    }

    public function get colors() : Array
    {
        components.sort(sortOnRatio);
        var ret : Array = [];
        for (var i:int = 0; i < components.length; i++) {
            ret.push(components[i].color);
        }
        return ret;
    }

    public function get ratios() : Array
    {
        components.sort(sortOnRatio);
        var ret : Array = [];
        for (var i:int = 0; i < components.length; i++)
        {
            ret.push(components[i].ratio);
        }
        return ret;
    }

    public function get alphas() : Array
    {
        components.sort(sortOnRatio);
        var ret : Array = [];
        for (var i:int = 0; i < components.length; i++)
        {
            ret.push(components[i].colorAlpha);
        }
        return ret;
    }

    private function setDeleteButtonState() : void
    {
        for (var i:int = 0; i < components.length; i++)
        {
            if (i == 0 || i == components.length - 1)
            {
                components[i].removeButtonVisible = false;
            }
            else
            {
                components[i].removeButtonVisible = true;
            }
        }
    }

    private static function sortOnRatio(c1 : GradientComponentButton, c2 : GradientComponentButton) : Number
    {
        if (c1.ratio < c2.ratio)
        {
            return -1;
        }
        else if (c1.ratio > c2.ratio)
        {
            return 1;
        }
        return 0;
    }

}
}
