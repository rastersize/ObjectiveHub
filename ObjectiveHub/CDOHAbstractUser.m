//
//  CDOHAbstractUser.h
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

#import "CDOHAbstractUser.h"
#import "CDOHUser.h"
#import "CDOHOrganization.h"
#import "CDOHResourcePrivate.h"


#pragma mark NSCoding and GitHub JSON Keys
NSString *const kCDOHUserLoginKey				= @"login";
NSString *const kCDOHUserIdentifierKey			= @"id";
NSString *const kCDOHUserAvatarURLKey			= @"avatar_url";
NSString *const kCDOHUserGravatarIDKey			= @"gravatar_id";
NSString *const kCDOHUserNameKey				= @"name";
NSString *const kCDOHUserCompanyKey				= @"company";
NSString *const kCDOHUserBlogKey				= @"blog";
NSString *const kCDOHUserLocationKey			= @"location";
NSString *const kCDOHUserEmailKey				= @"email";
NSString *const kCDOHUserPublicReposKey			= @"public_repos";
NSString *const kCDOHUserPublicGistsKey			= @"public_gists";
NSString *const kCDOHUserFollowersKey			= @"followers";
NSString *const kCDOHUserFollowingKey			= @"following";
NSString *const kCDOHUserHTMLURLKey				= @"html_url";
NSString *const kCDOHUserCreatedAtKey			= @"created_at";
NSString *const kCDOHUserTypeKey				= @"type";
NSString *const kCDOHUserTotalPrivateReposKey	= @"total_private_repos";
NSString *const kCDOHUserOwnedPrivateReposKey	= @"owned_private_repos";
NSString *const kCDOHUserPrivateGistsKey		= @"private_gists";
NSString *const kCDOHUserDiskUsageKey			= @"disk_usage";
NSString *const kCDOHUserCollaboratorsKey		= @"collaborators";
NSString *const kCDOHUserPlanKey				= @"plan";


#pragma mark - User Type Keys
NSString *const KCDOHUserTypeUserKey			= @"User";
NSString *const kCDOHUserTypeOrganizationKey	= @"Organization";


#pragma mark - CDOHAbstractUser Implemenation
@implementation CDOHAbstractUser

+ (instancetype)resourceWithJSONDictionary:(NSDictionary *)jsonDictionary inManagedObjectContex:(NSManagedObjectContext *)managedObjectContext
{
	CDOHAbstractUser *user = nil;
	Class userTypeClass = nil;
	
	NSString *type = [jsonDictionary objectForKey:kCDOHUserTypeKey];
	if ([type isEqual:KCDOHUserTypeUserKey]) {
		userTypeClass = [CDOHUser class];
	} else if ([type isEqual:kCDOHUserTypeOrganizationKey]) {
		userTypeClass = [CDOHOrganization class];
	}
	NSAssert(userTypeClass != nil, @"Unkown user type '%@'", type);
	
	user = [userTypeClass insertInManagedObjectContext:managedObjectContext];
	[user setValuesForAttributesWithJSONDictionary:jsonDictionary];
	[user setValuesForRelationshipsWithJSONDictionary:jsonDictionary];
	
	return user;
}

@end
