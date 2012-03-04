//
//  CDOHResourceTests.m
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

#import "CDOHResourceTests.h"

#import "NSDate+ObjectiveHub.h"


@implementation CDOHResourceTests

- (void)testMergeDictionaries
{
	NSDictionary *superDict = [NSDictionary dictionaryWithObjectsAndKeys:
							   @"superValue", @"super",
							   @"superDupValue", @"duplicate",
							   nil];
	NSDictionary *subclassDict = [NSDictionary dictionaryWithObjectsAndKeys:
								  @"subValue", @"sub",
								  @"subDupValue", @"duplicate",
								  nil];
	NSDictionary *expectedMergeResult = [NSDictionary dictionaryWithObjectsAndKeys:
										 @"superValue", @"super",
										 @"subValue", @"sub",
										 @"subDupValue", @"duplicate",
										 nil];
	NSDictionary *mergedDict = [CDOHResource mergeSubclassDictionary:subclassDict withSuperclassDictionary:superDict];
	
	STAssertNotNil(mergedDict, @"Merging two dictionaries ('%@' and '%@') should not result in nil", superDict, subclassDict);
	STAssertTrue([mergedDict count] == 3, @"Merging two dictionaries ('%@' and '%@') with one duplicate key should result in a dictionary of size '3' was '%lu'", superDict, subclassDict, [mergedDict count]);
	STAssertEqualObjects(mergedDict, expectedMergeResult, @"Merging two dictionaries ('%@' and '%@') with one duplicate key should result in the following dictionary '%@' was '%@'", superDict, subclassDict, expectedMergeResult, mergedDict);
	
	
	NSDictionary *mergedNilDict = [CDOHResource mergeSubclassDictionary:nil withSuperclassDictionary:nil];
	NSDictionary *mergedSuperNilDict = [CDOHResource mergeSubclassDictionary:subclassDict withSuperclassDictionary:nil];
	NSDictionary *mergedSubNilDict = [CDOHResource mergeSubclassDictionary:nil withSuperclassDictionary:superDict];
	
	STAssertNil(mergedNilDict, @"Merging nil with nil should result in nil");
	STAssertNotNil(mergedSuperNilDict, @"Merging nil with a super dictionary (%@) should not result in nil", superDict);
	STAssertNotNil(mergedSubNilDict, @"Merging nil with a subclass dictionary (%@) should not result in nil", subclassDict);
	
	STAssertEqualObjects(mergedSuperNilDict, subclassDict, @"Merging the subclass dictionary (%@) with nil should result in the subclass dictionary was '%@'", subclassDict, mergedSuperNilDict);
	STAssertEqualObjects(mergedSubNilDict, superDict, @"Merging the super dictionary (%@) with nil should result in the super dictionary was '%@'", superDict, mergedSubNilDict);
	
}

- (void)testResourceObjectFromDictionary
{
	NSDictionary *resourceDict = [[NSDictionary alloc] initWithObjectsAndKeys:
								  [NSURL URLWithString:@"https://api.github.com/resource"], kCDOHResourceAPIResourceURLKey,
								  nil];
	CDOHResource *resource = [[CDOHResource alloc] initWithJSONDictionary:resourceDict];
	NSDictionary *objectDict = [[NSDictionary alloc] initWithObjectsAndKeys:
								resource, @"resource",
								resourceDict, @"resourceDict",
								nil];
	
	
	id resourceFromDict			= [objectDict cdoh_resourceForKey:@"resource" ofClass:[CDOHResource class]];
	id resourceCreatedFromDict	= [objectDict cdoh_resourceForKey:@"resourceDict" ofClass:[CDOHResource class]];
	
	STAssertNotNil(resourceFromDict, @"Resource (%@) fetched from dictionary (%@) should not be nil", resource, objectDict);
	STAssertNotNil(resourceCreatedFromDict, @"Resource (%@) created and fetched from dictionary (%@) should not be nil", resourceDict, objectDict);
	
	STAssertTrue([resourceFromDict isKindOfClass:[CDOHResource class]], @"Resource (%@) fetched from dictionary (%@) should be of class 'CDOHResource' was '%@'", resourceFromDict, objectDict, NSStringFromClass([resourceFromDict class]));
	STAssertTrue([resourceCreatedFromDict isKindOfClass:[CDOHResource class]], @"Resource (%@) created and fetched from dictionary (%@) should be of class 'CDOHResource' was '%@'", resourceCreatedFromDict, objectDict, NSStringFromClass([resourceCreatedFromDict class]));
	
	STAssertEqualObjects(resource, resourceFromDict, @"Resource (%@) fetched from dictionary (%@) should be equal (using isEqual:) to the original resource (%@)", resourceFromDict, objectDict, resource);
	STAssertEqualObjects(resource, resourceCreatedFromDict, @"Resource (%@) created and fetched from dictionary (%@) should be equal (using isEqual:) to the resource (%@) created with the dictionary (%@)", resourceCreatedFromDict, objectDict, resource, resourceDict);
}

