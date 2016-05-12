/*
   Copyright (c) 2011 ESRI

   All rights reserved under the copyright laws of the United States
   and applicable international laws, treaties, and conventions.

   You may freely redistribute and use this sample code, with or
   without modification, provided you include the original copyright
   notice and use restrictions.

   See use restrictions in use_restrictions.txt.
 */
package com.esri.ags.skins.supportClasses
{

import com.esri.ags.portal.supportClasses.PopUpFieldInfo;
import com.esri.ags.portal.supportClasses.PopUpMediaInfo;

import flash.events.Event;
import flash.events.MouseEvent;

import spark.components.supportClasses.ButtonBase;
import spark.components.supportClasses.SkinnableComponent;

/**
 * @private
 */
public class PopUpMediaBrowser extends SkinnableComponent
{
    //--------------------------------------------------------------------------
    //
    //  Skin Parts
    //
    //--------------------------------------------------------------------------

    [SkinPart(required="true")]

    /**
     * An skin part for the next button
     */
    public var nextButton:ButtonBase;

    [SkinPart(required="true")]

    /**
     * A skin part for the previous button
     */
    public var previousButton:ButtonBase;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  activeIndex
    //----------------------------------

    private var _activeIndex:int;
    private var _activeIndexChanged:Boolean;

    /**
     * The index for the currently selected PopUpMediaInfo.
     */
    public function get activeIndex():int
    {
        return _activeIndex;
    }

    /**
     * @private
     */
    public function set activeIndex(value:int):void
    {
        if (_activeIndex !== value)
        {
            _activeIndex = value;
            _activeIndexChanged = true;
            invalidateProperties();
            dispatchEvent(new Event("activeIndexChanged"));
        }
    }

    //----------------------------------
    //  activeMediaInfo
    //----------------------------------

    [Bindable(event="activeIndexChanged")]

    /**
     * The currently selected PopUpMediaInfo.
     */
    public function get activeMediaInfo():PopUpMediaInfo
    {
        return (popUpMediaInfos && popUpMediaInfos.length > activeIndex) ? popUpMediaInfos[activeIndex] : null;
    }

    //----------------------------------
    //  attributes
    //----------------------------------

    /**
     * The graphic's raw attribute data.
     */
    public var attributes:Object;

    //----------------------------------
    //  formattedAttributes
    //----------------------------------

    /**
     * The graphic's formatted attribute data.
     */
    public var formattedAttributes:Object;

    //----------------------------------
    //  popUpFieldInfos
    //----------------------------------

    /**
     * The pop up's field infos.
     */
    public var popUpFieldInfos:Array;

    //----------------------------------
    //  popUpMediaInfos
    //----------------------------------

    private var _popUpMediaInfos:Array;
    private var _popUpMediaInfosChanged:Boolean;

    /**
     * The pop up's media infos.
     */
    public function get popUpMediaInfos():Array
    {
        return _popUpMediaInfos;
    }

    /**
     * @private
     */
    public function set popUpMediaInfos(value:Array):void
    {
        _popUpMediaInfos = value;
        _popUpMediaInfosChanged = true;
        invalidateProperties();
        activeIndex = 0;
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    override protected function commitProperties():void
    {
        super.commitProperties();

        if (_popUpMediaInfosChanged)
        {
            _popUpMediaInfosChanged = false;
            if (skin)
            {
                skin.invalidateProperties();
            }
            if (nextButton)
            {
                if (popUpMediaInfos && popUpMediaInfos.length > 1)
                {
                    nextButton.visible = true;
                }
                else
                {
                    nextButton.visible = false;
                }
            }
            if (previousButton)
            {
                if (popUpMediaInfos && popUpMediaInfos.length > 1)
                {
                    previousButton.visible = true;
                }
                else
                {
                    previousButton.visible = false;
                }
            }
        }

        if (_activeIndexChanged)
        {
            _activeIndexChanged = false;
            if (skin)
            {
                skin.invalidateProperties();
            }
        }
    }

    override protected function partAdded(partName:String, instance:Object):void
    {
        super.partAdded(partName, instance);

        if (instance == nextButton)
        {
            nextButton.addEventListener(MouseEvent.CLICK, nextButton_clickHandler);
        }
        else if (instance == previousButton)
        {
            previousButton.addEventListener(MouseEvent.CLICK, previousButton_clickHandler);
        }
    }

    override protected function partRemoved(partName:String, instance:Object):void
    {
        super.partRemoved(partName, instance);

        if (instance == nextButton)
        {
            nextButton.removeEventListener(MouseEvent.CLICK, nextButton_clickHandler);
        }
        else if (instance == previousButton)
        {
            previousButton.removeEventListener(MouseEvent.CLICK, previousButton_clickHandler);
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     * Returns an Array of Objects with name and value properties.
     */
    public function getChartData():Array
    {
        var result:Array;

        var attributes:Object = this.attributes;
        var mediaInfo:PopUpMediaInfo = this.activeMediaInfo;
        if (attributes && mediaInfo.chartFields)
        {
            result = [];
            var normalizer:Number = attributes[mediaInfo.chartNormalizationField];
            for each (var chartField:String in mediaInfo.chartFields)
            {
                var value:Number = attributes[chartField];
                if (isFinite(value) && isFinite(normalizer) && normalizer != 0)
                {
                    value /= normalizer;
                }
                var chartData:Object = { name: chartField, value: value };
                var fieldInfo:PopUpFieldInfo = getPopUpFieldInfo(chartField);
                if (fieldInfo && fieldInfo.label)
                {
                    chartData.name = fieldInfo.label;
                }
                result.push(chartData);
            }
        }

        return result;
    }

    private function getPopUpFieldInfo(fieldName:String):PopUpFieldInfo
    {
        var result:PopUpFieldInfo;

        var fieldInfos:Array = this.popUpFieldInfos;
        if (fieldInfos)
        {
            for (var i:int = 0, l:int = fieldInfos.length; i < l; i++)
            {
                var fieldInfo:PopUpFieldInfo = fieldInfos[i];
                if (fieldName === fieldInfo.fieldName)
                {
                    result = fieldInfo;
                    break;
                }
            }
        }

        return result;
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    private function nextButton_clickHandler(event:MouseEvent):void
    {
        if (popUpMediaInfos && popUpMediaInfos.length > 0)
        {
            if (activeIndex == popUpMediaInfos.length - 1)
            {
                activeIndex = 0; // go to the beginning
            }
            else
            {
                activeIndex++;
            }
        }
    }

    private function previousButton_clickHandler(event:MouseEvent):void
    {
        if (popUpMediaInfos && popUpMediaInfos.length > 0)
        {
            if (activeIndex == 0)
            {
                activeIndex = popUpMediaInfos.length - 1; // go to the end
            }
            else
            {
                activeIndex--;
            }
        }
    }
}

}
