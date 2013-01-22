/**
 * Ti.Charts Module
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiViewProxy.h"

@interface TiChartsChartProxy : TiViewProxy {

@private	
	NSMutableArray	*plots;
}

-(NSMutableArray*)plots;
-(void)refreshPlotSpaces;

@end
