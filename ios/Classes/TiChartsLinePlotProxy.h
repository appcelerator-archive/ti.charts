/**
 * Ti.Charts Module
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiChartsScatterPlotProxy.h"
	
@interface TiChartsLinePlotProxy : TiChartsScatterPlotProxy <CPTScatterPlotDelegate, CPTScatterPlotDataSource> {
	
@private
    NSUInteger highlightSymbolIndex;
    CPTPlotSymbol* highlightSymbol;
}

@end
