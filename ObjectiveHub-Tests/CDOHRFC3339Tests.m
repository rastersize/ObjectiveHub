//
//  NSDateFormatter+CDOHRFC3339Tests.m
//  ObjectiveHub
//
//  Created by Aron Cedercrantz on 2012-02-07.
//  Copyright (c) 2012 Aron Cedercrantz. All rights reserved.
//

#import "CDOHRFC3339Tests.h"

#import "NSString+ObjectiveHub.h"
#import "NSDate+ObjectiveHub.h"

@implementation CDOHRFC3339Tests

- (void)testRFC3339DateFormatter
{
	// 1970-02-11 19:44:14 +0000
	NSDate *controlDate = [NSDate dateWithTimeIntervalSince1970:3613454];
	
	NSString *rfc3339DateString = @"1970-02-11T19:44:14Z";
	NSDate *parsedDate = [rfc3339DateString cdoh_dateUsingRFC3339Format];
	
	STAssertEqualObjects(parsedDate, controlDate, @"The parsed date (%@) should be equal to the control date (%@)", parsedDate, controlDate);
	STAssertEqualObjects([parsedDate cdoh_stringUsingRFC3339Format], rfc3339DateString, @"Back and forth from string->date->string should yeild same result.");
}

@end
