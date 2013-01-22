/**
 * Ti.Charts Module
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiProxy.h"

#import "CorePlot-CocoaTouch.h"

@class TiChartsChartProxy;

@interface TiChartsPlotProxy : TiProxy <TiProxyDelegate, CPTPlotDataSource> {
	
@private
	CPTPlot				*plot;
	NSMutableArray		*data;
	NSString			*dataKey;
	int					dirtyDataFlags;
	NSSet				*propertyChangedProperties;
	TiChartsChartProxy	*chartProxy;
}

@property(nonatomic,readwrite,retain) NSString* dataKey;
@property(nonatomic,readwrite,retain) NSSet* propertyChangedProperties;
@property(nonatomic,readwrite,retain) CPTPlot* plot;
@property(nonatomic,assign) TiChartsChartProxy* chartProxy;

-(CPTPlot*)allocPlot;
-(void)configurePlot;
-(void)renderInChart:(CPTXYGraph*)graph;
-(void)removeFromChart:(CPTXYGraph*)graph;
-(NSNumber*)numberForPlot:(NSUInteger)index;
-(NSNumber*)numberForPlot:(NSUInteger)index forCoordinate:(CPTCoordinate)coordinate;
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot;
-(void)refreshData;
-(void)notifyOfDataClickedEvent:(NSUInteger)index;
-(void)notifyOfDataClickedEvent:(NSUInteger)index atPlotPoint:(CGPoint)plotPoint;
-(CGPoint)viewPointFromGraphPoint:(CGPoint)point;

@end

