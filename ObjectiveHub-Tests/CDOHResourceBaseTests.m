//
//  CDOHResourceTestsBase.m
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

#import "CDOHResourceBaseTests.h"

#import "CDOHResource.h"
#import "CDOHResourcePrivate.h"


@implementation CDOHResourceBaseTests

#pragma mark - Tested Class
+ (Class)testedClass
{
	return [CDOHResource class];
}


#pragma mark - Test Dictionaries
+ (NSDictionary *)firstTestDictionary
{
	static NSDictionary *firstTestDictionary = nil;
	
	static dispatch_once_t firstTestDictionaryToken;
	dispatch_once(&firstTestDictionaryToken, ^{
		firstTestDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
							   [NSURL URLWithString:@"https://api.github.com/first_resource"],	kCDOHResourceAPIResourceURLKey,
							   nil];
	});
	
	return firstTestDictionary;
}

+ (NSDictionary *)secondTestDictionary
{
	static NSDictionary *secondTestDictionary = nil;
	
	static dispatch_once_t secondTestDictionaryToken;
	dispatch_once(&secondTestDictionaryToken, ^{
		secondTestDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
								[NSURL URLWithString:@"https://api.github.com/second_resource"],	kCDOHResourceAPIResourceURLKey,
								nil];
	});
	
	return secondTestDictionary;
}

// In the default implementation the alt-version of the first test dictionary
// is the same as the original first test dictionary as CDOHResources do not
+ (NSDictionary *)firstTestDictionaryAlt
{
	return [self firstTestDictionary];
}


#pragma mark - Test Resources
- (CDOHResource *)firstTestResource
{
	NSDictionary *firstTestDictionary = [[self class] firstTestDictionary];
	CDOHResource *firstTestResource = [[[[self class] testedClass] alloc] initWithDictionary:firstTestDictionary];
	return firstTestResource;
}

- (CDOHResource *)firstTestResourceAlt
{
	NSDictionary *firstTestDictionaryAlt = [[self class] firstTestDictionaryAlt];
	CDOHResource *firstTestResourceAlt = [[[[self class] testedClass] alloc] initWithDictionary:firstTestDictionaryAlt];
	return firstTestResourceAlt;
}

- (CDOHResource *)secondTestResource
{
	NSDictionary *secondTestDictionary = [[self class] secondTestDictionary];
	CDOHResource *secondTestResource = [[[[self class] testedClass] alloc] initWithDictionary:secondTestDictionary];
	return secondTestResource;
}



#pragma mark - Test Resource Equality and Hash
- (void)testResourceEquality
{
	CDOHResource *firstResource_1 = [self firstTestResource];
	CDOHResource *firstResource_2 = [self firstTestResource];
	CDOHResource *firstResourceAlt = [self firstTestResourceAlt];
	CDOHResource *secondResource = [self secondTestResource];
	CDOHResource *firstResource_1Copy = [firstResource_1 copy];
	
	STAssertEqualObjects(firstResource_1, firstResource_2,		@"Two resources ('%@' and '%@') intialized using the same dictionary should be equal (using isEqual:)", firstResource_1, firstResource_2);
	STAssertEqualObjects(firstResource_1, firstResource_1Copy,	@"A copy of a resource (%@) should be equal (using isEqual:) to the original (%@)", firstResource_1Copy, firstResource_1);
	STAssertEqualObjects(firstResource_1, firstResourceAlt,		@"Two resources ('%@' and '%@') with everything required (by spec) to be equal but otherwise completely different should be equal (using isEqual:)", firstResource_1, firstResourceAlt);
	
	STAssertFalse(firstResource_1 == secondResource,			@"Two different resources ('%@' and '%@') should NOT be the same object", firstResource_1, secondResource);
	STAssertFalse([firstResource_1 isEqual:secondResource],		@"Two different resources ('%@' and '%@') should NOT be equal (using isEqual:)", firstResource_1, secondResource);
}

- (void)testResourceInequality
{
	CDOHResource *firstResource = [self firstTestResource];
	CDOHResource *secondResource = [self secondTestResource];
	NSObject *differentClassObject = [[NSObject alloc] init];
	
	STAssertFalse(firstResource == secondResource, @"Two different resources ('%@' and '%@') should not be the exact same object (i.e. %p != %p)", firstResource, secondResource, firstResource, secondResource);
	STAssertFalse([firstResource isEqual:secondResource], @"Two different resources ('%@'(API URL = %@) and '%@'(API URL = %@)) should not be equal when compared using 'isEqual:'", firstResource, [firstResource _APIResourceURL], secondResource, [secondResource _APIResourceURL]);
	STAssertFalse([firstResource isEqual:differentClassObject], @"A resource object (%@) should not be equal to a object (%@) of any other class than '%@' or any of its subclasses", firstResource, differentClassObject, [[self class] testedClass]);
}

