# charts Module

## Description

This module lets you create interactive charts and graphs with dynamic data updating capabilities. The following chart and graph types are supported:

* Line   
* Bar  
* Pie  

## Getting Started

View the [Using Titanium Modules](http://docs.appcelerator.com/titanium/latest/#!/guide/Using_Titanium_Modules) document for instructions on getting
started with using this module in your application.

## Accessing the charts Module

To access this module from JavaScript, you would do the following:

<pre>
    var charts = require("ti.charts");
</pre>

The charts variable is a reference to the Module object.

## Breaking Changes

If you are upgrading from version 1.0 of this module you should be aware of the following breaking changes to the API:

* majorTicks reorganization
    * 'majorTickInterval' has been renamed to 'interval' and moved inside of the majorTicks section
    * 'majorGridLines' has been renamed to 'gridLines' and moved inside of the majorTicks section
    * 'labels' has been moved inside of the majorTicks section
* minorTicks reorganization
    * 'minorTickCount' has been renamed to 'count' and moved inside of the minorTicks section
    * 'minorGridLines' has been renamed to 'gridLines' and moved inside of the minorTicks section

## Understanding Chart Components

A chart is composed of several components that are used to format the display of your data. Each of the following components can be customized to your specific charting needs:

* Chart View
* Plotting Area
* Axes
* Plotting Space
* Plots

### Chart View

The Chart View is the central container for your charts and graphs. It is responsible for laying out and displaying the title, axes, and plots.

### Plottting Area

The Plotting Area is the part of the chart where the data is plotted. It is typically bordered by the chart axes (for line and bar charts) and can contain major and minor gridlines.

### Axes

The Axes describe the scale of the plot data that is in your plots. Each axis can display major and minor tick marks, labels, and a title.

### Plotting Space

The Plotting Space defines the mapping between the coordinate space of the data and the drawing space of the plotting area. 

### Plots

The Plots are the visual representations of the data. Some plot types can be mixed to create a chart with multiple plots. For example, a line and a bar plot can be set in the same chart. A pie chart cannot be combined with any other plot type.

## Module functions

### charts.createChart

This function creates the chart view object.

#### Arguments

Takes one argument, a dictionary with keys:

(Parameters that are not specified will have default values assigned) 

* All of the standard keys from Titanium.UI.View, such as: 
    * top 
    * bottom 
    * width 
    * height 
    * orientationModes
    * etc. 
* title[object]: title properties 
    * text[string]: title text 
    * color[string]: the color of the title 
    * font[object]: the title font object properties 
        * fontFamily[string]: the font family 
        * fontSize[string]: the font size 
        * fontWeight[string]: the font weight, either normal or bold 
        * fontStyle[string]: the font style, either normal or italics 
    * location[int]: the location of the title text 
        * charts.LOCATION\_TOP 
        * charts.LOCATION\_BOTTOM 
        * charts.LOCATION\_LEFT 
        * charts.LOCATION\_RIGHT 
        * charts.LOCATION\_TOP_LEFT 
        * charts.LOCATION\_TOP_RIGHT 
        * charts.LOCATION\_BOTTOM_LEFT 
        * charts.LOCATION\_BOTTOM_RIGHT 
        * charts.LOCATION\_CENTER 
    * offset[object]: the offset object for the title 
        * x[float]: the offset in the x direction from the edge 
        * y[float]: the offset in the y direction from the edge 
* padding[object]: the external padding between the view edge and the plot area 
    * top[float]: the padding at the top edge of the chart 
    * left[float]: the padding at the left edge of the chart 
    * right[float]: the padding at the right edge of the chart 
    * bottom[float]: the padding at the bottom edge of the chart 
* fillColor[string]: the fill color for the chart area
* fillGradient[object]: the fill gradient for the chart area
    * startColor[string]: the starting color for the gradient
    * endColor[string]: the ending color for the gradient
    * angle[float]: the angle of the gradient in degrees
* fillOpacity[float]: the opacity from 0.0 - 1.0
* plotArea[object]: the plot area object
    * borderRadius[float]: the border radius for the plot area 
    * borderColor[string]: the border color for the plot area 
    * borderWidth[float]: the border width for the plot area 
    * borderOpacity[float]: the opacity from 0.0 - 1.0 
    * padding[object]: the internal padding between the plot area and the graph 
        * top[float]: the padding at the top edge of the chart 
        * left[float]: the padding at the left edge of the chart 
        * right[float]: the padding at the right edge of the chart 
        * bottom[float]: the padding at the bottom edge of the chart 
    * backgroundColor[string]: the background color for the plot area frame
    * backgroundGradient[object]: the background gradient for the plot area frame
        * startColor[string]: the starting color for the gradient
        * endColor[string]: the ending color for the gradient
        * angle[float]: the angle of the gradient in degrees
    * backgroundOpacity[float]: the opacity from 0.0 - 1.0
    * fillColor[string]: the fill color for the plot area
    * fillGradient[object]: the fill gradient for the plot area
        * startColor[string]: the starting color for the gradient
        * endColor[string]: the ending color for the gradient
        * angle[float]: the angle of the gradient in degrees
    * fillOpacity[float]: the opacity from 0.0 - 1.0
* theme[string]: the theme name containing default settings for the chart 
    * charts.THEME\_DARK\_GRADIENT 
    * charts.THEME\_WHITE 
    * charts.THEME\_BLACK 
    * charts.THEME\_SLATE 
    * charts.THEME\_STOCKS 
* userInteraction[boolean]: true to enable user interaction with the chart, including:
    * allow pinch-zooming of the chart 
    * allow moving the chart within the plot area
    * Note that enabling userInteraction will prevent the `touch` events from being fired
* plotSpace[object]: the plot space object 
    * scaleToFit[boolean]: if true, the plotting space is automatically rescaled to fit the entire set of data 
    * expandRangeByFactor[float]: if 'scaleToFit' is true, the plotting space is expanded by this value to provide a customizable size for the data
    * xRange[object]: the range of the X-axis data within the plot space
        * location[float]: the starting location of the range
        * length[float]: the length of the range
    * yRange[object]: the range of the Y-axis data within the plot space
        * location[float]: the starting location of the range
        * length[float]: the length of the range
* xAxis[object]: the X-axis definition object 
    * origin[float]: the point where this axis intersects the orthogonal axis 
    * align[int]: the alignment for the axis. This creates a 'floating' axis that remains aligned to the specified edge of the chart (setting this property will override the 'origin' property)
        * ALIGNMENT\_LEFT
        * ALIGNMENT\_RIGHT
        * ALIGNMENT\_TOP
        * ALIGNMENT\_BOTTOM
    * alignOffset[int]: the offset toward the middle of the chart from the edge specified by the 'align' property
    * lineColor[string]: the color of the axis line 
    * lineWidth[float]: the width of the axis line
    * lineOpacity[float]: the opacity of the line from 0.0 - 1.0
    * title[object]: the title for the axis
        * text[string]: title text 
        * color[string]: the color of the title 
        * font[object]: the title font object properties 
            * fontFamily[string]: the font family 
            * fontSize[string]: the font size 
            * fontWeight[string]: the font weight, either normal or bold 
            * fontStyle[string]: the font style, either normal or italics 
        * offset[object]: the offset object for the title 
            * x[float]: the offset in the x direction from the edge 
            * y[float]: the offset in the y direction from the edge
    * tickDirection[int]: the direction to display the tick marks
        * SIGN\_NEGATIVE: ticks are displayed on the negative axis side (default)
        * SIGN\_POSITIVE: ticks are displayed on the positive axis side
    * visibleRange[object]: the visible range of the axis
        * location[float]: the starting location of the range
        * length[float]: the length of the range
    * majorTicks[object]: the formatting object for the major tick marks
        * color[string]: the color of the tick mark 
        * width[float]: the width of the tick mark 
        * length[float]: the length of the tick mark 
        * opacity[float]: the opacity from 0.0 - 1.0 
        * interval[float]: the interval of major ticks on the axis
        * gridLines[object]: the formatting object for the major grid lines
            * color[string]: the color of the grid line
            * width[float]: the width of the grid line
            * opacity[float]: the opacity from 0.0 - 1.0
            * range[object]: the visible range of the grid lines in the orthogonal direction
                * location[float]: the starting location of the range
                * length[float]: the length of the range
        * labels[object]: the formatting object for the axis labels
            * offset[float]: the offset from the axis
            * angle[float]: the rotation angle for the label (in degrees)
            * color[string]: the color of the label
            * font[object]: the label font object properties
                * fontFamily[string]: the font family
                * fontSize[string]: the font size
                * fontWeight[string]: the font weight, either normal or bold
                * fontStyle[string]: the font style, either normal or italics
            * textAlign[int]: the alignment of the label
                * ALIGNMENT\_LEFT
                * ALIGNMENT\_CENTER
                * ALIGNMENT\_RIGHT
                * ALIGNMENT\_TOP
                * ALIGNMENT\_MIDDLE
                * ALIGNMENT\_BOTTOM
            * numberFormat[string]: the formatting string for numeric values (e.g. "###0.00").  See [Number Format Patterns](http://unicode.org/reports/tr35/tr35-6.html#Number_Format_Patterns) for details.
            * numberPrefix[string]: the prefix string for the formatted numeric value (overrides any prefix specified in the format)
            * numberSuffix[string]; the suffix string for the formatted numeric value (overrides any suffix specified in the format)
            * numberFormatPositive[string]: the formatting string for positive numeric values (e.g. "###0.00") (overrides 'numberFormat' property value for positive numeric values)
            * numberPrefixPositive[string]: the prefix string for the formatted positive numeric values (overrides 'numberPrefix' property value for positive numeric values)
            * numberSuffixPositive[string]; the suffix string for the formatted positive numeric values (overrides 'numberSuffix' property value for positive numeric values)
            * numberFormatNegative[string]: the formatting string for negative numeric values (e.g. "###0.00") (overrides 'numberFormat' property value for negative numeric values)
            * numberPrefixNegative[string]: the prefix string for the formatted negative numeric values (overrides 'numberPrefix' property value for negative numeric values)
            * numberSuffixNegative[string]; the suffix string for the formatted negative numeric values (overrides 'numberSuffix' property value for negative numeric values)
        * locations[array]: an array of major tick locations or an array of dictionary items specifying the location and text for each major tick. Each item must be of one of the following formats:
            * float value (the location of the major tick mark)
                * Example: [ 3, 6, 9, 12 ];
            * dictionary with a single key-value pairs (the specified 'x' value for each entry will be used as the x-value for line and bar plots)
                  * value[float]: location of the major tick
                  * text[string]: label to display at the major tick location
                      * Example: [ { value: 3, text: 'Mar' }, { value: 6, text: 'Jun' }, { value: 9, text: 'Sep' }, { value: 12, text: 'Dec' } ]
    * minorTicks[object]: the formatting object for the minor tick marks
        * color[string]: the color of the tick mark 
        * width[float]: the width of the tick mark 
        * length[float]: the length of the tick mark 
        * opacity[float]: the opacity from 0.0 - 1.0 
        * count[float]: the number of minor ticks between each major tick
        * gridLines[object]: the formatting object for the minor grid lines
            * color[string]: the color of the grid line
            * width[float]: the width of the grid line
            * opacity[float]: the opacity from 0.0 - 1.0
* yAxis[object]: the Y-axis definition object
    * (same properties as the xAxis)
 	    
#### Plots

Once the chart view object is created, plots can be added and removed from the chart. See [Chart][charts.chart] for details.

## Using this module

- Put the module zip file into the root folder of your Titanium application. 
- Set the `<module>` element in tiapp.xml, such as this: 
    <modules> 
	    <module version="1.0">ti.charts</module> 
    </modules> 

## Usage

See the app.js file in the example folder of the module folder.

## Author

Jeff English

## Module History

View the [change log](changelog.html) for this module.

## Feedback and Support

Please direct all questions, feedback, and concerns to [info@appcelerator.com](mailto:info@appcelerator.com?subject=iOS%20Charts%20Module).

## License

Copyright(c) 2011-2013 by Appcelerator, Inc. All Rights Reserved. Please see the LICENSE file included in the distribution for further details.

[charts.chart]: chart.html
