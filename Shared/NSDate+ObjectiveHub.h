//
//  NSDate+ObjectiveHub.h
//  ObjectiveHub
//
//  Created by Aron Cedercrantz on 2012-01-05.
//  Copyright (c) 2012 Aron Cedercrantz. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * Various NSString additions used by ObjectiveHub.
 */
@interface NSDate (ObjectiveHub)

#pragma mark - Convert RFC 3339 Dates to Strings
/** @name Convert RFC 3339 Dates to Strings */
/**
 * Converts this date to a RFC 3339 formatted date string.
 *
 * @return A `NSString` instance initialized with this date as a RFC 3339
 * formatted date string.
 */
- (NSString *)RFC3339FormattedString;

@end