- (void)testDateObjectFromDictionary
{
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:3613454];
	NSString *dateString = [date cdoh_stringUsingRFC3339Format];
	
	NSDictionary *dateDict = [[NSDictionary alloc] initWithObjectsAndKeys:
							  date, @"date",
							  dateString, @"dateString",
							  nil];
	
	id dateFromDict			= [dateDict cdoh_dateForKey:@"date"];
	id dateCreatedFromDict	= [dateDict cdoh_dateForKey:@"dateString"];
	
	STAssertNotNil(dateFromDict, @"Date (%@) fetched from dictionary (%@) should not be nil", date, dateDict);
	STAssertNotNil(dateCreatedFromDict, @"Date (%@) created and fetched from dictionary (%@) should not be nil", dateString, dateDict);
	
	STAssertTrue([dateFromDict isKindOfClass:[NSDate class]], @"Date (%@) fetched from dictionary (%@) should be of class 'NSDate' was '%@'", dateFromDict, dateDict, NSStringFromClass([dateFromDict class]));
	STAssertTrue([dateCreatedFromDict isKindOfClass:[NSDate class]], @"Date (%@) created and fetched from dictionary (%@) should be of class 'NSDate' was '%@'", dateCreatedFromDict, dateDict, NSStringFromClass([dateCreatedFromDict class]));
	
	STAssertEqualObjects(date, dateFromDict, @"Date (%@) fetched from dictionary (%@) should be equal (using isEqual:) to the original date (%@)", dateCreatedFromDict, dateDict, date);
	STAssertEqualObjects(date, dateCreatedFromDict, @"Date (%@) created and fetched from dictionary (%@) should be equal (using isEqual:) to the original date (%@)", dateCreatedFromDict, dateDict, date);
}

- (void)testURLObjectFromDictionary
{
	NSString *urlString = @"https://user:pass@api.github.com/resource/stuff?per_page=5&page=2&#hashBang";
	NSURL *url = [NSURL URLWithString:urlString];
	
	NSDictionary *objectDict = [[NSDictionary alloc] initWithObjectsAndKeys:
								url,		@"url",
								urlString,	@"urlString",
								nil];
	
	
	id urlFromDict			= [objectDict cdoh_URLForKey:@"url"];
	id urlCreatedFromDict	= [objectDict cdoh_URLForKey:@"urlString"];
	
	STAssertNotNil(urlFromDict, @"URL (%@) fetched from dictionary (%@) should not be nil", url, objectDict);
	STAssertNotNil(urlCreatedFromDict, @"URL (%@) created and fetched from dictionary (%@) should not be nil", urlString, objectDict);
	
	STAssertTrue([urlFromDict isKindOfClass:[NSURL class]], @"URL (%@) fetched from dictionary (%@) should be of class 'CDOHResource' was '%@'", urlFromDict, objectDict, NSStringFromClass([urlFromDict class]));
	STAssertTrue([urlCreatedFromDict isKindOfClass:[NSURL class]], @"URL (%@) created and fetched from dictionary (%@) should be of class 'CDOHResource' was '%@'", urlCreatedFromDict, objectDict, NSStringFromClass([urlCreatedFromDict class]));
	
	STAssertEqualObjects(url, urlFromDict, @"URL (%@) fetched from dictionary (%@) should be equal (using isEqual:) to the original URL (%@)", urlFromDict, objectDict, url);
	STAssertEqualObjects(url, urlCreatedFromDict, @"URL (%@) created and fetched from dictionary (%@) should be equal (using isEqual:) to the URL (%@) created with the string (%@)", urlCreatedFromDict, objectDict, url, urlString);
}

@end
