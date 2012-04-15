//
//  CDOHUser.h
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

#import "CDOHUser.h"
#import "CDOHResourcePrivate.h"

#import "CDOHPlan.h"


#pragma mark NSCoding and GitHub JSON Keys
NSString *const kCDOHUserLoginKey				= @"login";
NSString *const kCDOHUserIdentifierKey			= @"id";
NSString *const kCDOHUserAvatarURLKey			= @"avatar_url";
NSString *const kCDOHUserGravatarIdentifierKey	= @"gravatar_id";
NSString *const kCDOHUserNameKey				= @"name";
NSString *const kCDOHUserCompanyKey				= @"company";
NSString *const kCDOHUserBlogURLKey				= @"blog";
NSString *const kCDOHUserLocationKey			= @"location";
NSString *const kCDOHUserEmailKey				= @"email";
NSString *const kCDOHUserPublicReposKey			= @"public_repos";
NSString *const kCDOHUserPublicGistsKey			= @"public_gists";
NSString *const kCDOHUserFollowersKey			= @"followers";
NSString *const kCDOHUserFollowingKey			= @"following";
NSString *const kCDOHUserProfileURLKey			= @"html_url";
NSString *const kCDOHUserCreatedAtKey			= @"created_at";
NSString *const kCDOHUserTypeKey				= @"type";
NSString *const kCDOHUserPrivateReposKey		= @"total_private_repos";
NSString *const kCDOHUserPrivateReposOwnedKey	= @"owned_private_repos";
NSString *const kCDOHUserPrivateGistsKey		= @"private_gists";
NSString *const kCDOHUserDiskUsageKey			= @"disk_usage";
NSString *const kCDOHUserCollaboratorsKey		= @"collaborators";
NSString *const kCDOHUserPlanKey				= @"plan";
NSString *const kCDOHUserHireableKey			= @"hireable";
NSString *const kCDOHUserBiographyKey			= @"bio";


#pragma mark - User Type Keys
NSString *const kCDOHUserTypePersonKey			= @"User";
NSString *const kCDOHUserTypeOrganizationKey	= @"Organization";


#pragma mark - CDOHUser Private Interface
@interface CDOHUser (/*Private*/)
#pragma mark - User Type Helpers
+ (CDOHUserType)typeFromString:(NSString *)string;
+ (NSString *)stringFromType:(CDOHUserType)type;
@end


#pragma mark - CDOHAbstractUser Implemenation
@implementation CDOHUser

#pragma mark - Properties
@synthesize login = _login;
@synthesize identifier = _identifier;
@synthesize avatarURL = _avatarURL;
@synthesize gravatarIdentifier = _gravatarIdentifier;
@synthesize name = _name;
@synthesize company = _company;
@synthesize blogURL = _blogURL;
@synthesize location = _location;
@synthesize email = _email;
@synthesize publicGistsCount = _publicGistsCount;
@synthesize publicRepositoriesCount = _publicRepositoriesCount;
@synthesize privateGistsCount = _privateGistsCount;
@synthesize privateRepositoriesCount = _privateRepositoriesCount;
@synthesize privateRepositoriesOwnedCount = _privateRepositoriesOwnedCount;
@synthesize followersCount = _followersCount;
@synthesize followingCount = _followingCount;
@synthesize profileURL = _profileURL;
@synthesize createdAt = _createdAt;
@synthesize type = _type;
@synthesize diskUsage = _diskUsage;
@synthesize collaboratorsCount = _collaboratorsCount;
@synthesize plan = _plan;
@synthesize hireable = _hireable;
@synthesize biography = _biography;


#pragma mark - User Type Helpers
+ (CDOHUserType)typeFromString:(NSString *)string
{
	CDOHUserType type = kCDOHUserTypeUnkown;
	if ([string isEqualToString:kCDOHUserTypePersonKey]) {
		type = kCDOHUserTypePerson;
	} else if ([string isEqualToString:kCDOHUserTypeOrganizationKey]) {
		type = kCDOHUserTypeOrganization;
	}
	
	return type;
}

