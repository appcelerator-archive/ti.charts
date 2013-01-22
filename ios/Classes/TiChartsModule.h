/**
 * Ti.Charts Module
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiModule.h"

@interface TiChartsModule : TiModule 
{
}

@property(nonatomic,readonly) NSNumber *LOCATION_TOP;
@property(nonatomic,readonly) NSNumber *LOCATION_BOTTOM;
@property(nonatomic,readonly) NSNumber *LOCATION_LEFT;
@property(nonatomic,readonly) NSNumber *LOCATION_RIGHT;
@property(nonatomic,readonly) NSNumber *LOCATION_TOP_LEFT;
@property(nonatomic,readonly) NSNumber *LOCATION_TOP_RIGHT;
@property(nonatomic,readonly) NSNumber *LOCATION_BOTTOM_LEFT;
@property(nonatomic,readonly) NSNumber *LOCATION_BOTTOM_RIGHT;
@property(nonatomic,readonly) NSNumber *LOCATION_CENTER;

@property(nonatomic,readonly) NSString *THEME_DARK_GRADIENT;
@property(nonatomic,readonly) NSString *THEME_WHITE;
@property(nonatomic,readonly) NSString *THEME_BLACK;
@property(nonatomic,readonly) NSString *THEME_SLATE;
@property(nonatomic,readonly) NSString *THEME_STOCKS;

@property(nonatomic,readonly) NSNumber *SIGN_POSITIVE;
@property(nonatomic,readonly) NSNumber *SIGN_NEGATIVE;

@property(nonatomic,readonly) NSNumber *DIRECTION_HORIZONTAL;
@property(nonatomic,readonly) NSNumber *DIRECTION_VERTICAL;

@property(nonatomic,readonly) NSNumber *SYMBOL_NONE;
@property(nonatomic,readonly) NSNumber *SYMBOL_RECTANGLE;
@property(nonatomic,readonly) NSNumber *SYMBOL_ELLIPSE;
@property(nonatomic,readonly) NSNumber *SYMBOL_DIAMOND;
@property(nonatomic,readonly) NSNumber *SYMBOL_TRIANGLE;
@property(nonatomic,readonly) NSNumber *SYMBOL_STAR;
@property(nonatomic,readonly) NSNumber *SYMBOL_PENTAGON;
@property(nonatomic,readonly) NSNumber *SYMBOL_HEXAGON;
@property(nonatomic,readonly) NSNumber *SYMBOL_CROSS;
@property(nonatomic,readonly) NSNumber *SYMBOL_PLUS;
@property(nonatomic,readonly) NSNumber *SYMBOL_DASH;
@property(nonatomic,readonly) NSNumber *SYMBOL_SNOW;

@property(nonatomic,readonly) NSNumber *DIRECTION_CLOCKWISE;
@property(nonatomic,readonly) NSNumber *DIRECTION_COUNTERCLOCKWISE;

@property(nonatomic,readonly) NSNumber *PLOT_BAR;
@property(nonatomic,readonly) NSNumber *PLOT_LINE;
@property(nonatomic,readonly) NSNumber *PLOT_PIE;

@end
