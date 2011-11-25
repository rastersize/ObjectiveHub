//
//  FGOHUser.h
//  ObjectiveHub
//
//  Copyright 2011 Aron Cedercrantz. All rights reserved.
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

#import <Foundation/Foundation.h>


#pragma mark Forward Class Declarations
@class CDOHPlan;


#pragma mark Dictionary Keys
/** @name Dictionary Keys */
/// Dictionary key for the login value.
extern NSString *const kFGOHUserDictionaryLoginKey;
/// Dictionary key for the id value.
extern NSString *const kFGOHUserDictionaryIDKey;
/// Dictionary key for the avatar URL value.
extern NSString *const kFGOHUserDictionaryAvatarURLKey;
/// Dictionary key for the gravatar ID value.
extern NSString *const kFGOHUserDictionaryGravatarIDKey;
/// Dictionary key for the name value.
extern NSString *const kFGOHUserDictionaryNameKey;
/// Dictionary key for the company value.
extern NSString *const kFGOHUserDictionaryCompanyKey;
/// Dictionary key for the blog URL value.
extern NSString *const kFGOHUserDictionaryBlogKey;
/// Dictionary key for the location value.
extern NSString *const kFGOHUserDictionaryLocationKey;
/// Dictionary key for the email value.
extern NSString *const kFGOHUserDictionaryEmailKey;
/// Dictionary key for the hireable value.
extern NSString *const kFGOHUserDictionaryHireableKey;
/// Dictionary key for the biography value.
extern NSString *const kFGOHUserDictionaryBioKey;
/// Dictionary key for the number of public repositories value.
extern NSString *const kFGOHUserDictionaryPublicReposKey;
/// Dictionary key for the number of public gists value.
extern NSString *const kFGOHUserDictionaryPublicGistsKey;
/// Dictionary key for the number of followers value.
extern NSString *const kFGOHUserDictionaryFollowersKey;
/// Dictionary key for the number of people the user is following value.
extern NSString *const kFGOHUserDictionaryFollowingKey;
/// Dictionary key for the HTML URL value.
extern NSString *const kFGOHUserDictionaryHTMLURLKey;
/// Dictionary key for the created at value.
extern NSString *const kFGOHUserDictionaryCreatedAtKey;
/// Dictionary key for the user type value.
extern NSString *const kFGOHUserDictionaryTypeKey;
/// Dictionary key for the total number of private repositories value.
extern NSString *const kFGOHUserDictionaryTotalPrivateReposKey;
/// Dictionary key for the total number of owned private repositories value.
extern NSString *const kFGOHUserDictionaryOwnedPrivateReposKey;
/// Dictionary key for the number of private gists value.
extern NSString *const kFGOHUserDictionaryPrivateGistsKey;
/// Dictionary key for the total disk usage value.
extern NSString *const kFGOHUserDictionaryDiskUsageKey;
/// Dictionary key for the number of collaborators value.
extern NSString *const kFGOHUserDictionaryCollaboratorsKey;
/// Dictionary key for the plan value.
extern NSString *const kFGOHUserDictionaryPlanKey;


#pragma mark - FGOHUser Interface
/**
 * An immutable class containing information about a single GitHub user.
 *
 * If the instance represents an authenticated (see the isAuthenticated
 * property) user the following extra information is available (else it is
 * "zeroed" out; i.e. `nil`, 0 or whatever makes sense in each specific case):
 *
 * - numberOfPrivateRepositories
 * - numberOfOwnedPrivateRepositories
 * - numberOfPrivateGists
 * - diskUsage
 * - collaborators
 * - plan
 */
@interface CDOHUser : NSObject <NSCopying, NSCoding>

#pragma mark - Meta Information
/** @name GitHub Information */
/**
 * The name of the user.
 */
@property (readonly, getter = isAuthenticated) BOOL authenticated;

/**
 * The internal identifier of the user at GitHub.
 */
@property (readonly) NSUInteger identifier;

/**
 * The login username of the user.
 */