- (void)testResourceHashEqual
{
	CDOHResource *firstResource_1 = [self firstTestResource];
	CDOHResource *firstResource_2 = [self firstTestResource];
	CDOHResource *firstResourceAlt = [self firstTestResourceAlt];
	CDOHResource *firstResource_1Copy = [firstResource_1 copy];
	
	STAssertEquals([firstResource_1 hash], [firstResource_2 hash], @"Two resources ('%@' and '%@') intialized using the same dictionary should have the same hash (%lu == %lu)", firstResource_1, firstResource_2, [firstResource_1 hash], [firstResource_2 hash]);
	STAssertEquals([firstResource_1 hash], [firstResource_1Copy hash], @"A copy of a resource (%@, hash = %lu) should yeild the same hash as the original (%@, hash = %lu)", firstResource_1, [firstResource_1 hash], firstResource_1Copy, [firstResource_1Copy hash]);
	STAssertEquals([firstResource_1 hash], [firstResourceAlt hash], @"Two resources ('%@' and '%@') with everything required (by spec) to be equal but otherwise completely different should have the same hash (%lu == %lu)", firstResource_1, firstResourceAlt, [firstResource_1 hash], [firstResourceAlt hash]);
}

- (void)testResourceHashInequal
{
	CDOHResource *firstResource = [self firstTestResource];
	CDOHResource *secondResource = [self secondTestResource];
	
	STAssertFalse([firstResource hash] == [secondResource hash], @"Two resources ('%@', '%@') that are not said to be equal should not have the same hash (%lu != %lu)", firstResource, secondResource, [firstResource hash], [secondResource hash]);
}


#pragma mark - Test Dictionary Encoding and Decoding
- (void)testResourceDecodeFromDictionary
{
	NSDictionary *testDict = [[self class] firstTestDictionary];
	CDOHResource *resource = [[[[self class] testedClass] alloc] initWithDictionary:testDict];
	
	STAssertEqualObjects(resource._APIResourceURL, [testDict objectForKey:kCDOHResourceAPIResourceURLKey], @"Resource API URL (%@) should be same as URL in dictionary (%@)", resource._APIResourceURL, [testDict objectForKey:kCDOHResourceAPIResourceURLKey]);
}

- (void)testResourceEncodeAsDictionary
{
	NSDictionary *testDict = [[self class] firstTestDictionary];
	CDOHResource *resource = [[[[self class] testedClass] alloc] initWithDictionary:testDict];
	NSDictionary *encodedDict = [resource encodeAsDictionary];
	
	STAssertEqualObjects(testDict, encodedDict, @"Creating a resource (%@) from a dictionary (%@) and then encoding it as a dictionary (%@) should yeild an identical dictionary", resource, testDict, encodedDict);
}


#pragma mark - Test NSCoding Encoding and Decoding
- (void)testResourceConformsToNSCoding
{
	CDOHResource *firstResource = [self firstTestResource];
	
	STAssertTrue([firstResource conformsToProtocol:@protocol(NSCoding)], @"The resource '%@' must conform to the 'NSCoding' protocl", [[self class] testedClass]);
}

- (void)testResourceNSCodingRoundTrip
{
	CDOHResource *firstResource = [self firstTestResource];
	CDOHResource *decodedFirstResource = nil;
	
	NSData *encodedFirstResource = [NSKeyedArchiver archivedDataWithRootObject:firstResource];
	STAssertNotNil(encodedFirstResource, @"The encoded version of the resource (%@) should not be nil", firstResource);
	
	decodedFirstResource = [NSKeyedUnarchiver unarchiveObjectWithData:encodedFirstResource];
	
	STAssertNotNil(decodedFirstResource, @"The decoded resource should no be nil", firstResource);
	STAssertEqualObjects(firstResource, decodedFirstResource, @"The decoded resource (%@) should be equal (using isEqual:) to the original resource (%@)", decodedFirstResource, firstResource);
}


#pragma mark - Test NSCopying Conformans
- (void)testResourceConformsToNSCopying
{
	CDOHResource *firstResource = [self firstTestResource];
	
	STAssertTrue([firstResource conformsToProtocol:@protocol(NSCopying)], @"The resource '%@' must conform to the 'NSCopying' protocl", [[self class] testedClass]);
}

- (void)testResourceImmutableCopy
{
	CDOHResource *firstResource = [self firstTestResource];
	CDOHResource *firstResourceCopy = [firstResource copy];
	
	STAssertTrue(firstResource == firstResourceCopy, @"The copy (%@) of a resource (%@) should be the same object (%p == %p)", firstResource, firstResourceCopy, firstResource, firstResourceCopy);
}


@end
