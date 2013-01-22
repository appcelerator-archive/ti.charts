// Private implementation details for commonJS module

var Charts = null;
var demoChart = null;
var scatterPlot = null;

// Public implementation details for commonJS module

exports.initialize = function (chartsModule) {
    // Save the module object -- we'll need it later
    Charts = chartsModule;
}

exports.cleanup = function () {
    scatterPlot = null;
    demoChart = null;
    Charts = null;
}

exports.create = function (win) {
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

        // Configure the title for the chart
        title:{
            text:'Scatter Chart',
            color:'#900',
            font:{ fontFamily:'Times New Roman', fontSize:24, fontWeight:'bold', fontStyle:'italic' },
            location:Charts.LOCATION_TOP,
            offset:{ x:0.0, y:10.0 }
        },

        // Configure the external padding -- the area between the view edge and the plot area frame
        padding:{
            top:26,
            left:4,
            right:4,
            bottom:4
        },

        // Configure the plot area -- the area where the chart is drawn
        plotArea:{
            borderRadius:5.0,
            borderColor:'#48C',
            borderWidth:2.0,
            // Configure the inner padding -- the area between the plot area frame and the actual plot area
            padding:{
                top:0.0,
                left:48.0,
                right:5.0,
                bottom:35.0
            },

            backgroundGradient:{
                startColor:'#00F',
                endColor:'#004',
                angle:-45.0
            }
        },

        // Configure the xAxis
        xAxis:{
            // origin defines where it intercepts the orthogonal axis (the y-axis)
            origin:0,
            lineColor:'yellow',
            lineWidth:1.0,
            title:{
                text:'X Axis',
                offset:18.0,
                color:'#0f0',
                font:{ fontFamily:'Helvetica', fontSize:14 }
            },
            majorTicks:{
                color:'red',
                width:1.0,
                length:5.0,
                interval:1.0,
                gridLines:{
                    width:1.0,
                    color:'blue',
                    opacity:0.5,
                    range:{ location:0.0, length:100.0 }
                },
                labels:{
                    offset:0.0,
                    angle:0.0,
                    color:'white',
                    font:{ fontFamily:'Helvetica', fontSize:12 },
                    textAlign:Charts.ALIGNMENT_CENTER
                }
            },
            minorTicks:{
                color:'purple',
                width:1.0,
                length:3.0,
                count:5,
                gridLines:{
                    width:1.0,
                    color:'white',
                    opacity:0.1
                }
            },
            visibleRange:{ location:0.0, length:100.0 }
        },
        // Configure the yAxis
        yAxis:{
            // origin defines where it intercepts the orthogonal axis (the x-axis)
            origin:0,
            lineColor:'yellow',
            lineWidth:1.0,
            title:{
                text:'Y Axis',
                offset:24.0,
                color:'#0f0',
                font:{ fontFamily:'Helvetica', fontSize:14 }
            },
            majorTicks:{
                color:'white',
                width:1.0,
                length:5.0,
                interval:1.0,
                gridLines:{
                    width:1.0,
                    color:'white',
                    opacity:0.2,
                    range:{ location:0.0, length:100.0 }
                },
                labels:{
                    offset:0.0,
                    angle:45.0,
                    color:'white',
                    font:{ fontFamily:'Helvetica', fontSize:12 },
                    textAlign:Charts.ALIGNMENT_MIDDLE
                }
            },
            visibleRange:{ location:0.0, length:100.0 }
        },

        plotSpace:{
            scaleToFit:false,
            xRange:{ location:0, length:8 },
            yRange:{ location:0, length:10 }
        },
        // Enable user interaction -- defaults to true
        userInteraction:true
    });

    // Create the scatter plot
    scatterPlot = demoChart.createLinePlot({
        name:'scatter plot',
        lineColor:'green',
        lineWidth:2.0,
        dataClickMargin:12.0,
		fillGradient:{
            startColor:'#F00',
            endColor:'#0F0',
            angle:90.0
        },
        fillOpacity:0.5,
        // base for area fill: optional, but required if fill specified
        fillBase:0.0,

        data:[
            { x:0, y:1.5 },
            { x:2, y:2.5 },
            { x:5, y:5.5 },
            { x:6, y:3.7 },
            { x:7, y:0.4 }
        ],
        scatterAlgorithm:Charts.SCATTER_STEPPED
    });
    scatterPlot.addEventListener('dataClicked', function (e) {
        Ti.API.info('line: ' + e.name + ' clicked: index: ' + e.index + ' value: ' + e.value);
        Ti.API.info('x position: ' + e.x + ' y position: ' + e.y);
    });

    // Add the charts to the window
    win.add(demoChart);
}
