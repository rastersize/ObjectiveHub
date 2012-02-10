//
//  CDOHAbstractUserTests.m
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

#import "CDOHAbstractUserTests.h"
#import "CDOHAbstractUser.h"
#import "CDOHPlan.h"


@implementation CDOHAbstractUserTests

#pragma mark - Tested Class
+ (Class)testedClass
{
	return [CDOHAbstractUser class];
}


#pragma mark - Test Dictionaries
// The user should be identified as an authenticated user
+ (NSDictionary *)firstTestDictionary
{
	static NSDictionary *dictionary = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSDictionary *superDict = [super firstTestDictionary];
		NSDictionary *planDict = [[NSDictionary alloc] initWithObjectsAndKeys:
								  @"small",								kCDOHPlanNameKey,
								  CDOHTestNumFromUInteger(1228800),		kCDOHPlanSpaceKey,
								  CDOHTestNumFromUInteger(5),			kCDOHPlanCollaboratorsKey,
								  CDOHTestNumFromUInteger(10),			kCDOHPlanPrivateRepositoriesKey,
								  nil];
		
		NSDictionary *localDict = [[NSDictionary alloc] initWithObjectsAndKeys:
								   CDOHTestNumFromUInteger(583231),		kCDOHUserIDKey,
								   @"octocat",							kCDOHUserLoginKey,
								   @"The Octocat",						kCDOHUserNameKey,
								   @"GitHub",							kCDOHUserCompanyKey,
								   @"San Francisco",					kCDOHUserLocationKey,
								   @"octocat@github.com",				kCDOHUserEmailKey,
								   @"User",								kCDOHUserTypeKey,
								   @"2011-01-25T18:44:36Z",				kCDOHUserCreatedAtKey,
								   @"http://www.github.com/blog",		kCDOHUserBlogKey,
								   @"https://github.com/octocat",		kCDOHUserHTMLURLKey,
								   @"https://secure.gravatar.com/avatar/7ad39074b0584bc555d0417ae3e7d974?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-140.png", kCDOHUserAvatarURLKey,
								   @"7ad39074b0584bc555d0417ae3e7d974", kCDOHUserGravatarIDKey,
								   CDOHTestNumFromUInteger(2),			kCDOHUserPublicReposKey,
								   CDOHTestNumFromUInteger(4),			kCDOHUserPublicGistsKey,
								   CDOHTestNumFromUInteger(120),		kCDOHUserFollowersKey,
								   CDOHTestNumFromUInteger(0),			kCDOHUserFollowingKey,
								   CDOHTestNumFromUInteger(5),			kCDOHUserTotalPrivateReposKey,
								   CDOHTestNumFromUInteger(1),			kCDOHUserOwnedPrivateReposKey,
								   CDOHTestNumFromUInteger(103),		kCDOHUserPrivateGistsKey,
								   CDOHTestNumFromUInteger(5),			kCDOHUserDiskUsageKey,
								   CDOHTestNumFromUInteger(5),			kCDOHUserCollaboratorsKey,
								   [NSNumber numberWithBool:YES],		kCDOHUserAuthenticatedKey,
								   planDict,							kCDOHUserPlanKey,
								   nil];
		
		dictionary = [self mergeOwnTestDictionary:localDict withSuperDictionary:superDict];
	});
	
	return dictionary;
}

+ (NSDictionary *)firstTestDictionaryAlt
{
	static NSDictionary *dictionary = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSDictionary *superDict = [super firstTestDictionary];
		NSDictionary *planDict = [[NSDictionary alloc] initWithObjectsAndKeys:
								  @"medium",							kCDOHPlanNameKey,
								  CDOHTestNumFromUInteger(2457600),		kCDOHPlanSpaceKey,
								  CDOHTestNumFromUInteger(10),			kCDOHPlanCollaboratorsKey,
								  CDOHTestNumFromUInteger(20),			kCDOHPlanPrivateRepositoriesKey,
								  nil];
		
		NSDictionary *localDict = [[NSDictionary alloc] initWithObjectsAndKeys:
								   CDOHTestNumFromUInteger(583231),		kCDOHUserIDKey,
								   @"new_octocat",						kCDOHUserLoginKey,
								   @"Monalisa Octocat",					kCDOHUserNameKey,
								   @"A company",						kCDOHUserCompanyKey,
								   @"New York",							kCDOHUserLocationKey,
								   @"monalisa.octocat@github.com",		kCDOHUserEmailKey,
								   @"Organization",						kCDOHUserTypeKey,
								   @"2012-01-01T01:01:01Z",				kCDOHUserCreatedAtKey,
								   @"http://www.example.com/blog",		kCDOHUserBlogKey,
								   @"https://example.com/octocat",		kCDOHUserHTMLURLKey,
								   @"https://secure.gravatar.com/avatar/2f21aac393665a85428eab10c2bdbe79?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-140.png", kCDOHUserAvatarURLKey,
								   @"2f21aac393665a85428eab10c2bdbe79",	kCDOHUserGravatarIDKey,
								   CDOHTestNumFromUInteger(3),			kCDOHUserPublicReposKey,
								   CDOHTestNumFromUInteger(5),			kCDOHUserPublicGistsKey,
								   CDOHTestNumFromUInteger(121),		kCDOHUserFollowersKey,
								   CDOHTestNumFromUInteger(1),			kCDOHUserFollowingKey,
								   CDOHTestNumFromUInteger(6),			kCDOHUserTotalPrivateReposKey,
								   CDOHTestNumFromUInteger(2),			kCDOHUserOwnedPrivateReposKey,
								   CDOHTestNumFromUInteger(104),		kCDOHUserPrivateGistsKey,
								   CDOHTestNumFromUInteger(6),			kCDOHUserDiskUsageKey,
								   CDOHTestNumFromUInteger(6),			kCDOHUserCollaboratorsKey,
								   planDict,							kCDOHUserPlanKey,
								   nil];
		
		dictionary = [self mergeOwnTestDictionary:localDict withSuperDictionary:superDict];
	});
	
	return dictionary;
}

