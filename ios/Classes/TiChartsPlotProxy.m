/**
 * Ti.Charts Module
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiChartsPlotProxy.h"
#import "TiChartsChartProxy.h"
#import "TiChartsChart.h"
#import "TiUtils.h"
#import <libkern/OSAtomic.h>

// Define deferred processing bits
#define NEEDS_UPDATE_DATA	1
#define NEEDS_RECONFIGURE   2

@implementation TiChartsPlotProxy
@synthesize dataKey, propertyChangedProperties, plot, chartProxy;

-(CPTPlot*)allocPlot
{
	// Override this method
	return nil;
}

-(void)configurePlot
{
	// Override this method
}

-(void)_initWithProperties:(NSDictionary*)properties
{
	[super _initWithProperties:properties];
	// Set up for property change notifications
	self.modelDelegate = self;
}	

-(void)dealloc
{
	RELEASE_TO_NIL(plot);
	RELEASE_TO_NIL(data);
	RELEASE_TO_NIL(dataKey);
	RELEASE_TO_NIL(propertyChangedProperties);
	[super dealloc];
}

-(void)removeFromChart:(CPTXYGraph*)fromGraph
{
	if (plot != nil) {
		[fromGraph removePlot:plot];
	}
}

-(void)renderInChart:(CPTXYGraph*)toGraph
{
	RELEASE_TO_NIL(plot);

	plot = [self allocPlot];
	if (plot == nil) {
		return;
	}
	
	[self configurePlot];
	
	// Make sure to set the frame to match the graph
	plot.frame = [toGraph frame];

	// Set up data source and delegate for plotting
    plot.dataSource = self;
	plot.delegate = self;
	
	// Add the plot to the plot space
    [toGraph addPlot:plot toPlotSpace:toGraph.defaultPlotSpace];	
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
	return [data count];
}

-(NSNumber*)numberForPlot:(NSUInteger)index
{
	if (index < [data count]) {	
		return [data objectAtIndex:index];
	}
	
	return nil;
}

-(NSNumber*)numberForPlot:(NSUInteger)index forCoordinate:(CPTCoordinate)coordinate
{
    if (index < [data count]) {
        id val = [data objectAtIndex:index];
        if ([val isKindOfClass:[NSDictionary class]]) {
            return [val valueForKey:(coordinate == CPTScatterPlotFieldX ? @"x" : @"y")];
        } else if (coordinate == CPTScatterPlotFieldY) {
            return val;
        } else {
            return [NSDecimalNumber numberWithUnsignedInteger:index];
        }
    }
    
    return nil;
}

-(NSArray*)data
{
	return (data);
}

-(void)refreshData
{
	// Override this method if you need to perform any
	// action after the data has been updated
	
	// MUST RUN ON UI THREAD SO THAT UPDATE IS IMMEDIATE
	ENSURE_UI_THREAD_0_ARGS
	
	OSAtomicTestAndClearBarrier(NEEDS_UPDATE_DATA, &dirtyDataFlags);

	// Tell the plot that it needs to reload the data. This causes it
	// to clear its cache of data and requery the values from the delegate.
	[plot reloadData];

	[chartProxy refreshPlotSpaces];
}

-(void)triggerDataUpdate
{	
	if (OSAtomicTestAndSetBarrier(NEEDS_UPDATE_DATA, &dirtyDataFlags)) {
		return;
	}
	
	[self performSelectorOnMainThread:@selector(refreshData) withObject:nil waitUntilDone:NO];
}


-(void)reconfigurePlot
{
	// MUST RUN ON UI THREAD SO THAT UPDATE IS IMMEDIATE
	ENSURE_UI_THREAD_0_ARGS
	
	OSAtomicTestAndClearBarrier(NEEDS_RECONFIGURE, &dirtyDataFlags);
	
	[self configurePlot];
}

-(void)triggerReconfigure
{
	if (OSAtomicTestAndSetBarrier(NEEDS_RECONFIGURE, &dirtyDataFlags)) {
		return;
	}
	
	[self performSelectorOnMainThread:@selector(reconfigurePlot) withObject:nil waitUntilDone:NO];
}

-(void)addData:(NSArray*)values startingAtIndex:(NSUInteger)index
{
	if (values != nil) {
		Class dictionaryClass = [NSDictionary class];
		
		if (data == nil) {
			data = [[NSMutableArray arrayWithCapacity:[values count]] retain];
		}
		
		for (id val in values) {
			if ([val isKindOfClass:dictionaryClass]) {
                BOOL exists;
                id x = [NSNumber numberWithFloat:(float)[TiUtils floatValue:@"x" properties:val def:0.0 exists:&exists]];
                if (exists) {
                    id y = [NSNumber numberWithFloat:(float)[TiUtils floatValue:@"y" properties:val def:0.0]];
                    [data insertObject:[NSDictionary dictionaryWithObjectsAndKeys:x, @"x", y, @"y", nil] atIndex:index];
                } else if (dataKey != nil) {
                    [data insertObject:[NSNumber numberWithFloat:(float)[TiUtils floatValue:dataKey properties:val def:0.0]] atIndex:index];
                } else {
                    [self throwException:@"Set dataKey property when setting data with dictionary values" subreason:nil location:CODELOCATION];
                }
			} else {
				[data insertObject:[NSNumber numberWithFloat:(float)[TiUtils floatValue:val def:0.0]] atIndex:index];
			}
			index++;
		}
	}	
}

-(void)setData:(id)values
{
	// Release any existing data values
	RELEASE_TO_NIL(data);
	
	[self addData:values startingAtIndex:0];
	
	// Signal that the data needs to be reloaded
	[self triggerDataUpdate];
}

-(void)appendData:(id)values
{
	ENSURE_SINGLE_ARG(values,NSArray);
	
	[self addData:values startingAtIndex:[data count]];
	
	// Signal that the data needs to be reloaded
	[self triggerDataUpdate];
}

-(void)insertDataBefore:(id)args
{
	enum InsertDataArgs {
		kInsertDataArgIndex  = 0,
		kInsertDataArgValues  = 1,
		kInsertDataArgCount
	};	
	
	// Validate arguments
	ENSURE_ARG_COUNT(args, kInsertDataArgCount);
	
	int index = [TiUtils intValue:[args objectAtIndex:kInsertDataArgIndex]];
	NSArray *values = [args objectAtIndex:kInsertDataArgValues];
	
	[self addData:values startingAtIndex:index];
	
	// Signal that the data needs to be reloaded
	[self triggerDataUpdate];
}

-(void)insertDataAfter:(id)args
{
	enum InsertDataArgs {
		kInsertDataArgIndex  = 0,
		kInsertDataArgValues  = 1,
		kInsertDataArgCount
	};	
	
	// Validate arguments
	ENSURE_ARG_COUNT(args, kInsertDataArgCount);
	
	int index = [TiUtils intValue:[args objectAtIndex:kInsertDataArgIndex]];
	NSArray *values = [args objectAtIndex:kInsertDataArgValues];
	
	[self addData:values startingAtIndex:index+1];

	// Signal that the data needs to be reloaded
	[self triggerDataUpdate];
}

-(void)deleteData:(id)args
{
	enum DeleteDataArgs {
		kDeleteDataArgIndex  = 0,
		kDeletaDataArgCount  = 1,
		kDeleteDataArgCount
	};	
	
	// Validate arguments
	ENSURE_ARG_COUNT(args, kDeleteDataArgCount);
	
	int index = [TiUtils intValue:[args objectAtIndex:kDeleteDataArgIndex]];
	int cnt = [TiUtils intValue:[args objectAtIndex:kDeleteDataArgCount]];
	
	[data removeObjectsInRange:NSMakeRange(index, cnt)];
	
	// Signal that the data needs to be reloaded
	[self triggerDataUpdate];
}

-(void)notifyOfDataClickedEvent:(NSUInteger)index
{
	if ([self _hasListeners:@"dataClicked"]) {
		NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithUnsignedInteger:index],@"index",
                               [self numberForPlot:index],@"value",
                               plot.identifier,@"name",                                
                               nil
                               ];        
		[self fireEvent:@"dataClicked" withObject:event];
	}
}

-(CGPoint)viewPointFromGraphPoint:(CGPoint)point
{
    CGPoint viewPoint = [(TiChartsChart*)self.chartProxy.view viewPointFromGraphPoint:point];
    return viewPoint;
}

-(void)notifyOfDataClickedEvent:(NSUInteger)index atPlotPoint:(CGPoint)plotPoint
{
    // The point passed in is relative to the plot area.
    // - First convert from the plot area to the graph area.
    // - Then convert from the graph area to the chart view
    CGPoint graphPoint = [self.plot.plotArea convertPoint:plotPoint toLayer:self.plot.graph];
    CGPoint viewPoint = [self viewPointFromGraphPoint:graphPoint];

	if ([self _hasListeners:@"dataClicked"]) {
		NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:
								  [NSNumber numberWithUnsignedInteger:index],@"index",
							      [self numberForPlot:index],@"value",
							      self.plot.identifier,@"name",
                                  NUMINT(viewPoint.x),@"x",
                                  NUMINT(viewPoint.y),@"y",                                 
								  nil
							  ];        
		[self fireEvent:@"dataClicked" withObject:event];
	}

	// Since dataClicked events override the touchstart event we should generate one
	[(TiChartsChart*)self.chartProxy.view notifyOfTouchEvent:@"touchstart" atPoint:viewPoint];
}

-(void)propertyChanged:(NSString*)key oldValue:(id)oldValue newValue:(id)newValue proxy:(TiProxy*)proxy
{
	if ([propertyChangedProperties member:key]!=nil) {
		[self triggerReconfigure];
	}
}

@end
