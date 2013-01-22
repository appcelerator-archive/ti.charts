/**
 * Ti.Charts Module
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiChartsLabelFormatter.h"
#import "TiUtils.h"
#import "CorePlot-CocoaTouch.h"

@implementation TiChartsLabelFormatter

@synthesize tickLocations;

-(void)setTickInfo:(NSArray*)values
{
    RELEASE_TO_NIL(customLabels);
    RELEASE_TO_NIL(tickLocations);
    
    if ([values count] > 0) {
        
        // For custom labels to be displayed there must be a tick location for each label.
        // The locations can be set one of two ways: an array of location values or an array
        // of dictionary values that specify a 'value' and the 'text' label to be used. The
        // array of tick locations is built up in either case, but the array of customLabels
        // is only built if dictionary values are provided.
        // We determine which format is used based on the first value in the array. In other
        // words, we don't currently support mixing dictionary and individual values.
        
        NSMutableSet* newTickLocations = [[NSMutableSet alloc] initWithCapacity:values.count];
        if ([[values objectAtIndex:0] isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary* newLabels = [[NSMutableDictionary alloc] initWithCapacity:[values count]];
            for (id obj in values) {
                NSNumber* key = [NSDecimalNumber numberWithFloat:[TiUtils floatValue:@"value" properties:obj def:0.0]];
                [newLabels setObject:[TiUtils stringValue:@"text" properties:obj def:@""] forKey:key];
                [newTickLocations addObject:key];
            }
            customLabels = newLabels;
        } else {
            // We could just set the array based on the array of values passed in. However, Titanium
            // supports specifying values as strings and letting them be converted by TiUtils. So we
            // have to walk the array of values and convert them, just in case.
            for (id obj in values) {
                NSNumber* key = [NSDecimalNumber numberWithFloat:[TiUtils floatValue:obj]];
                [newTickLocations addObject:key];
            }
        }
        
        tickLocations = newTickLocations;
    }	
}

-(id)init
{
    if (self = [super init]) {
        // Default number formatter
        self.minimumIntegerDigits = 1;
        self.maximumFractionDigits = 1; 
        self.minimumFractionDigits = 1;
    }
    
    return self;
}

-(void)dealloc
{
    RELEASE_TO_NIL(customLabels);
    RELEASE_TO_NIL(tickLocations);
	[super dealloc];
}

-(id)initWithArray:(NSArray*)values
{
	if ( (self = [super init]) ) {
        [self setTickInfo:values];
	}
    
	return self;	
}

-(NSString *)stringForObjectValue:(NSDecimalNumber *)coordinateValue
{
    if (customLabels != nil) {
        NSString* result =[customLabels objectForKey:coordinateValue];
        return (result != nil) ? result : @"";
    } else {
        return [super stringForObjectValue:coordinateValue];
    }
}

@end
