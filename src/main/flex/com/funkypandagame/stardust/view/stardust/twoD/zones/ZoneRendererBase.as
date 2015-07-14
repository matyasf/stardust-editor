package com.funkypandagame.stardust.view.stardust.twoD.zones
{

import flash.display.DisplayObjectContainer;
import flash.events.MouseEvent;

import flashx.textLayout.formats.VerticalAlign;

import mx.binding.utils.BindingUtils;

import mx.core.IVisualElement;

import spark.components.Button;
import spark.components.DataGroup;
import spark.components.Group;
import spark.components.Label;
import spark.components.supportClasses.ItemRenderer;
import spark.layouts.HorizontalLayout;
import spark.layouts.supportClasses.LayoutBase;

[DefaultProperty("mxmlChildren")]
public class ZoneRendererBase extends ItemRenderer
{
    private var nameLabel : Label;
    private var removeButton : Button;
    private const contentContainer : Group = new Group();

    override public function set owner(val : DisplayObjectContainer) :void
    {
        super.owner = val;
        BindingUtils.bindSetter( function(len : int) : void
        {
            removeButton.enabled = len > 1;
        }, owner, ["dataProvider", "length"], false, true);
    }

    override protected function createChildren() : void
    {
        opaqueBackground = 0x565656;
        autoDrawBackground = false;
        percentWidth = 100;
        super.createChildren();
        const hLayout : HorizontalLayout = new HorizontalLayout();
        hLayout.verticalAlign = VerticalAlign.MIDDLE;
        super.layout = hLayout;

        contentContainer.percentWidth = 100;
        addElement( contentContainer );

        removeButton = new Button();
        removeButton.label = "Remove";
        removeButton.percentHeight = 100;
        removeButton.addEventListener( MouseEvent.CLICK, onRemoveClick );
        addElement( removeButton );
    }

    protected function onRemoveClick( e : MouseEvent ) : void
    {
        DataGroup(owner).dataProvider.removeItemAt( DataGroup(owner).dataProvider.getItemIndex(data) );
    }

    public function set mxmlChildren( value : Array ) : void
    {
        contentContainer.removeAllElements();
        for ( var i : int = 0; i < value.length; i ++ )
        {
            contentContainer.addElement( IVisualElement( value[i] ) );
        }
    }

    override public function set layout( val : LayoutBase ) : void
    {
        contentContainer.layout = val;
    }

    override public function get layout() : LayoutBase
    {
        return contentContainer.layout;
    }

    public function set nameText( val : String ) : void
    {
        if (nameLabel == null)
        {
            nameLabel = new Label();
            nameLabel.maxDisplayedLines = 2;
            addElementAt(nameLabel, 0);
        }
        nameLabel.text = val;
    }

}
}