@property (readonly, copy) NSString *login;

/**
 * The avatar URL of the user.
 */
@property (readonly, strong) NSURL *avatarUrl;

/**
 * The gravatar ID of the user.
 *
 * @see [Gravatar](http://gravatar.com/)
 */
@property (readonly, copy) NSString *gravatarId;

/**
 * The HTML URL of the user.
 */
@property (readonly, strong) NSURL *htmlUrl;

/**
 * Wheter the user is hireable or not.
 */
@property (readonly, getter = isHireable) BOOL hireable;

/**
 * The number of public repositories of the user.
 */
@property (readonly) NSUInteger numberOfPublicRepositories;

/**
 * The total number of private repositories the user is a member of.
 *
 * @warning *Important:* If the instance does not represent an authenticated
 * user this will be zero (`0`). 
 */
@property (readonly) NSUInteger numberOfPrivateRepositories;

/**
 * The total number of private repositories owned by the user.
 *
 * @warning *Important:* If the instance does not represent an authenticated
 * user this will be zero (`0`). 
 */
@property (readonly) NSUInteger numberOfOwnedPrivateRepositories;

/**
 * The number of public gists by the user.
 */
@property (readonly) NSUInteger numberOfPublicGists;

/**
 * The number of private gists by the user.
 *
 * @warning *Important:* If the instance does not represent an authenticated
 * user this will be zero (`0`). 
 */
@property (readonly) NSUInteger numberOfPrivateGists;

/**
 * The number people following the user.
 */
@property (readonly) NSUInteger followers;

/**
 * The number of people the user is following.
 */
@property (readonly) NSUInteger following;

/**
 * The number of people the user is collaborating with.
 *
 * @warning *Important:* If the instance does not represent an authenticated
 * user this will be zero (`0`).
 */
@property (readonly) NSUInteger collaborators;

/**
 * The time and date when the user created his or her account.
 */
@property (readonly, strong) NSDate *createdAt;

/**
 * The users account type.
 */
@property (readonly, copy) NSString *type;

/**
 * The amount of disk space the user have used up. 
 *
 * @warning *Important:* If the instance does not represent an authenticated
 * user this will be zero (`0`).
 */
@property (readonly) NSUInteger diskUsage;

/**
 * The users plan.
 *
 * @warning *Important:* If the instance does not represent an authenticated
 * user this will be `nil`.
 */
@property (readonly, strong) CDOHPlan *plan;


#pragma mark - Personal Information
/** @name Personal Information */
/**
 * The name of the user.
 */
@property (readonly, copy) NSString *name;

/**
 * The company the user is associated with.
 */
@property (readonly, copy) NSString *company;

/**
 * The email address of the user.
 */
@property (readonly, copy) NSString *email;

/**
 * The biography of the user.
 */
@property (readonly, copy) NSString *biography;

/**
 * The location of the user.
 */
@property (readonly, copy) NSString *location;

/**
 * The URL of the users blog or website.
 */
@property (readonly, strong) NSURL *blogUrl;


#pragma mark - Identifying and Comparing Users
/** @name Identifying and Comparing Users */
/**
 * Returns a Boolean value that indicates whether a given user is equal to the
 * receiver.
 *
 * As the user identifier integer uniquely identifies a GitHub the receiver and
 * _aUser_ is determined to be equal if their identifiers are equal. They are
 * also equal if the receiver and the _aUser_ instances are the same instance.
 *
 * @param aUser The user with which to compare the reciever.
 * @return `YES` if _aUser_ is equivalent to the reciever, otherwise `NO`.
 */
- (BOOL)isEqualToUser:(CDOHUser *)aUser;

/**
 * Returns an unsigned integer that can be used as a has table address.
 *
 * If two user objects are equal (as determined by the isEqualToUser: method),
 * they will have the same hash value. Currently this is equivalent with
 * the identifier since it represents an unique GitHub user.
 *
 * @return An unsigned integer that can be used as a has table address.
 */
- (NSUInteger)hash;


@end
