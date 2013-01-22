/**
 * Ti.Charts Module
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiChartsChartProxy.h"
#import "TiChartsChart.h"
#import "TiChartsPlotProxy.h"

#import "TiChartsLinePlotProxy.h"
#import "TiChartsBarPlotProxy.h"
#import "TiChartsPiePlotProxy.h"

#import "TiUtils.h"

@implementation TiChartsChartProxy

-(void)dealloc
{
	// release any resources that have been retained by the module
	RELEASE_TO_NIL(plots);
	
	[super dealloc];
}

-(void)refreshPlotSpaces
{
	if ([self view]) {
		[(TiChartsChart*)[self view] refreshPlotSpaces];
	}
}

-(void)relayout:(id)args
{
    [(TiChartsChart*)[self view] renderInView];
}

-(NSMutableArray*)plots
{
	if (plots == nil) {
		plots = [[NSMutableArray alloc] init];
	}
	
	return plots;
}

-(void)setPlots:(id)args
{
	// If a view is currently attached to this proxy then tell it to remove all plots
	// currently shown in the graph
	if ([self view]) {
		[(TiChartsChart*)[self view] removeAllPlots];
	}
	
	// Clear the current list of plots
	RELEASE_TO_NIL(plots);
	
	// Now set the current list to this new list
	[self add:args];
}

-(void)add:(id)arg
{
	if (!IS_NULL_OR_NIL(arg)) {
		// If we get an array of plot proxy objects we can just iterate through it
		// and add each one individually. This is just a helper for adding a set of
		// plot proxies in one call.
		if ([arg isKindOfClass:[NSArray class]])
		{
			for (id a in arg) {
				[self add:a];
			}
			return;
		}
		
		// Make sure that we are getting a plot proxy object
		if (![arg isKindOfClass:[TiChartsPlotProxy class]]) {
			[self throwException:@"Plot type is invalid" subreason:nil location:CODELOCATION];
		}
		
		// Only add if not already it the list
		TiChartsPlotProxy *plot = (TiChartsPlotProxy*)arg;
		if ([[self plots] indexOfObject:plot] == NSNotFound) {				
			[[self plots] addObject:plot];
			plot.chartProxy = self;
		
			// If a view is currently attached to this proxy then tell it to add this new plot
			// to the graph
			if ([self view]) {
				[(TiChartsChart*)[self view] addPlot:plot];
			}
            
            // Remember the proxy or else it will get GC'd if created by a logic variable
            [self rememberProxy:plot];
		}
		else {
			NSLog(@"[DEBUG] Attempted to add plot that is already in the plot array");
		}
	}
}

-(void)remove:(id)arg
{
	ENSURE_SINGLE_ARG(arg,TiChartsPlotProxy);
	
	// Make sure that we are getting a plot proxy object
	if (![arg isKindOfClass:[TiChartsPlotProxy class]]) {
		[self throwException:@"Plot type is invalid" subreason:nil location:CODELOCATION];
	}
	
	TiChartsPlotProxy *plot = (TiChartsPlotProxy*)arg;
	
	// If a view is currently attached to this proxy then tell it to remove the plot
	// from the graph
	if ([self view]) {
		[(TiChartsChart*)[self view] removePlot:plot];
	}
	
	// Remove the plot from our list of plot proxy objects
	[plots removeObject:plot];
    
    // Forget the previously remembered proxy
    [self forgetProxy:plot];
}

-(id)createLinePlot:(id)args
{
	TiChartsLinePlotProxy *proxy = [[[TiChartsLinePlotProxy alloc] _initWithPageContext:[self pageContext] args:args] autorelease];
	[self add:proxy];
	
	return proxy;
}

-(id)createBarPlot:(id)args
{
	TiChartsBarPlotProxy *proxy = [[[TiChartsBarPlotProxy alloc] _initWithPageContext:[self pageContext] args:args] autorelease];
	[self add:proxy];
	
	return proxy;
}

-(id)createPiePlot:(id)args
{
	TiChartsPiePlotProxy *proxy = [[[TiChartsPiePlotProxy alloc] _initWithPageContext:[self pageContext] args:args] autorelease];
	[self add:proxy];
	
	return proxy;
}

#ifndef USE_VIEW_FOR_UI_METHOD
	#define USE_VIEW_FOR_UI_METHOD(methodname)\
	-(void)methodname:(id)args\
	{\
		[self makeViewPerformSelector:@selector(methodname:) withObject:args createIfNeeded:YES waitUntilDone:NO];\
	}
#endif
USE_VIEW_FOR_UI_METHOD(refresh);

@end
