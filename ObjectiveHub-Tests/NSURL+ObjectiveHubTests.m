//
//  NSURL+ObjectiveHubTests.m
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

#import "NSURL+ObjectiveHubTests.h"
#import "NSURL+ObjectiveHub.h"

@implementation NSURL_ObjectiveHubTests

- (void)testQueryValueForKey
{
	NSURL *url = [[NSURL alloc] initWithString:@"http://example.com/path/to/a/file.ext?foo=bar&test&another=equal&num=1234&"];
	
	STAssertEqualObjects(@"bar", [url cdoh_queryValueForKey:@"foo"], @"Key 'foo' should yeild 'bar' did yeild '%@'", [url cdoh_queryValueForKey:@"foo"]);
	STAssertEqualObjects(@"equal", [url cdoh_queryValueForKey:@"another"], @"Key 'another' should yeild 'equal' did yeild '%@'", [url cdoh_queryValueForKey:@"another"]);
	STAssertEqualObjects(@"1234", [url cdoh_queryValueForKey:@"num"], @"Key 'num' should yeild '1234' did yeild '%@'", [url cdoh_queryValueForKey:@"num"]);
	STAssertNil([url cdoh_queryValueForKey:@"test"], @"Key 'test' should yeild nil did yeild '%@'", [url cdoh_queryValueForKey:@"test"]);
}

- (void)testQueryDictionary
{
	NSDictionary *controlQueryDict = [[NSDictionary alloc] initWithObjectsAndKeys:
									  @"bar",			@"foo",
									  [NSNull null],	@"test",
									  @"equal",			@"another",
									  @"1234",			@"num",
									  nil];
	NSURL *url = [[NSURL alloc] initWithString:@"http://example.com/path/to/a/file.ext?foo=bar&test&another=equal&num=1234&"];
	NSDictionary *parsedDict = [url cdoh_queryDictionary];
	
	STAssertEqualObjects(controlQueryDict, parsedDict, @"Query dictionary should be equal to controlQueryDict (not same object).");
}

@end
