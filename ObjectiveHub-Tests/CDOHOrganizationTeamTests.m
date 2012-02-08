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

- (void)testEquality
{
	NSDictionary *testDict1 = [NSDictionary dictionaryWithObjectsAndKeys:
							  [NSNumber numberWithUnsignedInteger:1234],	kCDOHOrganizationTeamIdentifierKey,
							  @"A test team",								kCDOHOrganizationTeamNameKey,
							  kCDOHOrganizationTeamPermissionPull,			kCDOHOrganizationTeamPermissionKey,
							  [NSNumber numberWithUnsignedInteger:10],		kCDOHOrganizationTeamRepositoriesKey,
							  [NSNumber numberWithUnsignedInteger:321],		kCDOHOrganizationTeamMembersKey,
							  nil];
	// Exactly as testDict1 except the kCDOHOrganizationTeamIdentifierKey is
	// different and as such should not be equal. (ID: "1234" vs. "9876".)
	NSDictionary *testDict2 = [NSDictionary dictionaryWithObjectsAndKeys:
							  [NSNumber numberWithUnsignedInteger:9876],	kCDOHOrganizationTeamIdentifierKey,
							  @"A test team",								kCDOHOrganizationTeamNameKey,
							  kCDOHOrganizationTeamPermissionPull,			kCDOHOrganizationTeamPermissionKey,
							  [NSNumber numberWithUnsignedInteger:10],		kCDOHOrganizationTeamRepositoriesKey,
							  [NSNumber numberWithUnsignedInteger:321],		kCDOHOrganizationTeamMembersKey,
							  nil];
	// Completely different than testDict1 except the
	// kCDOHOrganizationTeamIdentifierKey which is the same. As such the teams
	// should be equal.
	NSDictionary *testDict3 = [NSDictionary dictionaryWithObjectsAndKeys:
							   [NSNumber numberWithUnsignedInteger:1234],	kCDOHOrganizationTeamIdentifierKey,
							   @"New name for the team",					kCDOHOrganizationTeamNameKey,
							   kCDOHOrganizationTeamPermissionPush,			kCDOHOrganizationTeamPermissionKey,
							   [NSNumber numberWithUnsignedInteger:999],	kCDOHOrganizationTeamRepositoriesKey,
							   [NSNumber numberWithUnsignedInteger:345],	kCDOHOrganizationTeamMembersKey,
							   nil];
	
	CDOHOrganizationTeam *team1 = [[CDOHOrganizationTeam alloc] initWithDictionary:testDict1];
	CDOHOrganizationTeam *team2 = [[CDOHOrganizationTeam alloc] initWithDictionary:testDict1];
	CDOHOrganizationTeam *team1Copy = [team1 copy];
	
	CDOHOrganizationTeam *teamEqual = [[CDOHOrganizationTeam alloc] initWithDictionary:testDict3];
	
	CDOHOrganizationTeam *differentTeam = [[CDOHOrganizationTeam alloc] initWithDictionary:testDict2];
	NSObject *differentObject = [[NSObject alloc] init];
	
	
	STAssertTrue([team1 isEqual:team2],								@"Two teams ('%@' and '%@') intialized using the same dictionary should be equal (using isEqual:)", team1, team2);
	STAssertTrue([team1 isEqualToOrganizationTeam:team2],			@"Two teams ('%@' and '%@') intialized using the same dictionary should be equal (using isEqualToOrganizationTeam:)", team1, team2);
	
	STAssertTrue(team1 == team1Copy,								@"A copy of a team (%@) should be the same object as the original (%@)", team1Copy, team1);
	STAssertTrue([team1 isEqual:team1Copy],							@"A copy of a team (%@) should be equal to the original (%@). (Using isEqual:)", team1Copy, team1);
	STAssertTrue([team1 isEqualToOrganizationTeam:team1Copy],		@"A copy of a team (%@) should be equal to the original (%@). (Using isEqualToOrganizationTeam:)", team1Copy, team1);
	
	STAssertTrue([team1 isEqual:teamEqual],							@"Two teams ('%@' and '%@') with the same identifier but otherwise completely different should be equal", team1, teamEqual);
	
	STAssertFalse(team1 == differentTeam,							@"Two different teams ('%@' and '%@') should NOT be the same object", team1, differentTeam);
	STAssertFalse([team1 isEqual:differentTeam],					@"Two different teams ('%@' and '%@') should NOT be equal (using isEqual:)", team1, differentTeam);
	STAssertFalse([team1 isEqualToOrganizationTeam:differentTeam],	@"Two different teams ('%@' and '%@') should NOT be equal (using isEqualToOrganizationTeam:)", team1, differentTeam);
	STAssertFalse([team1 isEqual:differentObject],					@"A team object (%@) should not be equal to a object (%@) of any other class than 'CDOHOrganizationTeam'", team1, differentObject);
}

- (void)testCreateNewFromDictionary
{
	NSDictionary *testDict = [NSDictionary dictionaryWithObjectsAndKeys:
							  [NSNumber numberWithUnsignedInteger:1234],	kCDOHOrganizationTeamIdentifierKey,
							  @"A test team",								kCDOHOrganizationTeamNameKey,
							  kCDOHOrganizationTeamPermissionPull,			kCDOHOrganizationTeamPermissionKey,
							  [NSNumber numberWithUnsignedInteger:10],		kCDOHOrganizationTeamRepositoriesKey,
							  [NSNumber numberWithUnsignedInteger:321],		kCDOHOrganizationTeamMembersKey,
							  nil];
	
	CDOHOrganizationTeam *team = [[CDOHOrganizationTeam alloc] initWithDictionary:testDict];
	
	STAssertEquals(team.identifier,		[[testDict objectForKey:kCDOHOrganizationTeamIdentifierKey] unsignedIntegerValue], @"Team identifier should be set from dictionary");
	STAssertEquals(team.repositories,	[[testDict objectForKey:kCDOHOrganizationTeamRepositoriesKey] unsignedIntegerValue], @"Team repositories count should be set from dictionary");
	STAssertEquals(team.members,		[[testDict objectForKey:kCDOHOrganizationTeamMembersKey] unsignedIntegerValue], @"Team members count should be set from dictionary");
	
	STAssertEqualObjects(team.name, [testDict objectForKey:kCDOHOrganizationTeamNameKey], @"Team name should be set from dictionary");
	STAssertEqualObjects(team.permission, [testDict objectForKey:kCDOHOrganizationTeamPermissionKey], @"Team permission should be set from dictionary");
}

- (void)testEncodeAsDictionary
{
	NSDictionary *testDict = [NSDictionary dictionaryWithObjectsAndKeys:
							  [NSNumber numberWithUnsignedInteger:1234],	kCDOHOrganizationTeamIdentifierKey,
							  @"A test team",								kCDOHOrganizationTeamNameKey,
							  kCDOHOrganizationTeamPermissionAdminister,	kCDOHOrganizationTeamPermissionKey,
							  [NSNumber numberWithUnsignedInteger:10],		kCDOHOrganizationTeamRepositoriesKey,
							  [NSNumber numberWithUnsignedInteger:321],		kCDOHOrganizationTeamMembersKey,
							  nil];
	
	CDOHOrganizationTeam *team = [[CDOHOrganizationTeam alloc] initWithDictionary:testDict];
	NSDictionary *encodedTeamDict = [team encodeAsDictionary];
	
	STAssertEqualObjects(testDict, encodedTeamDict, @"Creating a organization team from a dictionary and then encoding it as a dictionary should yeild an identical dictionary");
}

@end
