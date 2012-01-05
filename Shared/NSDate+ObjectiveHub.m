//
//  NSDate+ObjectiveHub.m
//  ObjectiveHub
//
//  Created by Aron Cedercrantz on 2012-01-05.
//  Copyright (c) 2012 Aron Cedercrantz. All rights reserved.
//

#import "NSDate+ObjectiveHub.h"
#import "NSDateFormatter+CDOHRFC3339.h"
#import "CDOHCommon.h"


CDOH_FIX_CATEGORY_BUG(NSDate_ObjectiveHub)
@implementation NSDate (ObjectiveHub)

- (NSString *)RFC3339FormattedString
{
	NSDateFormatter *rfc3339DateFormatter = [NSDateFormatter rfc3339DateFormatter];
	NSString *rfc3339DateString = [rfc3339DateFormatter stringFromDate:self];
	return rfc3339DateString;
}

@end
