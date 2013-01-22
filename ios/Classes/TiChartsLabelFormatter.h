/**
 * Ti.Charts Module
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import <Foundation/Foundation.h>

@interface TiChartsLabelFormatter : NSNumberFormatter {
@private
    NSDictionary* customLabels;
    NSSet* tickLocations;
}

-(id)initWithArray:(NSArray*)values;
@property(nonatomic,readonly) NSSet* tickLocations;

@end
