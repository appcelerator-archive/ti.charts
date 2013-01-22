/**
 * Ti.Charts Module
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiChartsChart.h"
#import "TichartsParsers.h"
#import "TiUtils.h"
#import "TiBase.h"
#import "TiChartsChartProxy.h"
#import "TiChartsPlotProxy.h"

@implementation TiChartsChart

@synthesize hostingView;

-(void)killGraph
{
	if (hostingView) {
		if (symbolTextAnnotation) {
			[graph.plotAreaFrame.plotArea removeAnnotation:symbolTextAnnotation];
			RELEASE_TO_NIL(symbolTextAnnotation);
		}
		
		[hostingView removeFromSuperview];
		hostingView.hostedGraph = nil;
		RELEASE_TO_NIL(hostingView);
	}
	RELEASE_TO_NIL(graph);
}

-(void)dealloc
{
	[self killGraph];
	[super dealloc];
}

-(CPTGraphHostingView*)hostingView 
{
	if (hostingView == nil) {
		hostingView = [[CPTGraphHostingView alloc] initWithFrame:[self bounds]];
		[self addSubview:hostingView];
	}
	
	return hostingView;		
}

-(void)frameSizeChanged:(CGRect)frame bounds:(CGRect)bounds
{
	[super frameSizeChanged:frame bounds:bounds];
	if (hostingView != nil) {
		[TiUtils setView:hostingView positionRect:bounds];
	}
	
	[self renderInView];
}

-(void)configureTitle:(NSDictionary*)properties
{
	// NOTE: For some reason, directly setting the text style properties
	// using graph.titleTextStyle.xxxxxx does not work properly. It works
	// best by creating a new textStyle object, setting the properties of
	// this object, and then assigning it to the graph.titleTextStyle property
	
	// Configure the font name and size and color
	graph.titleTextStyle  = [TiChartsParsers parseTextStyle:properties def:graph.titleTextStyle];
	
	// The frame anchor defines the location of the title
	graph.titlePlotAreaFrameAnchor = [TiUtils intValue:@"location" properties:properties def:CPTRectAnchorTop];
	
	// The displacement defines the offset from the specified edge
	NSDictionary* offset = [properties objectForKey:@"offset"];
	if (offset) {
		graph.titleDisplacement = CGPointMake(
		  [TiUtils floatValue:@"x" properties:offset def:0.0],
		  [TiUtils floatValue:@"y" properties:offset def:0.0]);
	} else if (graph.title == nil) {
		graph.titleDisplacement = CGPointZero;
	} else {
		graph.titleDisplacement = CGPointMake(0.0f, graph.titleTextStyle.fontSize);
	}
	
	// Set the title after setting the font. For some reason, core-plot will crash on
	// the iPad simulator if the title is set before the font.
	graph.title = [TiUtils stringValue:@"text" properties:properties def:nil];
}
	
-(void)configurePadding:(NSDictionary*)properties
{
	CGRect bounds = [self bounds];
	float boundsPadding = round(bounds.size.width / 20.0f);
	
	graph.paddingLeft = [TiUtils floatValue:@"left" properties:properties def:boundsPadding];
	graph.paddingTop = [TiUtils floatValue:@"top" properties:properties def:
						(graph.titleDisplacement.y > 0.0) ? graph.titleDisplacement.y * 2 : boundsPadding];
	graph.paddingRight = [TiUtils floatValue:@"right" properties:properties def:boundsPadding];
	graph.paddingBottom = [TiUtils floatValue:@"bottom" properties:properties def:boundsPadding];
}

-(void)configureTheme:(NSString*)themeName
{
	if (themeName != nil) {
		CPTTheme *theme = [CPTTheme themeNamed:themeName];
		if (theme != nil) {
			[graph applyTheme:theme];
			return;
		}
	}
	
	// Apply the default theme -- this also sets up default values for
	// a number of parameters of the graph.
	[graph applyTheme:[CPTTheme themeNamed:kCPTDarkGradientTheme]];
}

-(void)configurePlotArea:(NSDictionary*)properties
{
    // Border
	graph.plotAreaFrame.borderLineStyle = [TiChartsParsers parseLineColor:[properties objectForKey:@"borderColor"]
																withWidth:[properties objectForKey:@"borderWidth"]
															   andOpacity:[properties objectForKey:@"borderOpacity"]
																	  def:graph.plotAreaFrame.borderLineStyle];
    graph.plotAreaFrame.cornerRadius = [TiUtils floatValue:@"borderRadius" properties:properties def:graph.plotAreaFrame.cornerRadius];
	
	// Inner padding
	NSDictionary *padding = [properties objectForKey:@"padding"];
	if (padding != nil) {
		graph.plotAreaFrame.paddingLeft = [TiUtils floatValue:@"left" properties:padding def:graph.plotAreaFrame.paddingLeft];
		graph.plotAreaFrame.paddingTop = [TiUtils floatValue:@"top" properties:padding def:graph.plotAreaFrame.paddingTop];
		graph.plotAreaFrame.paddingRight = [TiUtils floatValue:@"right" properties:padding def:graph.plotAreaFrame.paddingRight];
		graph.plotAreaFrame.paddingBottom = [TiUtils floatValue:@"bottom" properties:padding def:graph.plotAreaFrame.paddingBottom];
	}
	
	// Plot area frame fill
	graph.plotAreaFrame.fill = [TiChartsParsers parseFillColor:[properties objectForKey:@"backgroundColor"]
												  withGradient:[properties objectForKey:@"backgroundGradient"]
													andOpacity:[properties objectForKey:@"backgroundOpacity"]
														   def:graph.plotAreaFrame.fill];
    
    // Plot area fill
    graph.plotAreaFrame.plotArea.fill = [TiChartsParsers parseFillColor:[properties objectForKey:@"fillColor"]
                                                           withGradient:[properties objectForKey:@"fillGradient"]
                                                             andOpacity:[properties objectForKey:@"fillOpacity"]
                                                                    def:graph.plotAreaFrame.fill];
}

-(void)configureAxesX:(id)xProperties andY:(id)yProperties
{
	NSMutableArray *axes = [[[NSMutableArray alloc] init] autorelease];
	CPTXYAxis* axis;
	if (xProperties) {
		axis = [TiChartsParsers parseAxis:CPTCoordinateX properties:xProperties usingPlotSpace:graph.defaultPlotSpace def:nil];
		if (axis) {
			[axes addObject:axis];
		}
	}
	if (yProperties) {
		axis = [TiChartsParsers parseAxis:CPTCoordinateY properties:yProperties usingPlotSpace:graph.defaultPlotSpace def:nil];
		if (axis) {
			[axes addObject:axis];
		}
	}
	
	graph.axisSet.axes = [axes count] > 0 ? axes : nil;
	
	//NOTE: To support additional axes being added at a later time, copy the current axes set and add to the new one
}

-(void)configureUserInteraction
{
	BOOL userInteraction = [TiUtils boolValue:[self.proxy valueForKey:@"userInteraction"] def:YES];
	for (CPTPlotSpace* plotSpace in graph.allPlotSpaces) {
		plotSpace.allowsUserInteraction = userInteraction;
		// Set the plotspace delegate so we get the shouldHandleTouch... callbacks
		plotSpace.delegate = self;
	}
	// Setting to YES reduces GPU memory usage, but can slow drawing/scrolling
	[[self hostingView] setAllowPinchScaling:userInteraction];
}

-(void)removeAllPlots
{
	if (graph != nil) {
		for (id plot in plot) {
			[plot removeFromChart:graph];
		}
	}
}

-(void)addPlot:(TiChartsPlotProxy*)plot
{
	if (graph != nil) {
		[plot renderInChart:graph];
	}
}

-(void)removePlot:(TiChartsPlotProxy *)plot
{
	if (graph != nil) {
		[plot removeFromChart:graph];
	}
}

-(void)renderInView
{
	ENSURE_UI_THREAD_0_ARGS
	
	[self killGraph];
	
    // Create graph object
    graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    [self hostingView].hostedGraph = graph;
	
	// Configure theme first -- it may set default options for the
	// entire graph, which would override any other settings if we don't
	// process it first
	[self configureTheme:[self.proxy valueForKey:@"theme"]];
	
    // Background fill
    graph.fill = [TiChartsParsers parseFillColor:[self.proxy valueForKey:@"fillColor"]
                                    withGradient:[self.proxy valueForKey:@"fillGradient"]
                                      andOpacity:[self.proxy valueForKey:@"fillOpacity"]
                                             def:graph.fill];

	// Configure the graph title area
	[self configureTitle:[self.proxy valueForKey:@"title"]];
	
	// Configure the padding on the outside of the graph
	[self configurePadding:[self.proxy valueForKey:@"padding"]];
	
	// Configure the frame and inside padding for the graph
	[self configurePlotArea:[self.proxy valueForKey:@"plotArea"]];
	
	[self configureAxesX:[self.proxy valueForKey:@"xAxis"] andY:[self.proxy valueForKey:@"yAxis"]];
	
	id plots = [(TiChartsChartProxy*)self.proxy plots];
	for (id plot in plots) {
		[plot renderInChart:graph];
	}
		
	[self configureUserInteraction];
	
	[self refreshPlotSpaces];
}

-(void)refreshPlotSpaces
{
	// MUST RUN ON UI THREAD SO THAT UPDATE IS IMMEDIATE
	ENSURE_UI_THREAD_0_ARGS

	//BUGBUG: Set this as properties
	// Add these to property watch list

	BOOL scaleToFit;
	float expandBy;
    CPTXYPlotSpace* plotSpace;
	
	id options = [self.proxy valueForKey:@"plotSpace"];
	if (options) {
		scaleToFit = [TiUtils boolValue:@"scaleToFit" properties:options def:YES];
		expandBy = [TiUtils floatValue:@"expandRangeByFactor" properties:options def:1.0];
        
        plotSpace = (CPTXYPlotSpace*)graph.defaultPlotSpace;
        plotSpace.xRange = [TiChartsParsers parsePlotRange:[options valueForKey:@"xRange"] def:plotSpace.xRange];
        plotSpace.yRange = [TiChartsParsers parsePlotRange:[options valueForKey:@"yRange"] def:plotSpace.yRange];
	} else {
        // default
		scaleToFit = YES;
		expandBy = 1.25;
	}

	if (scaleToFit == YES) {
		[graph.defaultPlotSpace scaleToFitPlots:[graph allPlots]];
		CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace*)graph.defaultPlotSpace;
		CPTPlotRange *xRange = plotSpace.xRange;
		CPTPlotRange *yRange = plotSpace.yRange;

		if ([xRange respondsToSelector:@selector(expandRangeByFactor:)]) {
            [xRange expandRangeByFactor:CPTDecimalFromDouble(expandBy)];
            [yRange expandRangeByFactor:CPTDecimalFromDouble(expandBy)];
            plotSpace.yRange = yRange;
            plotSpace.xRange = xRange;
		}
	}
}

-(void)refresh:(id)args
{
	[[self hostingView] setNeedsDisplay];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	// On rotation, re-render the view
	[self renderInView];
}

#pragma mark CPTPlotSpaceDelegate methods

-(CGPoint)viewPointFromGraphPoint:(CGPoint)point
{
    // Convert the point from the graph's coordinate system to the view. Note that the
    // graph's coordinate system has (0,0) in the lower left hand corner and the
    // view's coordinate system has (0,0) in the upper right hand corner
    CGPoint viewPoint = [self.hostingView.hostedGraph convertPoint:point toLayer:self.hostingView.layer];
    return viewPoint;
}

-(void)notifyOfTouchEvent:(NSString*)type atPoint:(CGPoint)viewPoint
{
	if ([self.proxy _hasListeners:type]) {
        NSDictionary *evt = [NSDictionary dictionaryWithObjectsAndKeys:
            NUMFLOAT(viewPoint.x), @"x",
            NUMFLOAT(viewPoint.y), @"y",
            nil
        ];
        [self.proxy fireEvent:type withObject:evt];
    }
}

-(BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceDownEvent:(id)event atPoint:(CGPoint)point
{
    CGPoint viewPoint = [self viewPointFromGraphPoint:point];
    [self notifyOfTouchEvent:@"touchstart" atPoint:viewPoint];

	return YES;
}

-(BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceDraggedEvent:(id)event atPoint:(CGPoint)point
{
    CGPoint viewPoint = [self viewPointFromGraphPoint:point];
    [self notifyOfTouchEvent:@"touchmove" atPoint:viewPoint];

	return YES;
}

-(BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceCancelledEvent:(id)event
{
    [self.proxy fireEvent:@"touchcancel"];

	return YES;
}

-(BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceUpEvent:(id)event atPoint:(CGPoint)point
{
    CGPoint viewPoint = [self viewPointFromGraphPoint:point];
    [self notifyOfTouchEvent:@"touchend" atPoint:viewPoint];

	return YES;
}

@end
