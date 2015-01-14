/**
 * Ti.Charts Module
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiChartsParsers.h"
#import "TiUtils.h"
#import "TiChartsLabelFormatter.h"

@implementation TiChartsParsers

// parseColor
//
// Parameters:
//
// color - color value
// def - default color object
//
// Returns:
//   CPTColor* object or nil
//
+(CPTColor*)parseColor:(id)color def:(CPTColor*)def
{
	TiColor *newColor = [TiUtils colorValue:color];
	if (newColor != nil) {
			return [CPTColor colorWithCGColor:[newColor _color].CGColor];
	}
	
	return def;
}

// parseTextStyle
//
// Parameters:
//
// properties - dictionary of key-value pairs containing font definitions
// def - default text style object
//
// Returns:
//  CPTMutableTextStyle* object or nil
//
+(CPTMutableTextStyle*)parseTextStyle:(NSDictionary*)properties def:(CPTTextStyle*)def
{
	CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
	if (properties != nil) {			
		// Configure the font name and size
		NSDictionary* font = [properties objectForKey:@"font"];
		if (font) {
			WebFont *f = [TiUtils fontValue:font def:[WebFont defaultFont]];
			textStyle.fontName = f.font.fontName;
			textStyle.fontSize = f.size;
		} else {
			textStyle.fontName = def.fontName;
			textStyle.fontSize = def.fontSize;
		}
		
		// Configure the font color
		textStyle.color = [TiChartsParsers parseColor:[properties objectForKey:@"color"] def:def.color];
	} else {
		textStyle.fontName = def.fontName;
		textStyle.fontSize = def.fontSize;
		textStyle.color = def.color;
	}
		
	return textStyle;
}

// parseLineColor
//
// Parameters:
//
// color - color value
// width - width value
// opacity - opacity value
// def - default line style object
//
// Returns:
//   CPTLineStyle* or nil
//
+(CPTLineStyle*)parseLineColor:(id)color withWidth:(id)width andOpacity:(id)opacity def:(CPTLineStyle*)def
{
	CPTMutableLineStyle* lineStyle = [CPTMutableLineStyle lineStyle];
	
	lineStyle.lineColor = [TiChartsParsers parseColor:color def:def.lineColor];
	if (lineStyle.lineColor && opacity) {
		float alpha = [TiUtils floatValue:opacity def:1.0];
		lineStyle.lineColor = [lineStyle.lineColor colorWithAlphaComponent:alpha];
	}
		
	lineStyle.lineWidth = [TiUtils floatValue:width def:def.lineWidth];
		
	return lineStyle;
}

// parseFillColor
//
// Parameters:
//
// color - color value
// gradientProps - gradient dictionary
// opacity - opacity value
// def - default fill object
//
// Returns:
//   CPTFill* or nil
//
// NOTE: Gradient definition takes precedence over color if both are specified
//
+(CPTFill*)parseFillColor:(id)color withGradient:(id)gradientProps andOpacity:(id)opacity def:(CPTFill*)def
{
	// Check for gradient
	if (gradientProps) {
		CPTColor* startColor = [TiChartsParsers parseColor:[gradientProps objectForKey:@"startColor"] def:nil];
		if (startColor != nil) {
			CPTColor* endColor = [TiChartsParsers parseColor:[gradientProps objectForKey:@"endColor"] def:nil];
			if (endColor != nil) {
				CPTGradient* gradient = [CPTGradient gradientWithBeginningColor:startColor endingColor:endColor];
				gradient.angle = [TiUtils floatValue:@"angle" properties:gradientProps def:0.0];
				float alpha = [TiUtils floatValue:opacity def:1.0];
				return [CPTFill fillWithGradient:[gradient gradientWithAlphaComponent:alpha]];
			} 
		}
	}
	
	if (color) {
		CPTColor* fillColor = [TiChartsParsers parseColor:color def:nil];
		if (fillColor != nil) {
			float alpha = [TiUtils floatValue:opacity def:1.0];
			return [CPTFill fillWithColor:[fillColor colorWithAlphaComponent:alpha]];
		} 
	}
	
	return def;
}

// parsePlotRange
//
// Parameters:
//
// properties - dictionary of key-value pairs
// def - default plot range
//
// Returns:
//   CPTPlotRange*
//
+(CPTPlotRange*)parsePlotRange:(NSDictionary*)properties def:(CPTPlotRange*)def
{
    if (properties != nil) {
        return [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat([TiUtils floatValue:@"location" properties:properties def:0.0])
                                            length:CPTDecimalFromFloat([TiUtils floatValue:@"length" properties:properties def:0.0])];
    }
    
    return def;
}

// parseAxis
//
// Parameters:
//
// coordinate - CPTCoordinateX or CPTCoordinateY
// properties - dictionary of key-value pairs
// plotSpace - plotSpace object for the axis
// def - default Axis object
//
// Returns
//   CPTXYAxis* or nil
//
+(CPTXYAxis*)parseAxis:(CPTCoordinate)coordinate properties:(NSDictionary*)properties usingPlotSpace:(CPTPlotSpace*)plotSpace def:(CPTXYAxis*)def
{
	if (properties != nil) {
		// Get a copy of the xAxis or yAxis from the AxisSet so that we can use the
		// current settings as the default
		
		CPTXYAxis *axis = [[(CPTXYAxis*)[CPTXYAxis alloc] initWithFrame:CGRectZero] autorelease];
		axis.plotSpace = plotSpace;
		
		axis.coordinate = coordinate;
        
        // Parse the alignment or origin -- Alignment supercedes origin.
        BOOL exists;
        int axisAlignment = [TiUtils intValue:@"align" properties:properties def:CPTAlignmentLeft exists:&exists];
        if (exists) {
            int offset = [TiUtils floatValue:@"alignOffset" properties:properties def:0.0];
            if ((axisAlignment == CPTAlignmentRight) || (axisAlignment == CPTAlignmentTop)) {
                axis.axisConstraints = [CPTConstraints constraintWithUpperOffset:offset];
            } else {
                axis.axisConstraints = [CPTConstraints constraintWithLowerOffset:offset];
            }
        } else {     
            axis.orthogonalCoordinateDecimal = CPTDecimalFromFloat([TiUtils floatValue:@"origin" properties:properties def:0.0]);
        }
		
		// Parse the title
		NSDictionary* titleProps = [properties valueForKey:@"title"];
		if (titleProps) {
			axis.title = [TiUtils stringValue:@"text" properties:titleProps def:nil];
			
			// Configure the font name and size and color
			axis.titleTextStyle  = [TiChartsParsers parseTextStyle:titleProps def:axis.titleTextStyle];
			// The displacement defines the offset from the specified edge
			axis.titleOffset = [TiUtils floatValue:@"offset" properties:titleProps def:axis.titleOffset];
		}
		
		// Parse the tick direction
		axis.tickDirection = [TiUtils intValue:@"tickDirection" properties:properties def:CPTSignNegative];
		
        // Parse the visible range
        axis.visibleRange = [TiChartsParsers parsePlotRange:[properties objectForKey:@"visibleRange"] def:axis.visibleRange];
        
		// Parse the line style
		axis.axisLineStyle = [TiChartsParsers parseLineColor:[properties objectForKey:@"lineColor"]
											       withWidth:[properties objectForKey:@"lineWidth"]
											      andOpacity:[properties objectForKey:@"lineOpacity"]
											   		      def:axis.axisLineStyle];
		
        // Set the default labeling policy
		axis.labelingPolicy = CPTAxisLabelingPolicyAutomatic;

		// Parse the major ticks
		axis.majorTickLineStyle = nil;
		axis.majorGridLineStyle = nil;
        axis.majorTickLocations = nil;
        
        NSDictionary* props = [properties valueForKey:@"majorTicks"];
        if (props != nil) {
            axis.majorTickLineStyle = [TiChartsParsers parseLineColor:[props objectForKey:@"color"]
                                                       withWidth:[props objectForKey:@"width"]
                                                      andOpacity:[props objectForKey:@"opacity"]
                                                             def:axis.majorTickLineStyle];
            axis.majorTickLength = [TiUtils floatValue:@"length" properties:props def:2.0];
            
            
            int majorTickInterval = [TiUtils intValue:@"interval" properties:props def:0];
            if (majorTickInterval > 0) {
                axis.labelingPolicy = CPTAxisLabelingPolicyFixedInterval;         
                axis.majorIntervalLength = CPTDecimalFromInteger(majorTickInterval);
            }
            
            id gridlines = [props objectForKey:@"gridLines"];
            if (gridlines != nil) {
                axis.majorGridLineStyle = [TiChartsParsers parseLineColor:[gridlines objectForKey:@"color"]
                                                                withWidth:[gridlines objectForKey:@"width"]
                                                               andOpacity:[gridlines objectForKey:@"opacity"]
                                                                      def:axis.majorGridLineStyle];
                axis.gridLinesRange = [TiChartsParsers parsePlotRange:[gridlines objectForKey:@"range"] def:axis.gridLinesRange];
            }
            
            // NOTE: Don't set the 'axisLabels' property and use CPTAxisLabelingPolicyNone as this
            // will cause it to ignore any and all formatting control (e.g. rotation, alignment, etc.).
            // We can still get the formatting logic to execute by storing axis labels ourself and using
            // a custom label formatter.
            
            id locations = [props objectForKey:@"locations"];
            if (locations != nil) {
                // Label locations can be explicitly specified. It is important to know that the value for the label
                // must be included in the set of values for the major ticks in order for them to be displayed. Core-plot
                // will not display them if there isn't a major tick for the value.
                TiChartsLabelFormatter* labelFormatter = [[[TiChartsLabelFormatter alloc] initWithArray:locations] autorelease];
                axis.majorTickLocations = labelFormatter.tickLocations;
                axis.labelFormatter = labelFormatter;
                axis.labelingPolicy = CPTAxisLabelingPolicyLocationsProvided;
            }
              
            // Parse the label format
            NSDictionary* labelProps = [props valueForKey:@"labels"];
            if (labelProps) {
                axis.labelTextStyle = [TiChartsParsers parseTextStyle:labelProps def:axis.labelTextStyle];
                axis.labelOffset = [TiUtils floatValue:@"offset" properties:labelProps def:axis.labelOffset];
                axis.labelRotation = degreesToRadians([TiUtils floatValue:@"angle" properties:labelProps def:axis.labelRotation]);
                axis.labelAlignment = [TiUtils intValue:@"textAlign" properties:labelProps def:axis.labelAlignment];

                // Number format can be specified and the values will be formatted according to the specified format. Typically
                // this is done with the '#' and '0' characters (e.g. "###0.00"). Optionally, prefix and suffix strings can
                // be specified. See http://unicode.org/reports/tr35/tr35-6.html#Number_Format_Patterns for details.
                if (axis.labelFormatter) {
                    ((NSNumberFormatter *) axis.labelFormatter).positiveFormat = [TiUtils stringValue:@"numberFormatPositive" properties:labelProps
                                                                          def:[TiUtils stringValue:@"numberFormat" properties:labelProps def:((NSNumberFormatter *) axis.labelFormatter).positiveFormat]];    
                    ((NSNumberFormatter *) axis.labelFormatter).negativeFormat = [TiUtils stringValue:@"numberFormatNegative" properties:labelProps
                                                                          def:[TiUtils stringValue:@"numberFormat" properties:labelProps def:((NSNumberFormatter *) axis.labelFormatter).negativeFormat]];    
                    ((NSNumberFormatter *) axis.labelFormatter).positivePrefix = [TiUtils stringValue:@"numberPrefixPositive" properties:labelProps 
                                                                          def:[TiUtils stringValue:@"numberPrefix" properties:labelProps def:((NSNumberFormatter *) axis.labelFormatter).positivePrefix]];
                    ((NSNumberFormatter *) axis.labelFormatter).negativePrefix = [TiUtils stringValue:@"numberPrefixNegative" properties:labelProps
                                                                          def:[TiUtils stringValue:@"numberPrefix" properties:labelProps def:((NSNumberFormatter *) axis.labelFormatter).negativePrefix]];
                    ((NSNumberFormatter *) axis.labelFormatter).positiveSuffix = [TiUtils stringValue:@"numberSuffixPositive" properties:labelProps 
                                                                          def:[TiUtils stringValue:@"numberSuffix" properties:labelProps def:((NSNumberFormatter *) axis.labelFormatter).positiveSuffix]];
                    ((NSNumberFormatter *) axis.labelFormatter).negativeSuffix = [TiUtils stringValue:@"numberSuffixNegative" properties:labelProps
                                                                          def:[TiUtils stringValue:@"numberSuffix" properties:labelProps def:((NSNumberFormatter *) axis.labelFormatter).negativeSuffix]];
                }
            }
        }		
        
        // Parse the minor ticks
		axis.minorTickLineStyle = nil;
		axis.minorGridLineStyle = nil;
        
        props = [properties valueForKey:@"minorTicks"];
        if (props != nil) {
			axis.minorTickLineStyle = [TiChartsParsers parseLineColor:[props objectForKey:@"color"]
															withWidth:[props objectForKey:@"width"]
														   andOpacity:[props objectForKey:@"opacity"]
																  def:axis.minorTickLineStyle];
			axis.minorTickLength = [TiUtils floatValue:@"length" properties:props def:0.0];

            axis.minorTicksPerInterval = [TiUtils intValue:@"count" properties:props def:0];
            
            id gridlines = [props objectForKey:@"gridLines"];
            if (gridlines != nil) {
                axis.minorGridLineStyle = [TiChartsParsers parseLineColor:[gridlines objectForKey:@"color"]
                                                                withWidth:[gridlines objectForKey:@"width"]
                                                               andOpacity:[gridlines objectForKey:@"opacity"]
                                                                      def:axis.minorGridLineStyle];
            }
        } 
 
		return axis;
	}
	
	return def;
}

// parseSymbol
//
// Parameters:
//
// properties - dictionary of key-value pairs
//
// Returns:
//   CPTPlotSymbol* or nil
//
+(CPTPlotSymbol*)parseSymbol:(NSDictionary*)properties def:(CPTPlotSymbol*)def
{
    // *** WARNING ***
    // It is very important that the plot symbol be a valid object. Setting the plot symbol for
    // a plot to nil will break things in core plot library as it doesn't do a very good job of
    // checking for nil before trying to get the plot symbol's size. If you do set it to nil then
    // you will not get plot symbol clicked events on iOS5.
    
    if (def == nil) {
        def = [CPTPlotSymbol plotSymbol];
    }
    
	if (properties != nil) {
		CPTPlotSymbol *symbol = [[[CPTPlotSymbol alloc] init] autorelease];
		CPTPlotSymbolType type = (CPTPlotSymbolType)[TiUtils intValue:@"type" properties:properties def:def.symbolType];
		symbol.symbolType = type;
		
		symbol.lineStyle = [TiChartsParsers parseLineColor:[properties objectForKey:@"lineColor"]
											   withWidth:[properties objectForKey:@"lineWidth"]
											  andOpacity:[properties objectForKey:@"lineOpacity"]
													 def:def.lineStyle];		
		
		symbol.fill = [TiChartsParsers parseFillColor:[properties objectForKey:@"fillColor"]
										 withGradient:[properties objectForKey:@"fillGradient"]
										 andOpacity:[properties objectForKey:@"fillOpacity"]
												def:def.fill];
		
		symbol.size = CGSizeMake([TiUtils floatValue:@"width" properties:properties def:def.size.width], 
								 [TiUtils floatValue:@"height" properties:properties def:def.size.height]);
		return symbol;
	}
	
	return def;
}

// parseLabelStyle
//
// Parameters:
//
// properties - dictionary of key-value pairs
// plot - plot object to update
//
+(void)parseLabelStyle:(NSDictionary*)properties forPlot:(CPTPlot*)plot
{
	plot.labelTextStyle = [TiChartsParsers parseTextStyle:properties def:plot.labelTextStyle];
	plot.labelOffset = [TiUtils floatValue:@"offset" properties:properties def:plot.labelOffset];
	plot.labelRotation = degreesToRadians([TiUtils floatValue:@"angle" properties:properties def:plot.labelRotation]);
}

// decimalFromFloat
//
// Parameters:
//
// value - object to convert
// def - default value
//
// Returns:
//   NSDecimal
//
+(NSDecimal)decimalFromFloat:(id)value def:(NSDecimal)def
{
	if (value) {
		return CPTDecimalFromFloat([TiUtils floatValue:value def:0.0]);
	}
	
	return def;
}

@end
