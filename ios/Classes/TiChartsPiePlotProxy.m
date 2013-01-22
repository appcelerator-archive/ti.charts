/**
 * Ti.Charts Module
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiChartsPiePlotProxy.h"
#import "TiChartsChart.h"	
#import "TiChartsParsers.h"
#import "TiUtils.h"

@implementation TiChartsPiePlotProxy

-(CPTPlot*)allocPlot
{
	return [[CPTPieChart alloc] init];
}

-(void)configurePlot
{
	[super configurePlot];
	
	CPTPieChart *plot = (CPTPieChart*)[self plot];
	
	// NOTE: We pass in the current plot values as the default so that any existing settings
	// from the theme are retained unless overridden.
	
	// identifier is copied, so no need to retain
	plot.identifier = [TiUtils stringValue:[self valueForUndefinedKey:@"name"]];
	plot.startAngle = degreesToRadians([TiUtils floatValue:[self valueForUndefinedKey:@"startAngle"] def:plot.startAngle]);
	plot.sliceDirection = [TiUtils intValue:[self valueForUndefinedKey:@"direction"] def:plot.sliceDirection];
	plot.pieRadius = [TiUtils floatValue:[self valueForUndefinedKey:@"radius"] def:plot.pieRadius];
	
	plot.borderLineStyle = [TiChartsParsers parseLineColor:[self valueForUndefinedKey:@"lineColor"]
												 withWidth:[self valueForUndefinedKey:@"lineWidth"]
												andOpacity:[self valueForUndefinedKey:@"lineOpacity"]
													   def:plot.borderLineStyle];
		
	// Parse the labels
	[TiChartsParsers parseLabelStyle:[self valueForUndefinedKey:@"labels"] forPlot:plot];
}

-(id)init
{
	if (self = [super init]) {
		// these properties should trigger a redisplay
		static NSSet * plotProperties = nil;
		if (plotProperties==nil)
		{
			plotProperties = [[NSSet alloc] initWithObjects:
							  @"startAngle", @"direction",
							  @"lineColor", @"lineWidth", @"lineOpacity",
							  @"radius",@"labels",
							  nil];
		}
		
		self.propertyChangedProperties = plotProperties;
	}
	
	return self;
}

-(void)dealloc
{
	RELEASE_TO_NIL(explodeSet);
	[super dealloc];
}

-(void)pieChart:(CPTPieChart *)plot sliceWasSelectedAtRecordIndex:(NSUInteger)index
{
	[self notifyOfDataClickedEvent:index];
}

-(NSNumber*)numberForPlot:(CPTPlot*)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
	NSNumber *num = nil;
	
	if (fieldEnum == CPTPieChartFieldSliceWidth) {
		num = [self numberForPlot:index];
	} else { 
		num = [NSNumber numberWithInt:index];
	}
	
	return num;
}

//-(CPTFill*)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index
//{
//	return nil;
//}

-(CPTLayer*)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index
{
//	CPTTextLayer *label = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%lu", index]];
//    CPTMutableTextStyle *textStyle = [label.textStyle mutableCopy];
//	textStyle.color = [CPTColor lightGrayColor];
//    label.textStyle = textStyle;
//    [textStyle release];
//	return [label autorelease];
	// return NSNull for no label
	return nil;
}

-(CGFloat)radialOffsetForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index
{
	if ([explodeSet containsObject:[NSNumber numberWithInt:index]]) {
		float amt = (float)[TiUtils floatValue:[self valueForUndefinedKey:@"explodeOffset"] def:0.0];
		return amt;
	}
	
	return 0.0f;
}

-(void)setExplode:(id)args
{
	ENSURE_TYPE_OR_NIL(args,NSArray);
	
	ENSURE_UI_THREAD_1_ARG(args)
	
	[explodeSet release];
	explodeSet = [[NSSet setWithArray:args] retain];
	
	[self replaceValue:args forKey:@"explode" notification:NO];
				  
	// Since the slice will shift we need to relabel to account for
	// radial offset. Also, need to tell it to re-layout and re-display
	[[self plot] setNeedsRelabel];
	[[self plot] setNeedsLayout];
	[[self plot] setNeedsDisplay];
}

@end
