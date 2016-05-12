/*
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2008-2012 Esri
//
// All rights reserved under the copyright laws of the United States
// and applicable international laws, treaties, and conventions.
//
// You may freely redistribute and use this software, with or
// without modification, provided you include the original copyright
// and use restrictions.  See use restrictions in the file:
// License.txt and/or use_restrictions.txt.
//
////////////////////////////////////////////////////////////////////////////////
*/
package com.esri.ags.samples.layers
{

import com.esri.ags.layers.Layer;
import com.esri.ags.samples.tasks.supportClasses.ElevationsSOEResult;

import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.Rectangle;

import mx.events.FlexEvent;

/**
 * Allows you to visualize the ElevationsSOE - GetElevationData response as a layer in the ArcGIS API for Flex.
 *
 * <p>Note that ArcGISElevationsSOELayer, like all layers, extend <a target="_blank" href="http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/mx/core/UIComponent.html">UIComponent</a> and thus include basic mouse events, such as:
 * <a target="_blank" href="http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/InteractiveObject.html#event:click">click</a>,
 * <a target="_blank" href="http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/InteractiveObject.html#event:mouseOut">mouseOut</a>,
 * <a target="_blank" href="http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/InteractiveObject.html#event:mouseOver">mouseOver</a>, and
 * <a target="_blank" href="http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/InteractiveObject.html#event:mouseDown">mouseDown</a>,
 * as well as other events like
 * <a target="_blank" href="http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/mx/core/UIComponent.html#event:show">show</a> and
 * <a target="_blank" href="http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/mx/core/UIComponent.html#event:hide">hide</a>,
 * and general properties, such as
 * <a target="_blank" href="http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/DisplayObject.html#alpha">alpha</a> and
 * <a target="_blank" href="http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/DisplayObject.html#visible">visible</a>.</p>
 *
 * <p>Note: ElevationsSOEResult, and other elevations SOE related classes, require a custom Server Objection Extension (SOE) service.
 * <a href="http://sampleserver4.arcgisonline.com/ArcGIS/rest/services/Elevation/ESRI_Elevation_World/MapServer/exts/ElevationsSOE" target="_blank">View the service</a>.</p>
 *
 * @since Your API for Flex 1.0
 *
 * @see com.esri.ags.samples.tasks.ElevationsSOETask
 */
public class ArcGISElevationsSOELayer extends Layer
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    private var _matrix:Matrix = new Matrix(1, 0, 0, 1, 0, 0);
    private var _rect:Rectangle = new Rectangle();
    private var _alpha:uint = 0x9F << 24;
    private var _bitmapData:BitmapData;

    [Bindable]
    private var _elevationResult:ElevationsSOEResult;

    private var _cellColor:Vector.<uint>;

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    /**
     * Creates a new ArcGISElevationsSOELayer object.
     *
     */
    public function ArcGISElevationsSOELayer()
    {
        addEventListener(FlexEvent.INITIALIZE, initializeHandler);
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function initializeHandler(event:FlexEvent):void
    {
        removeEventListener(FlexEvent.INITIALIZE, initializeHandler);
        setLoaded(true);
    }

    /**
     * @private
     */
    override protected function updateLayer():void
    {
        if (elevationResult === null)
        {
            return;
        }
        if (_cellColor === null)
        {
            return;
        }
        else if (_cellColor.length == 0)
        {
            calculateCellColors();
        }

        if (_bitmapData === null)
        {
            _bitmapData = new BitmapData(map.width, map.height, true, 0x000000);
        }

        _rect.x = 0;
        _rect.y = 0;
        _rect.width = map.width;
        _rect.height = map.height;
        _bitmapData.fillRect(_rect, 0x000000);

        _bitmapData.lock();

        try
        {


            const cellSizeInPx:Number = elevationResult.cellSize * map.width / map.extent.width;
            const cellSize2:Number = cellSizeInPx / 2;
            var y:Number;
            var x:Number;

            var cols:Number = elevationResult.numberOfColumns;
            var rows:Number = elevationResult.numberOfRows;
            var cell:int = 0;
            var bitMapRows:int = rows - 1;
            for (var r:int = bitMapRows; r >= 0; r--)
            {
                y = map.toScreenY(elevationResult.yCoordLLCenter + r * elevationResult.cellSize) - cellSize2;
                for (var c:int = 0; c < cols; c++)
                {
                    x = map.toScreenX(elevationResult.xCoordLLCenter + c * elevationResult.cellSize) - cellSize2;

                    _rect.x = x - cellSize2;
                    _rect.y = y - cellSize2;
                    _rect.width = cellSizeInPx;
                    _rect.height = cellSizeInPx;
                    _bitmapData.fillRect(_rect, _cellColor[cell]);
                    cell++;
                }
            }
        }
        finally
        {
            _bitmapData.unlock();
        }

        _matrix.tx = toScreenX(map.extent.xmin);
        _matrix.ty = toScreenY(map.extent.ymax);

        graphics.clear();
        graphics.beginBitmapFill(_bitmapData, _matrix, false, true);
        graphics.drawRect(_matrix.tx, _matrix.ty, map.width, map.height);
        graphics.endFill();
    }

    /**
     * @private
     */
    private function calculateCellColors():void
    {

        var elevationDataArray:Array = elevationResult.elevationData;
        var thematicMin:int = elevationDataArray[0];
        var thematicMax:int = elevationDataArray[0];

        var elevationValue:int;
        for (var i:int = 0; i < elevationDataArray.length; i++)
        {
            elevationValue = elevationDataArray[i];
            if (elevationValue < thematicMin)
            {
                thematicMin = elevationValue;
            }
            if (elevationValue > thematicMax)
            {
                thematicMax = elevationValue;
            }
        }

        //Blue, Green, Yellow, Orange, Red, White - ARGB (Alpha Red Green Blue)
        var colorRanges:Array = [ 0xFF298D3D, 0xFF3759FA, 0xFFE1FF00, 0xFFE87300, 0xFFE20000, 0xFFF6C5C5 ];
        var lastColorRangeIndex:int = colorRanges.length - 1;
        var totalRange:int = thematicMax - thematicMin;
        var portion:int = totalRange / colorRanges.length;



        var thematicRangeValues:Array;
        var minValue:int = thematicMin;
        var maxValue:int = thematicMin + portion;

        var startValue:int;

        for each (var elevValue:int in elevationDataArray)
        {
            startValue = thematicMin;
            for (var j:int = 0; j < colorRanges.length; j++)
            {
                thematicRangeValues = getEnumerableRange(startValue, portion);
                if (thematicRangeValues.indexOf(elevValue) != -1)
                {
                    _cellColor.push(colorRanges[j]);
                    break;
                }
                else if (j == lastColorRangeIndex)
                {
                    _cellColor.push(colorRanges[lastColorRangeIndex]);
                }
                startValue = startValue + portion;
            }
        }
    }

    /**
     * @private
     */
    private function getEnumerableRange(start:int, count:int):Array
    {
        var range:Array = [];
        var beginNum:int = start;
        for (var i:int = 0; i < count; i++)
        {
            range.push(beginNum);
            beginNum++;
        }
        return range;
    }

    /**
     * Result of a GetElevationData request from the ElevationsSOE, this contains properties used to render the elevation surface.
     */
    public function get elevationResult():ElevationsSOEResult
    {
        return _elevationResult;
    }

    /**
     * @private
     */
    public function set elevationResult(value:ElevationsSOEResult):void
    {
        _elevationResult = value;
        _cellColor = new Vector.<uint>();
        invalidateLayer();
    }

    /**
     * Clears the layer and sets the elevationResult to null.
     */
    public function clear():void
    {
        graphics.clear();
        _cellColor = null;
        elevationResult = null;
    }


}
}
