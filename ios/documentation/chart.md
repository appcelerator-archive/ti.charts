# Chart Object

The createChart function creates a chart view object. The object has functions and properties that allow you to control the plots that are rendered in the chart.

<pre>
    var chart = charts.createChart({ ... });
</pre>

## Properties

* plots[array]: Array of plots currently assigned to the chart object

## Functions

### createLinePlot

This function creates a new line plot object and adds it to the chart. See [Line Plot][charts.lineplot] for parameters of this function.

### createBarPlot

This function creates a new bar plot object and adds it to the chart. See [Bar Plot][charts.barplot] for parameters of this function.

### createPiePlot

This function creates a new pie plot object and adds it to the chart. See [Pie Plot][charts.pieplot] for parameters of this function.

### relayout

Forces the chart to be re-formatted. Use this method if you change properties on the chart that affect the formatting and you want the chart to be redrawn.

### add

Adds one or more plots to the chart object.

#### Arguments

Takes one argument, either a plot object or an array of plot objects.

<pre>
    chart.add( plot1 ); 

    - or -

    chart.add([ plot1, plot 2, plot3 ]);
</pre>	

### remove

Removes a plot from the chart object.

#### Arguments

Takes one argument, a plot object to remove.

<pre>
    chart.remove( plot1 );
</pre>

## Events

### touchstart

Fired when a touch start gesture occurs anywhere in the chart.
Note that this event will not be fired if `userInteraction` is enabled on the chart.

#### Properties

* x[int]: the x coordinate of the event from the chart view's coordinate system
* y[int]: the y coordinate of the event from the chart view's coordinate system

<pre>
    chart.addEventListener('touchstart',function(e) {
		Ti.API.info('touchstart X: ' + e.x + ' Y: ' + e.y);
	});
</pre>

### touchmove

Fired when a touch move gesture occurs anywhere in the chart.
Note that this event will not be fired if `userInteraction` is enabled on the chart.

#### Properties

* x[int]: the x coordinate of the event from the chart view's coordinate system
* y[int]: the y coordinate of the event from the chart view's coordinate system

<pre>
    chart.addEventListener('touchmove',function(e) {
		Ti.API.info('touchmove X: ' + e.x + ' Y: ' + e.y);
	});
</pre>

### touchend

Fired when a touch event is completed.
Note that this event will not be fired if `userInteraction` is enabled on the chart.

#### Properties

* x[int]: the x coordinate of the event from the chart view's coordinate system
* y[int]: the y coordinate of the event from the chart view's coordinate system

<pre>
    chart.addEventListener('touchend',function(e) {
		Ti.API.info('touchend X: ' + e.x + ' Y: ' + e.y);
	});
</pre>

### touchcancel

Fired when a touch event is interrupted by the device.
Note that this event will not be fired if `userInteraction` is enabled on the chart.

#### Properties

<pre>
    chart.addEventListener('touchcancel',function(e) {
		Ti.API.info('touchcancel');
	});
</pre>

## License

Copyright(c) 2011-2013 by Appcelerator, Inc. All Rights Reserved. Please see the LICENSE file included in the distribution for further details.

[charts.barplot]: barplot.html 
[charts.lineplot]: lineplot.html
[charts.pieplot]: pieplot.html