//
//  NSDateFormatter+CDOHRFC3339.m
//  ObjectiveHub
//
//  Created by Aron Cedercrantz on 2012-01-05.
//  Copyright (c) 2012 Aron Cedercrantz. All rights reserved.
//

#import "NSDateFormatter+CDOHRFC3339.h"
#import "CDOHCommon.h"


CDOH_FIX_CATEGORY_BUG(NSDateFormatter_CDOHRFC3339)
@implementation NSDateFormatter (CDOHRFC3339)

// Implementation based on Apples cached RFC 3339 date formatter available in
// the developer documentation.
// http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/DataFormatting/Articles/dfDateFormatting10_4.html
+ (NSDateFormatter *)rfc3339DateFormatter
{
	static NSDateFormatter *rfc3339DateFormatter = nil;
	
	static dispatch_once_t rfc3339DateFormatterToken;
	dispatch_once(&rfc3339DateFormatterToken, ^{
		NSString *format = @"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'";
		
		NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
		
		rfc3339DateFormatter = [[NSDateFormatter alloc] init];
		[rfc3339DateFormatter setLocale:enUSPOSIXLocale];
		[rfc3339DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		[rfc3339DateFormatter setDateFormat:format];
	});
	
	return rfc3339DateFormatter;
}

@end