+ (NSString *)stringFromType:(CDOHUserType)type
{
	NSString *string = nil;
	switch (type) {
		case kCDOHUserTypePerson:
			string = kCDOHUserTypePersonKey;
			break;
			
		case kCDOHUserTypeOrganization:
			string = kCDOHUserTypeOrganizationKey;
			break;
			
		case kCDOHUserTypeUnkown:
		default:
			string = @"Unkown";
			break;
	}
	return string;
}


#pragma mark - Creating and Initializing Resources
- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary
{
	self = [super initWithJSONDictionary:jsonDictionary];
	if (self) {
		// Strings
		_login = [[jsonDictionary cdoh_objectOrNilForKey:kCDOHUserLoginKey] copy];
		_gravatarIdentifier = [[jsonDictionary cdoh_objectOrNilForKey:kCDOHUserGravatarIdentifierKey] copy];
		_name = [[jsonDictionary cdoh_objectOrNilForKey:kCDOHUserNameKey] copy];
		_company = [[jsonDictionary cdoh_objectOrNilForKey:kCDOHUserCompanyKey] copy];
		_email = [[jsonDictionary cdoh_objectOrNilForKey:kCDOHUserEmailKey] copy];
		_biography = [[jsonDictionary cdoh_objectOrNilForKey:kCDOHUserBiographyKey] copy];
		_location = [[jsonDictionary cdoh_objectOrNilForKey:kCDOHUserLocationKey] copy];
		
		// URLs
		_avatarURL = [jsonDictionary cdoh_URLForKey:kCDOHUserAvatarURLKey];
		_profileURL = [jsonDictionary cdoh_URLForKey:kCDOHUserProfileURLKey];
		_blogURL = [jsonDictionary cdoh_URLForKey:kCDOHUserBlogURLKey];
		
		// Dates
		_createdAt = [jsonDictionary cdoh_dateForKey:kCDOHUserCreatedAtKey];
		
		// Unsigned Integers
		_identifier = [jsonDictionary cdoh_unsignedIntegerForKey:kCDOHUserIdentifierKey];
		_publicGistsCount = [jsonDictionary cdoh_unsignedIntegerForKey:kCDOHUserPublicGistsKey];
		_publicRepositoriesCount = [jsonDictionary cdoh_unsignedIntegerForKey:kCDOHUserPublicReposKey];
		_privateGistsCount = [jsonDictionary cdoh_unsignedIntegerForKey:kCDOHUserPrivateGistsKey];
		_privateRepositoriesCount = [jsonDictionary cdoh_unsignedIntegerForKey:kCDOHUserPrivateReposKey];
		_privateRepositoriesOwnedCount = [jsonDictionary cdoh_unsignedIntegerForKey:kCDOHUserPrivateReposOwnedKey];
		_followersCount = [jsonDictionary cdoh_unsignedIntegerForKey:kCDOHUserFollowersKey];
		_followingCount = [jsonDictionary cdoh_unsignedIntegerForKey:kCDOHUserFollowingKey];
		_diskUsage = [jsonDictionary cdoh_unsignedIntegerForKey:kCDOHUserDiskUsageKey];
		_collaboratorsCount = [jsonDictionary cdoh_unsignedIntegerForKey:kCDOHUserCollaboratorsKey];
		
		// Booleans
		_hireable = [jsonDictionary cdoh_boolForKey:kCDOHUserHireableKey];
		
		// Resources
		_plan = [jsonDictionary cdoh_resourceForKey:kCDOHUserPlanKey ofClass:[CDOHPlan class]];
		
		// Special logic
		_type = [[self class] typeFromString:[jsonDictionary cdoh_objectOrNilForKey:kCDOHUserTypeKey]];
	}
	
	return self;
}


