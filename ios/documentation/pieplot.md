# Chart Object 

The createChart function creates a chart view object. The object has functions and properties that allow you to control the plots that are rendered in the chart.

<pre>
    var chart = charts.createChart({ ... });
</pre>

## Functions

### createPiePlot

This function creates a new pie plot object and adds it to the chart.

#### Arguments

Take one argument, a dictionary with keys:

(Parameters that are not specified will have default values assigned)

* name[string]: name that identifies the plot 
* lineColor[string]: the color of the line bordering the pie chart  
* lineWidth[float]: the width of the line bordering the pie chart 
* lineOpacity[float]: the opacity of the line from 0.0 - 1.0 
* startAngle[float]: the starting angle of the first pie slice (in degrees) 
* direction[int]: the direction to generate the pie slices 
    * charts.DIRECTION\_CLOCKWISE 
    * charts.DIRECTION\_COUNTERCLOCKWISE 
* radius[float]: the radius for the pie 
* explodeOffset[float]: the offset for a pie slice when pulled out from the pie 
* labels[object]: the formatting object for the labels 
    * offset[float]: the offset from the pie
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

## Properties

* explode[array]: integer array of pie slices to pull out from the pie. Setting this property to null will reset all pie slices. 

<pre>
	pie.explode = [ 1, 2, 4 ];
	pie.explode = null; 
</pre>

## Events

### dataClicked

If 'userInteraction' is enabled on the chart, then a 'dataClicked' event is fired when the user clicks on a pie slice on the plot.

#### Properties

* name[string]: the name of the pie plot 
* index[int]: the index of the point in the data array 
* value[float]: the data value for the point

<pre>
	piePlot.addEventListener('dataClicked',function(e) { 
		Ti.API.info('line ' + e.name + ' clicked: index= ' + e.index + ' value= ' + e.value);  
	});
</pre>

## License

Copyright(c) 2011-2013 by Appcelerator, Inc. All Rights Reserved. Please see the LICENSE file included in the distribution for further details.





