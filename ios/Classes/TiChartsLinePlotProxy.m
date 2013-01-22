/**
 * Ti.Charts Module
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiChartsLinePlotProxy.h"
#import "TiChartsChart.h"
#import "TiChartsParsers.h"
#import "TiUtils.h"

@implementation TiChartsLinePlotProxy

-(CPTPlot*)allocPlot
{
	return [[CPTScatterPlot alloc] init];
}

-(void)configurePlot
{
	[super configurePlot];
	
	CPTScatterPlot* plot = (CPTScatterPlot*)[self plot];
	
	// NOTE: We pass in the current plot values as the default so that any existing settings
	// from the theme are retained unless overridden.
	
	plot.dataLineStyle = [TiChartsParsers parseLineColor:[self valueForUndefinedKey:@"lineColor"]
											   withWidth:[self valueForUndefinedKey:@"lineWidth"]
											  andOpacity:[self valueForUndefinedKey:@"lineOpacity"]
													 def:plot.dataLineStyle];
	
	plot.areaFill = [TiChartsParsers parseFillColor:[self valueForUndefinedKey:@"fillColor"]
									   withGradient:[self valueForUndefinedKey:@"fillGradient"]
										 andOpacity:[self valueForUndefinedKey:@"fillOpacity"]
												def:plot.areaFill];
	plot.areaBaseValue = [TiChartsParsers decimalFromFloat:[self valueForUndefinedKey:@"fillBase"] def:plot.areaBaseValue];
	
	// Plot Symbols
	plot.plotSymbol = [TiChartsParsers parseSymbol:[self valueForUndefinedKey:@"symbol"] def:plot.plotSymbol];
    highlightSymbol = [[TiChartsParsers parseSymbol:[self valueForUndefinedKey:@"symbolHighlight"] def:nil] retain];
    
    // Symbol
    plot.plotSymbolMarginForHitDetection = [TiUtils floatValue:[self valueForUndefinedKey:@"dataClickMargin"] def:plot.plotSymbolMarginForHitDetection];
    
    // Scatter algorithm
    plot.interpolation = [TiUtils intValue:[self valueForUndefinedKey:@"scatterAlgorithm"] def:plot.interpolation];
}

-(id)init
{
	if (self = [super init]) {
        highlightSymbolIndex = NSUIntegerMax;
        
		// these properties should trigger a redisplay
		static NSSet * plotProperties = nil;
		if (plotProperties == nil)
		{
			plotProperties = [[NSSet alloc] initWithObjects:
							  @"lineColor", @"lineWidth", @"lineOpacity",
							  @"fillColor", @"fillGradient", @"fillOpacity", @"fillBase",
							  @"symbol", @"symbolHighlight", @"labels", @"dataClickMargin",
                              @"scatterAlgorithm",
							  nil];
		}
		
		self.propertyChangedProperties = plotProperties;
	}
	
	return self;
}
	
-(void)dealloc
{
    RELEASE_TO_NIL(highlightSymbol)
    [super dealloc];
}

-(void)scatterPlot:(CPTScatterPlot*)plot plotSymbolWasSelectedAtRecordIndex:(NSUInteger)index
{
    double pts[2];
    pts[CPTCoordinateX] = [[self numberForPlot:index forCoordinate:CPTCoordinateX] doubleValue];
    pts[CPTCoordinateY] = [[self numberForPlot:index forCoordinate:CPTCoordinateY] doubleValue];
    CGPoint plotPoint = [self.plot.plotSpace plotAreaViewPointForDoublePrecisionPlotPoint:pts];

	[self notifyOfDataClickedEvent:index atPlotPoint:plotPoint];
}

-(NSNumber*)numberForPlot:(CPTPlot*)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    return [self numberForPlot:index forCoordinate:fieldEnum];
}

-(NSNumber*)highlightIndex
{
    return NUMINT(highlightSymbolIndex);
}

-(void)setHighlightIndex:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    
    // Get new value for the highlighted symbol index. Any negative value will turn off the
    // symbol highlighting
    int val = [TiUtils intValue:value def:-1];
    NSUInteger newValue = (val >= 0) ? (NSUInteger)val : NSUIntegerMax;
    NSUInteger oldValue = highlightSymbolIndex;
    if (newValue != oldValue) {
        highlightSymbolIndex = newValue;
        if (oldValue != NSUIntegerMax) {
            [self.plot reloadDataInIndexRange:NSMakeRange(oldValue, 1)];
        }
        if (newValue != NSUIntegerMax) {
            [self.plot reloadDataInIndexRange:NSMakeRange(newValue, 1)];
        }
    }
    [self.plot setNeedsDisplay];
}

-(CPTPlotSymbol *)symbolForScatterPlot:(CPTScatterPlot *)plot recordIndex:(NSUInteger)index
{
	return (index == highlightSymbolIndex) ? highlightSymbol : plot.plotSymbol;
}

@end
