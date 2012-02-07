//
//  NSURL+ObjectiveHubTests.m
//  ObjectiveHub
//
//  Created by Aron Cedercrantz on 2012-02-07.
//  Copyright (c) 2012 Aron Cedercrantz. All rights reserved.
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
