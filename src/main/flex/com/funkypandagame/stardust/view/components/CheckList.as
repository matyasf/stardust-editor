package com.funkypandagame.stardust.view.components
{
import flash.events.MouseEvent;
import mx.core.IVisualElement;
import spark.components.List;

public class CheckList extends List
{
    public function CheckList()
    {
        super();
        allowMultipleSelection = true;
    }

    /**
     * Override the mouseDown handler to act as though the Ctrl key is always down
     */
    override protected function item_mouseDownHandler(event:MouseEvent):void
    {
        var newIndex:Number = dataGroup.getElementIndex(event.currentTarget as IVisualElement);

        // always assume the Ctrl key is pressed by setting the third parameter of
        // calculateSelectedIndices() to true
        selectedIndices = calculateSelectedIndices(newIndex, event.shiftKey, true);
    }

}
}