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
#import "CDOHResource.h"
#import "CDOHResourcePrivate.h"


@implementation CDOHResourceTests

- (void)testResourceObjectFromDictionary
{
	NSDictionary *resourceDict = [[NSDictionary alloc] initWithObjectsAndKeys:
								  [NSURL URLWithString:@"https://api.github.com/resource"], kCDOHResourceAPIResourceURLKey,
								  nil];
	CDOHResource *resource = [[CDOHResource alloc] initWithDictionary:resourceDict];
	NSDictionary *objectDict = [[NSDictionary alloc] initWithObjectsAndKeys:
								resource, @"resource",
								resourceDict, @"resourceDict",
								nil];
	
	
	id resourceFromDict = [CDOHResource resourceObjectFromDictionary:objectDict usingKey:@"resource" ofClass:[CDOHResource class]];
	id resourceCreatedFromDict = [CDOHResource resourceObjectFromDictionary:objectDict usingKey:@"resourceDict" ofClass:[CDOHResource class]];
	
	STAssertNotNil(resourceFromDict, @"Resource (%@) fetched from dictionary (%@) should not be nil", resource, objectDict);
	STAssertNotNil(resourceCreatedFromDict, @"Resource (%@) created and fetched from dictionary (%@) should not be nil", resourceDict, objectDict);
	
	STAssertTrue([resourceFromDict isKindOfClass:[CDOHResource class]], @"Resource (%@) fetched from dictionary (%@) should be of class 'CDOHResource'", resource, objectDict);
	STAssertTrue([resourceCreatedFromDict isKindOfClass:[CDOHResource class]], @"Resource (%@) created and fetched from dictionary (%@) should be of class 'CDOHResource'", resourceDict, objectDict);
	
	STAssertEqualObjects(resource, resourceFromDict, @"Resource (%@) fetched from dictionary (%@) should be equal (using isEqual:) to the original resource (%@)", resourceFromDict, objectDict, resource);
	STAssertEqualObjects(resource, resourceCreatedFromDict, @"Resource (%@) created and fetched from dictionary (%@) should be equal (using isEqual:) to the resource (%@) created with the dictionary (%@)", resourceCreatedFromDict, objectDict, resource, resourceDict);
}

- (void)testDateObjectFromDictionary
{
	
}

- (void)testURLObjectFromDictionary
{
}

- (void)testDecodeObjectFromDictionary
{
	
}

@end
