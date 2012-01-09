//
//  NSDateFormatter+CDOHRFC3339.m
//  ObjectiveHub
//
//  Copyright 2011 Aron Cedercrantz. All rights reserved.
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

#import "NSDateFormatter+CDOHRFC3339.h"
#import "CDOHCommon.h"


CDOH_FIX_CATEGORY_BUG(NSDateFormatter_CDOHRFC3339)
@implementation NSDateFormatter (CDOHRFC3339)

// Implementation based on Apples cached RFC 3339 date formatter available in
// the developer documentation.
// http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/DataFormatting/Articles/dfDateFormatting10_4.html
+ (NSDateFormatter *)cdoh_RFC3339DateFormatter
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
