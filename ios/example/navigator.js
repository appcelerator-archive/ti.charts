// Declare the list of charts and their associated commonJS module names
var demos = [
    {    mod:null, title:'Line Chart', section:'Basic Charts', name:'basicLine' },
    {    mod:null, title:'Bar Chart', section:'Basic Charts', name:'basicBar'    },
    {    mod:null, title:'Pie Chart', section:'Basic Charts', name:'basicPie'    },
    {   mod:null, title:'Scatter Chart', section:'Basic Charts', name:'basicScatter' },
    {    mod:null, title:'Line and Bar Chart', section:'Combined Charts', name:'combinedLineBar'    },
    {   mod:null, title:'Custom Line Chart', section:'Interactive', name:'customLine' }
];

var Charts = null;
var tab = null;
var currentDemo = null;

function createDemoTableView() {
    var sections = [];
    var cnt = demos.length;

    for (var index = 0; index < cnt; index++) {
        if ((index == 0) || (demos[index].section != demos[index - 1].section)) {
            sections.push(Ti.UI.createTableViewSection({
                headerTitle:demos[index].section
            }));
        }

        row = Ti.UI.createTableViewRow({
            title:demos[index].title,
            hasChild:true
        });

        sections[sections.length - 1].add(row);
    }

    var tableView = Ti.UI.createTableView({
        style:Titanium.UI.iPhone.TableViewStyle.GROUPED,
        data:sections
    });

    tableView.addEventListener('click', function (e) {
        exports.openDemo(demos[e.index]);
    });

    return tableView;
}

exports.start = function (chartsModule) {
    // Save the module object -- we'll need it later
    Charts = chartsModule;

    var win = Ti.UI.createWindow({
        title:'Charts Demo',
        backgroundColor:'white',
        tabBarHidden:true,
        orientationModes:[
            Ti.UI.PORTRAIT,
            Ti.UI.UPSIDE_PORTRAIT,
            Ti.UI.LANDSCAPE_LEFT,
            Ti.UI.LANDSCAPE_RIGHT
        ]
    });

    win.add(createDemoTableView());

    if (Ti.Platform.name == 'android') {
        win.exitOnClose = true;
    } else {
        var tabGroup = Ti.UI.createTabGroup();
        win.tabBarHidden = true;
        tab = Ti.UI.createTab({
            title:win.title,
            window:win
        });
        tabGroup.addTab(tab);
        tabGroup.open();
    }

    // Open the application window
    win.open();
}

exports.openDemo = function (demo) {
    var win = Ti.UI.createWindow({
        title:demo.title,
        backgroundColor:'white',
        orientationModes:[
            Ti.UI.PORTRAIT,
            Ti.UI.UPSIDE_PORTRAIT,
            Ti.UI.LANDSCAPE_LEFT,
            Ti.UI.LANDSCAPE_RIGHT
        ]
    });

    // Load the commonJS module for the first time
    currentDemo = (demo.mod == null) ? require('demos/' + demo.name) : demo.mod;

    // Perform page initialization
    currentDemo.initialize(Charts);

    // Create the controls for the window
    currentDemo.create(win);

    // Handle page cleanup
    win.addEventListener('close', function () {
        currentDemo.cleanup();
        currentDemo = null;
    });

    if (Ti.Platform.name == 'android') {
        win.open({ modal:true, animated:true });
    } else {
        tab.open(win, { animated:true });
    }
}
