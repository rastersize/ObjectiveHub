//
//  NSString+ObjectiveHub.h
//  ObjectiveHub
//
//  Created by Aron Cedercrantz on 2012-01-05.
//  Copyright (c) 2012 Aron Cedercrantz. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * Various NSString additions used by ObjectiveHub.
 */
@interface NSString (ObjectiveHub)

#pragma mark - Convert RFC 3339 Strings to Dates
/** @name Convert RFC 3339 Strings to Dates */
/**
 * Converts this string from a RFC 3339 formatted date string to a `NSDate`.
 *
 * @return A `NSDate` instance initialized with this RFC 3339 formatted string
 * if this string does not conform to the RFC 3339 format `nil` is returned.
 */
- (NSDate *)dateRFC3339Formatted;

@end
