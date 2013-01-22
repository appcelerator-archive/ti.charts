/**
 * Ti.Charts Module
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiChartsBarPlotProxy.h"
#import "TiChartsChart.h"
#import "TiChartsParsers.h"
#import "TiUtils.h"

@implementation TiChartsBarPlotProxy

-(CPTPlot*)allocPlot
{
	return [[CPTBarPlot alloc] init];
}

-(void)configurePlot
{
	[super configurePlot];
	
	CPTBarPlot* plot = (CPTBarPlot*)[self plot];
	
	// NOTE: We pass in the current plot values as the default so that any existing settings
	// from the theme are retained unless overridden.
	
	plot.lineStyle = [TiChartsParsers parseLineColor:[self valueForUndefinedKey:@"lineColor"]
										   withWidth:[self valueForUndefinedKey:@"lineWidth"]
										  andOpacity:[self valueForUndefinedKey:@"lineOpacity"]
												 def:plot.lineStyle];
	
	plot.fill = [TiChartsParsers parseFillColor:[self valueForUndefinedKey:@"fillColor"]
								   withGradient:[self valueForUndefinedKey:@"fillGradient"]
									 andOpacity:[self valueForUndefinedKey:@"fillOpacity"]
											def:plot.fill];
	
	plot.barsAreHorizontal = [TiUtils boolValue:[self valueForUndefinedKey:@"barDirection"] def:plot.barsAreHorizontal];
	plot.barWidth = [TiChartsParsers decimalFromFloat:[self valueForUndefinedKey:@"barWidth"] def:plot.barWidth];
	plot.barOffset = [TiChartsParsers decimalFromFloat:[self valueForUndefinedKey:@"barOffset"] def:plot.barOffset];
	plot.barCornerRadius = [TiUtils floatValue:[self valueForUndefinedKey:@"barCornerRadius"] def:plot.cornerRadius];

	// These fields allow for changing the base of the bar -- could be used for stacked bar charts
	// TODO
	//plot.baseValue = NSDecimalFromFloat(0.0f);
	//plot.barBasesVary = NO;
}

-(id)init
{
	if (self = [super init]) {
		// these properties should trigger a redisplay
		static NSSet * plotProperties = nil;
		if (plotProperties==nil)
		{
			plotProperties = [[NSSet alloc] initWithObjects:
							  @"lineColor", @"lineWidth", @"lineOpacity",
							  @"fillColor", @"fillGradient", @"fillOpacity",
							  @"barDirection", @"barWidth", @"barOffset", @"barCornerRadius",
							  @"labels",
							  nil];
		}
		
		self.propertyChangedProperties = plotProperties;
	}
	
	return self;
}

-(void)dealloc
{
	[super dealloc];
}

-(void)barPlot:(CPTBarPlot*)plot barWasSelectedAtRecordIndex:(NSUInteger)index
{
    double pts[2];
    pts[CPTCoordinateX] = [[self numberForPlot:index forCoordinate:CPTCoordinateX] doubleValue];
    pts[CPTCoordinateY] = [[self numberForPlot:index forCoordinate:CPTCoordinateY] doubleValue];
    CGPoint plotPoint = [self.plot.plotSpace plotAreaViewPointForDoublePrecisionPlotPoint:pts];
    
	[self notifyOfDataClickedEvent:index atPlotPoint:plotPoint];
}

-(NSNumber*)numberForPlot:(CPTPlot*)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
	NSNumber *num = nil;

	if (fieldEnum == CPTBarPlotFieldBarLocation) {
		// This field identifies the column (for horizontal bar charts) for the value that
		// is being indexed by 'index'. By returning the actual data value you will generate
		// a frequency chart (or something like that). For now, we are just generating a normal
		// bar chart, so return the same index that is passed in.
		num = [self numberForPlot:index forCoordinate:CPTCoordinateX];
	} else if (fieldEnum == CPTBarPlotFieldBarTip) {
		num = [self numberForPlot:index forCoordinate:CPTCoordinateY];
	} else if (fieldEnum == CPTBarPlotFieldBarBase) {
		// TODO -- This is where we could do a stacked bar ???
		num = [NSNumber numberWithFloat:0.0];
	}
	
	return num;
}

@end