#pragma mark - Encoding
- (void)encodeWithJSONDictionary:(NSMutableDictionary *)jsonDictionary
{
	[super encodeWithJSONDictionary:jsonDictionary];
	
	// Strings
	[jsonDictionary cdoh_setObject:_login forKey:kCDOHUserLoginKey];
	[jsonDictionary cdoh_setObject:_gravatarIdentifier forKey:kCDOHUserGravatarIdentifierKey];
	[jsonDictionary cdoh_setObject:_name forKey:kCDOHUserNameKey];
	[jsonDictionary cdoh_setObject:_company forKey:kCDOHUserCompanyKey];
	[jsonDictionary cdoh_setObject:_email forKey:kCDOHUserEmailKey];
	[jsonDictionary cdoh_setObject:_location forKey:kCDOHUserLocationKey];
	
	// URLs
	[jsonDictionary cdoh_encodeAndSetURL:_avatarURL forKey:kCDOHUserAvatarURLKey];
	[jsonDictionary cdoh_encodeAndSetURL:_profileURL forKey:kCDOHUserProfileURLKey];
	[jsonDictionary cdoh_encodeAndSetURL:_blogURL forKey:kCDOHUserBlogURLKey];
	
	// Dates
	[jsonDictionary cdoh_encodeAndSetDate:_createdAt forKey:kCDOHUserCreatedAtKey];
	
	// Unsigned integers
	[jsonDictionary cdoh_setUnsignedInteger:_identifier forKey:kCDOHUserIdentifierKey];
	[jsonDictionary cdoh_setUnsignedInteger:_publicGistsCount forKey:kCDOHUserPublicGistsKey];
	[jsonDictionary cdoh_setUnsignedInteger:_publicRepositoriesCount forKey:kCDOHUserPublicReposKey];
	[jsonDictionary cdoh_setUnsignedInteger:_followersCount forKey:kCDOHUserFollowersKey];
	[jsonDictionary cdoh_setUnsignedInteger:_followingCount forKey:kCDOHUserFollowingKey];

	
	// Special logic
	NSString *typeString = [[self class] stringFromType:_type];
	[jsonDictionary cdoh_setObject:typeString forKey:kCDOHUserTypeKey];
	
	if (_type == kCDOHUserTypePerson) {
		[jsonDictionary cdoh_setBool:_hireable forKey:kCDOHUserHireableKey];
		[jsonDictionary cdoh_setObject:_biography forKey:kCDOHUserBiographyKey];
	}
	
	if ([self isAuthenticated]) {
		[jsonDictionary cdoh_encodeAndSetResource:_plan forKey:kCDOHUserPlanKey];
		[jsonDictionary cdoh_setUnsignedInteger:_diskUsage forKey:kCDOHUserDiskUsageKey];
		[jsonDictionary cdoh_setUnsignedInteger:_collaboratorsCount forKey:kCDOHUserCollaboratorsKey];
		[jsonDictionary cdoh_setUnsignedInteger:_privateGistsCount forKey:kCDOHUserPrivateGistsKey];
		[jsonDictionary cdoh_setUnsignedInteger:_privateRepositoriesCount forKey:kCDOHUserPrivateReposKey];
		[jsonDictionary cdoh_setUnsignedInteger:_privateRepositoriesOwnedCount forKey:kCDOHUserPrivateReposOwnedKey];
	}
}


