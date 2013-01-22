// Private implementation details for commonJS module

var Charts = null;
var demoChart = null;
var linePlot = null;
var vertLine = null;
var btnAdd = null;
var popup = null;
var popupLabel = null;

// Public implementation details for commonJS module

exports.initialize = function (chartsModule) {
    // Save the module object -- we'll need it later
    Charts = chartsModule;
}

exports.cleanup = function () {
    popup = null;
    popupLabel = null;
    btnAdd = null;
    vertLine = null;
    linePlot = null;
    demoChart = null;
    Charts = null;
}

exports.create = function (win) {
    win.add(Ti.UI.createLabel({
        text:'Click & Drag a data point',
        width:Ti.UI.SIZE || 'auto',
        height:Ti.UI.SIZE || 'auto',
        top:8,
        right:40,
        color:'lightgray',
        opacity:0.5,
        zIndex:10
    }));
    btnAdd = Ti.UI.createButton({
        title:"Add data",
        top:8,
        left:8,
        width:80,
        height:30,
        zIndex:10
    });
    win.add(btnAdd);
    btnAdd.addEventListener('click', function (e) {
        if (demoChart.plotSpace.xRange.length < 24) {
            linePlot.appendData([ -50.0 + Math.floor(Math.random() * 100) ]);

            // Since we just added a new data item and we want to keep the y axis
            // on the right hand side of the chart, we need to adjust the visibleRange,
            // yAxis origin, and the xRange accordingly

            // Nested property updates are not working currently (TIMOB-2392). So we need to
            // work-around it by updating the entire top-level property.
            xa = demoChart.xAxis;
            xa.visibleRange.length += 1;
            demoChart.xAxis = xa;

            ps = demoChart.plotSpace;
            ps.xRange.length += 1.0;
            demoChart.plotSpace = ps;

            // The properties we just changed require the chart layout to be refreshed
            demoChart.relayout();

            // Hide the popup
            popup.left = -1000;
        } else {
            btnAdd.hide();
        }

    });

    // Create a chart view to contain the plot
    demoChart = Charts.createChart({
        top:0,
        left:0,
        width:'100%',
        height:'100%',
        fillColor:'white',
        orientationModes:[
            Ti.UI.PORTRAIT,
            Ti.UI.UPSIDE_PORTRAIT,
            Ti.UI.LANDSCAPE_LEFT,
            Ti.UI.LANDSCAPE_RIGHT
        ],

        fillGradient:{
            startColor:'#000000',
            endColor:'#ffffff',
            angle:45.0
        },

        // Configure the external padding -- the area between the view edge and the plot area frame
        padding:{
            top:5,
            left:5,
            right:5,
            bottom:5
        },

        // Configure the plot area -- the area where the chart is drawn
        plotArea:{
            borderRadius:5.0,
            borderColor:'#48C',
            borderWidth:2.0,
            // Configure the inner padding -- the area between the plot area frame and the actual plot area
            padding:{
                top:0.0,
                left:0.0,
                right:0.0,
                bottom:25.0
            },

            // Configure the colors for the plot area
            // backgroundColor is color for the plot area frame
            // fillColor is the  color for the plot area
            backgroundColor:'#BFEFFF',
            fillColor:'white'
        },

        // Configure the xAxis
        xAxis:{
            // origin defines where it intercepts the orthogonal axis (the y-axis)
            origin:-50,
            // No line
            lineWidth:0.0,
            visibleRange:{ location:-1.0, length:15.0 },
            //tickDirection indicates which side of the axis the ticks are drawn -- default is negative
            tickDirection:Charts.SIGN_NEGATIVE,
            majorTicks:{
                color:'#c0c0c0',
                width:2.0,
                length:4.0,
                locations:[
                    { value:0, text:"Jan '11" },
                    { value:3, text:"Apr '11" },
                    { value:6, text:"Jul '11" },
                    { value:9, text:"Oct '11" },
                    { value:12, text:"Jan '12" },
                    { value:15, text:"Apr '12" },
                    { value:18, text:"Jul '12" },
                    { value:21, text:"Oct '12" }
                ],
                labels:{
                    offset:0.0,
                    color:'gray',
                    font:{ fontFamily:'Helvetica', fontSize:12 },
                    textAlign:Charts.ALIGNMENT_CENTER
                }
            }
        },

        // Configure the yAxis
        yAxis:{
        	// We want the y axis always aligned on the right of the chart
            align: Charts.ALIGNMENT_RIGHT,
            alignOffset:0.0,
			
            // No line
            lineWidth:0.0,
			
            visibleRange:{ location:-50.0, length:100.0 },
            tickDirection:Charts.SIGN_NEGATIVE,
            majorTicks:{
                color:'#c0c0c0',
                width:2.0,
                opacity:0.2,
                length:0.0,
                interval:10.0,
                gridLines:{
                    width:2.0,
                    color:'#c0c0c0',
                    opacity:0.2
                },
                labels:{
                    offset:5.0,
                    color:'gray',
                    font:{ fontFamily:'Helvetica', fontSize:12 },
                    textAlign:Charts.ALIGNMENT_BOTTOM,
					// Format numbers according to standard number format patterns. Specifying a prefix 
					// or suffix will override any prefix or suffix in the number format
					//   numberFormat:"#",
                    //   numberSuffix:"%"
					// is equivalent to
					//   numberFormat: "#'%'"
                    numberFormat: "#'%'"
                }
            }
        },

        plotSpace:{
            scaleToFit:false,
            xRange:{ location:-1.0, length:15.0 },
            yRange:{ location:-50.0, length:100.0 }
        },
        // Disable user interaction -- defaults to true
        userInteraction:false
    });

    // Create the line plot
    linePlot = demoChart.createLinePlot({
        name:'line plot',
        lineColor:'gray',
        lineWidth:6.0,
        dataClickMargin:12.0,
        symbolHighlight:{
            type:Charts.SYMBOL_ELLIPSE,
            width:14.0,
            height:14.0,
            lineColor:'#808080',
            lineWidth:3.0,
            fillColor:'#c0c0c0'
        },
        data:[ -40.0, -27.5, -17.0,
            14.0, 8.0, 2.4,
            -7.0, -9.0, -19.0,
            -8.5, 14.0, 3.0,
            6.0
        ]
    });

    // Create the vertical line plot -- we'll use this to draw a vertical
    // bar when a data point is clicked
    vertLine = demoChart.createLinePlot({
        name:'vertical line plot',
        lineColor:'#c0c0c0',
        lineWidth:10.0,
        lineOpacity:0.2
    });

    function handleTouchEvent(e) {
        // Get the index from the current position
        var index = linePlot.indexFromViewPoint(e);

        // Highlight the selected point with the symbolHighlight
        linePlot.highlightIndex = index;

        // Draw the vertical bar (it's really just a scatter plot with 2 points)
        vertLine.data = [
            { x:index, y:-100000 },
            { x:index, y:100000 }
        ];

        // We want the popup to align with the selected symbol, so we
        // have to retrieve information about the data point at the
        // index which will return the position and value
        var info = linePlot.dataPointFromIndex(index);

        popup.left = demoChart.left + info.x - popup.width / 2;
        popup.top = demoChart.top + popup.height + 10;
        popupLabel.text = info.value.toFixed(1);
    };

    function handleTouchEndEvent(e) {
        popup.left = -500;
    }

    // Use the 'touch...' events to provide dynamic interaction as
    // the user drags the touch points around in the chart
    demoChart.addEventListener('touchstart', handleTouchEvent);
    demoChart.addEventListener('touchmove', handleTouchEvent);
    demoChart.addEventListener('touchend', handleTouchEndEvent);

    // Use the 'dataclicked' event to be notified if the user actually clicked
    // on the datapoint.
    // linePlot.addEventListener('dataClicked', handleTouchEvent);

    // Create a popup window that will display the value for the point when clicked
    popup = Ti.UI.createView({
        borderRadius:10,
        borderColor:'#c0c0ff',
        borderWidth:2,
        backgroundColor:'lightgray',
        left:-500,
        top:-500,
        width:50,
        height:30,
        zIndex:100,
        opacity:0.4
    });
    popupLabel = Ti.UI.createLabel({
        text:'',
        textAlign:'center',
        color:'black',
        width:Ti.UI.SIZE || 'auto',
        height:Ti.UI.SIZE || 'auto'
    });
    popup.add(popupLabel);

    // Add the charts to the window
    win.add(demoChart);
    win.add(popup);
}
