//
//  NSString+ObjectiveHub.m
//  ObjectiveHub
//
//  Created by Aron Cedercrantz on 2012-01-05.
//  Copyright (c) 2012 Aron Cedercrantz. All rights reserved.
//

#import "NSString+ObjectiveHub.h"
#import "NSDateFormatter+CDOHRFC3339.h"
#import "CDOHCommon.h"


CDOH_FIX_CATEGORY_BUG(NSString_ObjectiveHub);
@implementation NSString (ObjectiveHub)

- (NSDate *)dateRFC3339Formatted
{
	NSDateFormatter *rfc3339DateFormatter = [NSDateFormatter rfc3339DateFormatter];
	NSDate *date = [rfc3339DateFormatter dateFromString:self];
	return date;
}

@end
