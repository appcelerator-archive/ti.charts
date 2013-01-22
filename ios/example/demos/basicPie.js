// Private implementation details for commonJS module

var Charts = null;
var demoChart = null;
var piePlot = null;

// Public implementation details for commonJS module

exports.initialize = function (chartsModule) {
    // Save the module object -- we'll need it later
    Charts = chartsModule;
}

exports.cleanup = function () {
    piePlot = null;
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
            text:'Pie Chart',
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
                left:0.0,
                right:0.0,
                bottom:0.0
            },

            backgroundGradient:{
                startColor:'#00F',
                endColor:'#004',
                angle:-45.0
            }
        },

        // Disable user interaction -- defaults to true
        userInteraction:false
    });

    // Create the pie plot
    piePlot = demoChart.createPiePlot(
        {
            name:'pie chart',
            lineColor:'yellow',
            lineWidth:1.0,
            lineOpacity:0.4,
            startAngle:0.0,
            direction:Charts.DIRECTION_COUNTERCLOCKWISE,
            radius:100.0,
            explodeOffset:10.0,
            labels:{
                offset:8.0,
                angle:0.0,
                color:'white',
                font:{ fontFamily:'Helvetica', fontSize:12 }
            },
            data:[ 20.0, 30.0, 60.0, 12.0, 9.4, 37.0, 19.0, 2.0 ]
        });

    // Explode the first and third slice
    piePlot.explode = [ 0, 2 ];

    piePlot.addEventListener('dataClicked', function (e) {
        Ti.API.info('line: ' + e.name + ' clicked: index: ' + e.index + ' value: ' + e.value);
    });

    // Add the charts to the window
    win.add(demoChart);
}
