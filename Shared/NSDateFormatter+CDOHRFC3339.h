//
//  NSDateFormatter+CDOHRFC3339.h
//  ObjectiveHub
//
//  Created by Aron Cedercrantz on 2012-01-05.
//  Copyright (c) 2012 Aron Cedercrantz. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * The category privdes an RFC 3339 date formatter.
 *
 * The format of formatted date is: "2008-01-14T04:33:35Z".
 */
@interface NSDateFormatter (CDOHRFC3339)

/**
 * Returns a RFC 3339 date formatter.
 *
 * @return A RFC 3339 date formatter.
 */
+ (NSDateFormatter *)rfc3339DateFormatter;

@end
