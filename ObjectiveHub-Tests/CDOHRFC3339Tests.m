//
//  CDOHRFC3339Tests.m
//  ObjectiveHub
//
//  Copyright 2011-2012 Aron Cedercrantz. All rights reserved.
//  
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//  
//  1. Redistributions of source code must retain the above copyright notice,
//  this list of conditions and the following disclaimer.
//  
//  2. Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//  
//  THIS SOFTWARE IS PROVIDED BY ARON CEDERCRANTZ ''AS IS'' AND ANY EXPRESS OR
//  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
//  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
//  EVENT SHALL ARON CEDERCRANTZ OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
//  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
//  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//  
//  The views and conclusions contained in the software and documentation are
//  those of the authors and should not be interpreted as representing official
//  policies, either expressed or implied, of Aron Cedercrantz.
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
