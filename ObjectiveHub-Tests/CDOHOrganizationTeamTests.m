//
//  CDOHOrganizationTeamTests.m
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

#import "CDOHOrganizationTeamTests.h"
#import "CDOHOrganizationTeam.h"


@implementation CDOHOrganizationTeamTests

#pragma mark - Tested Class
+ (Class)testedClass
{
	return [CDOHOrganizationTeam class];
}


#pragma mark - Test Dictionaries
+ (NSDictionary *)firstTestDictionary
{
	static NSDictionary *dictionary = nil;
	
	static dispatch_once_t firstTestDictionaryToken;
	dispatch_once(&firstTestDictionaryToken, ^{
		NSDictionary *superDict = [super firstTestDictionary];
		NSDictionary *localDict = [[NSDictionary alloc] initWithObjectsAndKeys:
								   CDOHTestNumFromUInteger(1234),		kCDOHOrganizationTeamIdentifierKey,
								   @"A test team",						kCDOHOrganizationTeamNameKey,
								   kCDOHOrganizationTeamPermissionPull,	kCDOHOrganizationTeamPermissionKey,
								   CDOHTestNumFromUInteger(10),			kCDOHOrganizationTeamRepositoriesKey,
								   CDOHTestNumFromUInteger(321),		kCDOHOrganizationTeamMembersKey,
					  nil];
		
		dictionary = [CDOHResource mergeSubclassDictionary:localDict withSuperclassDictionary:superDict];
	});
	
	return dictionary;
}

+ (NSDictionary *)firstTestDictionaryAlt
{
	static NSDictionary *dictionary = nil;
	
	static dispatch_once_t firstTestDictionaryAltToken;
	dispatch_once(&firstTestDictionaryAltToken, ^{
		NSDictionary *superDict = [super firstTestDictionaryAlt];
		NSDictionary *localDict = [[NSDictionary alloc] initWithObjectsAndKeys:
								   CDOHTestNumFromUInteger(1234),		kCDOHOrganizationTeamIdentifierKey,
								   @"New name for the team",			kCDOHOrganizationTeamNameKey,
								   kCDOHOrganizationTeamPermissionPull,	kCDOHOrganizationTeamPermissionKey,
								   CDOHTestNumFromUInteger(999),		kCDOHOrganizationTeamRepositoriesKey,
								   CDOHTestNumFromUInteger(456),		kCDOHOrganizationTeamMembersKey,
								   nil];
		
		dictionary = [CDOHResource mergeSubclassDictionary:localDict withSuperclassDictionary:superDict];
	});
	
	return dictionary;
}

// Difference between +firstTestDictionary and +secondTestDictionary is only the
// value for the kCDOHOrganizationTeamIdentifierKey key.
+ (NSDictionary *)secondTestDictionary
{
	static NSDictionary *dictionary = nil;
	
	static dispatch_once_t secondTestDictionaryToken;
	dispatch_once(&secondTestDictionaryToken, ^{
		NSDictionary *superDict = [super secondTestDictionary];
		NSDictionary *localDict = [[NSDictionary alloc] initWithObjectsAndKeys:
								   CDOHTestNumFromUInteger(4321),		kCDOHOrganizationTeamIdentifierKey,
								   @"A test team",						kCDOHOrganizationTeamNameKey,
								   kCDOHOrganizationTeamPermissionPull,	kCDOHOrganizationTeamPermissionKey,
								   CDOHTestNumFromUInteger(10),			kCDOHOrganizationTeamRepositoriesKey,
								   CDOHTestNumFromUInteger(321),		kCDOHOrganizationTeamMembersKey,
								   nil];
		
		dictionary = [CDOHResource mergeSubclassDictionary:localDict withSuperclassDictionary:superDict];
	});
	
	return dictionary;
}


#pragma mark - Test Resource Equality and Hash
// Adds tests of the `isEqualToOrganizationTeam:` method.
- (void)testResourceEquality
{
	[super testResourceEquality];
	
	CDOHOrganizationTeam *resource_1 = (CDOHOrganizationTeam *)[self firstTestResource];
	CDOHOrganizationTeam *resource_2 = (CDOHOrganizationTeam *)[self firstTestResource];
	CDOHOrganizationTeam *resource_1Copy = [resource_1 copy];
	
	STAssertTrue([resource_1 isEqualToOrganizationTeam:resource_2],			@"Two teams ('%@' and '%@') intialized using the same dictionary should be equal (using isEqualToOrganizationTeam:)", resource_1, resource_2);
	STAssertTrue([resource_1 isEqualToOrganizationTeam:resource_1Copy],		@"A copy of a team (%@) should be equal to the original (%@). (Using isEqualToOrganizationTeam:)", resource_1Copy, resource_1);
}

// Adds tests of the `isEqualToOrganizationTeam:` method.
- (void)testResourceInequality
{
	[super testResourceInequality];
	
	CDOHOrganizationTeam *resource_1 = (CDOHOrganizationTeam *)[self firstTestResource];
	CDOHOrganizationTeam *differentResource = (CDOHOrganizationTeam *)[self secondTestResource];
	
	STAssertFalse([resource_1 isEqualToOrganizationTeam:differentResource],	@"Two different teams ('%@' and '%@') should NOT be equal (using isEqualToOrganizationTeam:)", resource_1, differentResource);
}


#pragma mark - Test Dictionary Encoding and Decoding
// Adds tests of the properties special to a organization team.
- (void)testResourceDecodeFromDictionary
{
	[super testResourceDecodeFromDictionary];
	
	NSDictionary *testDict = [[self class] firstTestDictionary];
	CDOHOrganizationTeam *team = [[CDOHOrganizationTeam alloc] initWithJSONDictionary:testDict];
	
	STAssertEquals(team.identifier,		[[testDict objectForKey:kCDOHOrganizationTeamIdentifierKey] unsignedIntegerValue], @"Team identifier should be set from dictionary");
	STAssertEquals(team.repositories,	[[testDict objectForKey:kCDOHOrganizationTeamRepositoriesKey] unsignedIntegerValue], @"Team repositories count should be set from dictionary");
	STAssertEquals(team.members,		[[testDict objectForKey:kCDOHOrganizationTeamMembersKey] unsignedIntegerValue], @"Team members count should be set from dictionary");
	
	STAssertEqualObjects(team.name, [testDict objectForKey:kCDOHOrganizationTeamNameKey], @"Team name should be set from dictionary");
	STAssertEqualObjects(team.permission, [testDict objectForKey:kCDOHOrganizationTeamPermissionKey], @"Team permission should be set from dictionary");
}


@end