// Exactly the same as firstTestDictionary except the user ID is different and
// as such the user created from this dictionary should not be equal to a user
// created from the firstTestDictionary.
+ (NSDictionary *)secondTestDictionary
{
	static NSDictionary *dictionary = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSDictionary *superDict = [super firstTestDictionary];
		NSDictionary *planDict = [[NSDictionary alloc] initWithObjectsAndKeys:
								  @"small",								kCDOHPlanNameKey,
								  CDOHTestNumFromUInteger(1228800),		kCDOHPlanSpaceKey,
								  CDOHTestNumFromUInteger(5),			kCDOHPlanCollaboratorsKey,
								  CDOHTestNumFromUInteger(10),			kCDOHPlanPrivateRepositoriesKey,
								  nil];
		
		NSDictionary *localDict = [[NSDictionary alloc] initWithObjectsAndKeys:
								   CDOHTestNumFromUInteger(1234),		kCDOHUserIDKey,
								   @"octocat",							kCDOHUserLoginKey,
								   @"The Octocat",						kCDOHUserNameKey,
								   @"GitHub",							kCDOHUserCompanyKey,
								   @"San Francisco",					kCDOHUserLocationKey,
								   @"octocat@github.com",				kCDOHUserEmailKey,
								   @"User",								kCDOHUserTypeKey,
								   @"2011-01-25T18:44:36Z",				kCDOHUserCreatedAtKey,
								   @"http://www.github.com/blog",		kCDOHUserBlogKey,
								   @"https://github.com/octocat",		kCDOHUserHTMLURLKey,
								   @"https://secure.gravatar.com/avatar/7ad39074b0584bc555d0417ae3e7d974?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-140.png", kCDOHUserAvatarURLKey,
								   @"7ad39074b0584bc555d0417ae3e7d974", kCDOHUserGravatarIDKey,
								   CDOHTestNumFromUInteger(2),			kCDOHUserPublicReposKey,
								   CDOHTestNumFromUInteger(4),			kCDOHUserPublicGistsKey,
								   CDOHTestNumFromUInteger(120),		kCDOHUserFollowersKey,
								   CDOHTestNumFromUInteger(0),			kCDOHUserFollowingKey,
								   CDOHTestNumFromUInteger(5),			kCDOHUserTotalPrivateReposKey,
								   CDOHTestNumFromUInteger(1),			kCDOHUserOwnedPrivateReposKey,
								   CDOHTestNumFromUInteger(103),		kCDOHUserPrivateGistsKey,
								   CDOHTestNumFromUInteger(5),			kCDOHUserDiskUsageKey,
								   CDOHTestNumFromUInteger(5),			kCDOHUserCollaboratorsKey,
								   planDict,							kCDOHUserPlanKey,
								   nil];
		
		dictionary = [self mergeOwnTestDictionary:localDict withSuperDictionary:superDict];
	});
	
	return dictionary;
}

// Creates an un-authenticate user based on the firstTestDictionary.
// Should be equal to the firstTestResource/Dictionary when compared using
// -[CDOHAbstractUser isEqual:].
+ (id)unauthenticatedTestUserDictionary
{
	static NSDictionary *dictionary = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSDictionary *firstTestDictionary = [self firstTestDictionary];
		
		NSArray *keys = [[NSArray alloc] initWithObjects:
						 kCDOHUserIDKey,
						 kCDOHUserLoginKey,
						 kCDOHUserNameKey,
						 kCDOHUserCompanyKey,
						 kCDOHUserLocationKey,
						 kCDOHUserEmailKey,
						 kCDOHUserTypeKey,
						 kCDOHUserCreatedAtKey,
						 kCDOHUserBlogKey,
						 kCDOHUserHTMLURLKey,
						 kCDOHUserAvatarURLKey,
						 kCDOHUserGravatarIDKey,
						 kCDOHUserPublicReposKey,
						 kCDOHUserPublicGistsKey,
						 kCDOHUserFollowersKey,
						 kCDOHUserFollowingKey,
						 nil];
		dictionary = [firstTestDictionary dictionaryWithValuesForKeys:keys];
	});
	
	return dictionary;
}


#pragma mark - Test Resources
- (id)unauthenticatedTestUser
{
	NSDictionary *unauthenticatedTestUserDictionary = [[self class] unauthenticatedTestUserDictionary];
	CDOHResource *unauthenticatedTestUser = [[[[self class] testedClass] alloc] initWithDictionary:unauthenticatedTestUserDictionary];
	return unauthenticatedTestUser;
}


#pragma mark - Test Resource Equality and Hash
- (void)testResourceEquality
{
	[super testResourceEquality];
}

- (void)testResourceInequality
{
	[super testResourceInequality];
}

- (void)testResourceHashEqual
{
	[super testResourceHashEqual];
}

- (void)testResourceHashInequal
{
	[super testResourceHashInequal];
}


#pragma mark - Test Dictionary Encoding and Decoding
- (void)testResourceDecodeFromDictionary
{
	[super testResourceDecodeFromDictionary];
}



@end
