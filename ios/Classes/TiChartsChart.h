/**
 * Ti.Charts Module
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiUIView.h"

#import "CorePlot-CocoaTouch.h"

typedef enum {
	kPlotTypeBar,
    kPlotTypeLine,
	kPlotTypePie
} ChartPlotType;

@class TiChartsPlotProxy;

@interface TiChartsChart : TiUIView <CPTPlotSpaceDelegate> {

@private
	CPTGraphHostingView	*hostingView;
	CPTXYGraph			*graph;
	CPTLayerAnnotation	*symbolTextAnnotation;
}
@property(nonatomic,readonly) CPTGraphHostingView* hostingView;

-(void)renderInView;

-(void)removeAllPlots;
-(void)addPlot:(TiChartsPlotProxy*)plot;
-(void)removePlot:(TiChartsPlotProxy*)plot;
-(void)refreshPlotSpaces;
-(CGPoint)viewPointFromGraphPoint:(CGPoint)point;
-(void)notifyOfTouchEvent:(NSString*)name atPoint:(CGPoint)viewPoint;

@end
