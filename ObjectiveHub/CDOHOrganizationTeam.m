//
//  CDOHOrganizationTeam.m
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

#import "CDOHOrganizationTeam.h"
#import "CDOHResourcePrivate.h"


#pragma mark Dictionary Representation Keys
NSString *const kCDOHOrganizationTeamIdentifierKey		= @"id";
NSString *const kCDOHOrganizationTeamNameKey			= @"name";
NSString *const kCDOHOrganizationTeamPermissionKey		= @"permission";
NSString *const kCDOHOrganizationTeamMembersKey			= @"members_count";
NSString *const kCDOHOrganizationTeamRepositoriesKey	= @"repos_count";


#pragma mark - Team Permission String Constants
NSString *const kCDOHOrganizationTeamPermissionPull			= @"pull";
NSString *const kCDOHOrganizationTeamPermissionPush			= @"push";
NSString *const kCDOHOrganizationTeamPermissionAdminister	= @"admin";


#pragma mark - CDOHOrganizationTeam Implementation
@implementation CDOHOrganizationTeam

#pragma mark - Synthesization
@synthesize identifier = _identifier;
@synthesize name = _name;
@synthesize permission = _permission;
@synthesize members = _members;
@synthesize repositories = _repositories;


#pragma mark - Initializing a CDOHOrganizationTeam Instance
- (id)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super initWithDictionary:dictionary];
	if (self) {
		// Unsigned integers
		_identifier		= [[dictionary objectForKey:kCDOHOrganizationTeamIdentifierKey] unsignedIntegerValue];
		_members		= [[dictionary objectForKey:kCDOHOrganizationTeamMembersKey] unsignedIntegerValue];
		_repositories	= [[dictionary objectForKey:kCDOHOrganizationTeamRepositoriesKey] unsignedIntegerValue];
		
		// Strings
		_name		= [[dictionary objectForKey:kCDOHOrganizationTeamNameKey] copy];
		_permission	= [[dictionary objectForKey:kCDOHOrganizationTeamPermissionKey] copy];
	}
	
	return self;
}


#pragma mark - Encoding Resources
- (NSDictionary *)encodeAsDictionary
{
	NSDictionary *finalDictionary = nil;
	NSDictionary *superDictionary = [super encodeAsDictionary];
	
	NSNumber *identifierNum = [[NSNumber alloc] initWithUnsignedInteger:_identifier];
	NSNumber *membersNum = [[NSNumber alloc] initWithUnsignedInteger:_members];
	NSNumber *repositoriesNum = [[NSNumber alloc] initWithUnsignedInteger:_repositories];
	
	NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
								identifierNum,		kCDOHOrganizationTeamIdentifierKey,
								_name,				kCDOHOrganizationTeamNameKey,
								_permission,		kCDOHOrganizationTeamPermissionKey,
								membersNum,			kCDOHOrganizationTeamMembersKey,
								repositoriesNum,	kCDOHOrganizationTeamRepositoriesKey,
								nil];
	
	finalDictionary = [CDOHResource mergeSubclassDictionary:dictionary withSiperclassDictionary:superDictionary];
	return finalDictionary;
}


#pragma mark - Describing an Organization Team Object
- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@: %p { id = %lu, name = %@ }>",
			[self class],
			self,
			_identifier,
			_name];
}


#pragma mark - Identifying and Comparing Organization Teams
- (BOOL)isEqual:(id)object
{
	if (object == self) {
		return YES;
	}
	if (!object || ![object isKindOfClass:[self class]]) {
		return NO;
	}
	
	return [self isEqualToOrganizationTeam:object];
}

- (BOOL)isEqualToOrganizationTeam:(CDOHOrganizationTeam *)aTeam
{
	if (aTeam == self) {
		return YES;
	}
	
	return (_identifier == aTeam.identifier);
}

- (NSUInteger)hash
{
	return _identifier;
}



@end
