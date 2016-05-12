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
package com.esri.ags.samples.utils
{

import flash.filters.ColorMatrixFilter;

/**
 * A utility class for ColorMatrixFilters that can be easily applied to a Layer or Map.
 * <p>
 * heatMapLayer.filters = [ ColorMatrixUtil.blackAndWhite ];
 * </p>
 */
public class ColorMatrixUtil
{
    private static const rLum:Number = 0.2225;
    private static const gLum:Number = 0.7169;
    private static const bLum:Number = 0.0606;

    private static const _bwMatrix:Array = [ rLum, gLum, bLum, 0, 0,
                                             rLum, gLum, bLum, 0, 0,
                                             rLum, gLum, bLum, 0, 0,
                                             0, 0, 0, 1, 0 ];

    private static const _duskMatrix:Array = [
        0.40, 0.10, 0.10, 0.00, 0.00,
        0.10, 0.40, 0.10, 0.00, 0.00,
        0.10, 0.10, 0.40, 0.00, 0.00,
        0.00, 0.00, 0.00, 1.00, 0.00
        ];

    private static const _bw:ColorMatrixFilter = new ColorMatrixFilter(_bwMatrix);
    private static const _dusk:ColorMatrixFilter = new ColorMatrixFilter(_duskMatrix);

    public function ColorMatrixUtil()
    {
    }

    /**
     * A black and white ColorMatrixFilter.
     */
    public static function get blackAndWhite():ColorMatrixFilter
    {
        return _bw;
    }

    /**
     * The color matrix array values for a dusk ColorMatrixFilter.
     * @return
     *
     */
    public static function get dusk():ColorMatrixFilter
    {
        return _dusk;
    }
}

}
