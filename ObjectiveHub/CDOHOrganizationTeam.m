//
//  CDOHOrganizationTeam.h
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


#pragma mark JSON Dictionary Keys
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

#pragma mark - Properties
@synthesize identifier = _identifier;
@synthesize name = _name;
@synthesize permission = _permission;
@synthesize membersCount = _membersCount;
@synthesize repositoriesCount = _repositoriesCount;


#pragma mark - Creating and Initializing Resources
- (id)initWithJSONDictionary:(NSDictionary *)dictionary
{
	self = [super initWithJSONDictionary:dictionary];
	if (self) {
		// Unsigned integers
		_identifier			= [dictionary cdoh_unsignedIntegerForKey:kCDOHOrganizationTeamIdentifierKey];
		_membersCount		= [dictionary cdoh_unsignedIntegerForKey:kCDOHOrganizationTeamMembersKey];
		_repositoriesCount	= [dictionary cdoh_unsignedIntegerForKey:kCDOHOrganizationTeamRepositoriesKey];
		
		// Strings
		_name		= [[dictionary cdoh_objectOrNilForKey:kCDOHOrganizationTeamNameKey] copy];
		_permission	= [[dictionary cdoh_objectOrNilForKey:kCDOHOrganizationTeamPermissionKey] copy];
	}
	
	return self;
}


#pragma mark - Encoding
- (void)encodeWithJSONDictionary:(NSMutableDictionary *)jsonDictionary
{
	[super encodeWithJSONDictionary:jsonDictionary];
	
	[jsonDictionary cdoh_setObject:_name forKey:kCDOHOrganizationTeamNameKey];
	[jsonDictionary cdoh_setObject:_permission forKey:kCDOHOrganizationTeamPermissionKey];
	
	[jsonDictionary cdoh_setUnsignedInteger:_identifier forKey:kCDOHOrganizationTeamIdentifierKey];
	[jsonDictionary cdoh_setUnsignedInteger:_membersCount forKey:kCDOHOrganizationTeamMembersKey];
	[jsonDictionary cdoh_setUnsignedInteger:_repositoriesCount forKey:kCDOHOrganizationTeamRepositoriesKey];
}


#pragma mark -
+ (void)JSONKeyToPropertyNameDictionary:(NSMutableDictionary *)dictionary
{
	[super JSONKeyToPropertyNameDictionary:dictionary];
	
	CDOHSetPropertyForJSONKey(name,					kCDOHOrganizationTeamNameKey, dictionary);
	CDOHSetPropertyForJSONKey(identifier,			kCDOHOrganizationTeamIdentifierKey, dictionary);
	CDOHSetPropertyForJSONKey(permission,			kCDOHOrganizationTeamPermissionKey, dictionary);
	CDOHSetPropertyForJSONKey(membersCount,			kCDOHOrganizationTeamMembersKey, dictionary);
	CDOHSetPropertyForJSONKey(repositoriesCount,	kCDOHOrganizationTeamRepositoriesKey, dictionary);
}

+ (NSDictionary *)JSONKeyToPropertyName
{
	static NSDictionary *JSONKeyToPropertyName = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
		[CDOHOrganizationTeam JSONKeyToPropertyNameDictionary:dictionary];
		JSONKeyToPropertyName = [dictionary copy];
	});
	return JSONKeyToPropertyName;
}


#pragma mark - Describing an Organization Team Object
- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@: %p { id = %lu, name = %@ }>",
			[self class],
			self,
			self.identifier,
			self.name];
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
	
	return (self.identifier == aTeam.identifier);
}

- (NSUInteger)hash
{
	return self.identifier;
}


@end
