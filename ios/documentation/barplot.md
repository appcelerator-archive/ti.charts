# Chart Object 

The createChart function creates a chart view object. The object has functions and properties that allow you to control the plots that are rendered in the chart.

<pre>
    var chart = charts.createChart({ ... });
</pre>

## Functions

### createBarPlot

This function creates a new bar plot object and adds it to the chart.

#### Arguments

Take one argument, a dictionary with keys:

(Parameters that are not specified will have default values assigned)

* name[string]: name that identifies the plot 
* lineColor[string]: the color of the line bordering the bar  
* lineWidth[float]: the width of the line bordering the bar 
* lineOpacity[float]: the opacity of the line from 0.0 - 1.0 
* fillColor[string]: the color to fill the bar 
* fillGradient[object]: the gradient to fill the bar  
    startColor[string]: the starting color for the gradient 
    endColor[string]: the ending color for the gradient 
    angle[float]: the angle of the gradient in degrees 
* fillOpacity[float]: the opacity from 0.0 - 1.0 
* barDirection[int]: the direction of the bars 
    * charts.DIRECTION\_VERTICAL 
    * charts.DIRECTION\_HORIZONTAL
* barWidth[float]: the width of each bar 
* barOffset[float]: the offset of each bar 
* barCornerRadius[float]: the radius of the edge of the bar 
* labels[object]: the formatting object for the labels 
    * offset[float]: the offset from the bar
    * angle[float]: the rotation angle for the label (in degrees) 
    * color[string]: the color of the label 
    * font[object]: the label font object properties 
        * fontFamily[string]: the font family 
        * fontSize[string]: the font size 
        * fontWeight[string]: the font weight, either normal or bold 
        * fontStyle[string]: the font style, either normal or italics       
* data[array]: the data for the plot. Can be either an array of float values, an array of dictionary values, or a combination of both. Each data item in the array can be one of the following formats:
    * float value (the index of the data in the array will be used as the x-value for line and bar plots)
        * Example: [ 1.0, 2.0, 3.0 ]
    * dictionary with two key-value pairs (the specified 'x' value for each entry will be used as the x-value for line and bar plots)
        * x: float value
        * y: float value
        * Example: [ { x:0, y:1.0 }, { x:1, y:2.0 }, { x:2, y:3.0 } ]
    * dictionary with a key-value pair that has the key defined by the 'dataKey' parameter and a float value (the index of the data in the array will be used as the x-value for line and bar plots)
        * Example: [ { mykey: 1.0 }, { mykey: 2.0 }, { mykey: 3.0 } ]
* dataKey[string]: the name of the key in each data item (only used if the data item is a dictionary and does not contain an 'x' key)

### indexFromViewPoint

This function returns the index that aligns closest to the x position on the chart. Use this function to determine
the index of the data item closest to the point that is touched on the chart.

#### Arguments

Takes one argument, a dictionary with two keys-value pairs:

* x[int]: value of the x-coordinate
* y[int]: value of the y-coordinate

#### Returns

* int: index of data point

<pre>
    var index = barplot.indexFromViewPoint({ x: 20, y:5 });
</pre>

### dataPointFromIndex

This function returns the value and coordinates of the data point at the specified index.

#### Arguments

Takes one argument, the index of the data point

#### Returns

A dictionary of key-value pairs:

* name[string]: the name of the line plot
* index[int]: the index of the point in the data array
* value[float]: the data value for the point
* x[int]: the x coordinate in the chart view of the plot point
* y[int]: the y coordinate in the chart view of the plot point

<pre>
    var info = barplot.dataPointFromIndex(3);
</pre>

## Properties

* plotSpace[object]: The current plot space ranges
    * xRange[object]: the range of the X-axis data within the plot space
        * location[float]: the starting location of the range
        * length[float]: the length of the range
        * minLimit[float]: the minimum value
        * maxLimit[float]: the maximum value
    * yRange[object]: the range of the Y-axis data within the plot space
        * location[float]: the starting location of the range
        * length[float]: the length of the range
        * minLimit[float]: the minimum value
        * maxLimit[float]: the maximum value

## Events

### dataClicked

Fired when a data point on the plot has been clicked.

#### Properties

* name[string]: the name of the bar plot 
* index[int]: the index of the point in the data array 
* value[float]: the data value for the point
* x[int]: the x coordinate in the chart view of the plot point that was clicked
* y[int]: the y coordinate in the chart view of the plot point that was clicked

<pre>
	barPlot.addEventListener('dataClicked',function(e) { 
		Ti.API.info('line ' + e.name + ' clicked: index= ' + e.index + ' value= ' + e.value);  
	});
</pre>

## License

Copyright(c) 2011-2013 by Appcelerator, Inc. All Rights Reserved. Please see the LICENSE file included in the distribution for further details.