#pragma mark - 
+ (void)JSONKeyToPropertyNameDictionary:(NSMutableDictionary *)dictionary
{
	[super JSONKeyToPropertyNameDictionary:dictionary];
	
	CDOHSetPropertyForJSONKey(login,							kCDOHUserLoginKey, dictionary);
	CDOHSetPropertyForJSONKey(identifier,						kCDOHUserIdentifierKey, dictionary);
	CDOHSetPropertyForJSONKey(type,								kCDOHUserTypeKey, dictionary);
	CDOHSetPropertyForJSONKey(profileURL,						kCDOHUserProfileURLKey, dictionary);
	CDOHSetPropertyForJSONKey(publicRepositoriesCount,			kCDOHUserPublicReposKey, dictionary);
	CDOHSetPropertyForJSONKey(publicGistsCount,					kCDOHUserPublicGistsKey, dictionary);
	CDOHSetPropertyForJSONKey(privateRepositoriesCount,			kCDOHUserPrivateReposKey, dictionary);
	CDOHSetPropertyForJSONKey(privateRepositoriesOwnedCount,	kCDOHUserPrivateReposOwnedKey, dictionary);
	CDOHSetPropertyForJSONKey(privateGistsCount,				kCDOHUserPrivateGistsKey, dictionary);
	CDOHSetPropertyForJSONKey(followersCount,					kCDOHUserFollowersKey, dictionary);
	CDOHSetPropertyForJSONKey(followingCount,					kCDOHUserFollowingKey, dictionary);
	CDOHSetPropertyForJSONKey(collaboratorsCount,				kCDOHUserCollaboratorsKey, dictionary);
	CDOHSetPropertyForJSONKey(createdAt,						kCDOHUserCreatedAtKey, dictionary);
	CDOHSetPropertyForJSONKey(diskUsage,						kCDOHUserDiskUsageKey, dictionary);
	CDOHSetPropertyForJSONKey(plan,								kCDOHUserPlanKey, dictionary);
	CDOHSetPropertyForJSONKey(name,								kCDOHUserNameKey, dictionary);
	CDOHSetPropertyForJSONKey(company,							kCDOHUserCompanyKey, dictionary);
	CDOHSetPropertyForJSONKey(email,							kCDOHUserEmailKey, dictionary);
	CDOHSetPropertyForJSONKey(location,							kCDOHUserLocationKey, dictionary);
	CDOHSetPropertyForJSONKey(blogURL,							kCDOHUserBlogURLKey, dictionary);
	CDOHSetPropertyForJSONKey(biography,						kCDOHUserBiographyKey, dictionary);
	CDOHSetPropertyForJSONKey(isHireable,						kCDOHUserHireableKey, dictionary);
	CDOHSetPropertyForJSONKey(avatarURL,						kCDOHUserAvatarURLKey, dictionary);
	CDOHSetPropertyForJSONKey(gravatarIdentifier,				kCDOHUserGravatarIdentifierKey, dictionary);
}

+ (NSDictionary *)JSONKeyToPropertyName
{
	static NSDictionary *JSONKeyToPropertyName = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
		[CDOHUser JSONKeyToPropertyNameDictionary:dictionary];
		JSONKeyToPropertyName = [dictionary copy];
	});
	return JSONKeyToPropertyName;
}


#pragma mark - System Information
- (BOOL)isAuthenticated
{
	return (self.plan.name != nil ||
			self.diskUsage != 0 ||
			self.collaboratorsCount != 0 ||
			self.privateRepositoriesCount != 0 ||
			self.privateRepositoriesOwnedCount != 0 ||
			self.privateGistsCount != 0);
}


#pragma mark - Identifying and Comparing Abstract Users
- (BOOL)isEqual:(id)other
{
	if (other == self) {
		return YES;
	}
	if (!other || ![other isKindOfClass:[self class]]) {
		return NO;
	}
	return [self isEqualToUser:other];
}

- (BOOL)isEqualToUser:(CDOHUser *)aUser
{
	if (aUser == self) {
		return YES;
	}
	
	return (self.identifier == aUser.identifier && self.type == aUser.type);
}

- (NSUInteger)hash
{
	return self.identifier;
}


#pragma mark - Describing an Abstract User Object
- (NSString *)description
{	
	return [NSString stringWithFormat:@"<%@: %p { id = %lu, login = %@, type = %@, is authed = %@ }>",
			[self class],
			self,
			self.identifier,
			self.login,
			self.type,
			([self isAuthenticated] ? @"YES" : @"NO")];
}



@end
