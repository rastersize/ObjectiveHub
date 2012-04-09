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

#import <Foundation/Foundation.h>
#import <ObjectiveHub/CDOHResource.h>


#pragma mark Forward Class Declarations
@class CDOHPlan;


#pragma mark - Update User Dictionary Keys
/// Abstract user dictionary key for the name of the user.
extern NSString *const kCDOHUserNameKey;
/// Abstract user dictionary key for the email value.
extern NSString *const kCDOHUserEmailKey;
/// Abstract user dictionary key for the name value.
extern NSString *const kCDOHUserBlogURLKey;
/// Abstract user dictionary key for the company name.
extern NSString *const kCDOHUserCompanyKey;
/// Abstract user dictionary key for the location value.
extern NSString *const kCDOHUserLocationKey;
/// User dictionary representation key for the user hireable status.
extern NSString *const kCDOHUserHireableKey;
/// User dictionary representation key for the user biography.
extern NSString *const kCDOHUserBiographyKey;


#pragma mark - User Type
/// The type of user.
typedef enum _CDOHUserType
#if __has_feature(objc_fixed_enum)
 : NSInteger
#endif
{
	/// Unknown type of user.
	kCDOHUserTypeUnkown			= -1,
	/// The user is an ordinary person.
	kCDOHUserTypePerson			= 0,
	/// The "user" is an organization.
	kCDOHUserTypeOrganization	= 1
} CDOHUserType;


#pragma mark - CDOHUser Interface
/**
 * A class containing information about a single GitHub user of any type.
 *
 * If no user type is specified the class will asume that the represented user
 * is a person and not an organization.
 *
 * If the instance represents an authenticated user (see the `isAuthenticated`
 * method) the following extra information is available (else it is
 * "zeroed" out; i.e. `nil`, 0 or whatever makes sense in each specific case):
 *
 * - `privateRepositoriesOwnedCount`
 * - `privateRepositoriesCount`
 * - `privateGistsCount`
 * - `collaborators`
 * - `diskUsage`
 * - `plan`
 */
@interface CDOHUser : CDOHResource

#pragma mark - System Information
/** @name System Information */
/**
 * Whether the reciever represent an authenticated user.
 *
 * This means more information will be available, such as the users GitHub plan,
 * number of private repositories owned and so on.
 */
- (BOOL)isAuthenticated;

/**
 * The internal identifier of the user at GitHub.
 */
@property (readonly) NSUInteger identifier;

/**
 * The type of user.
 *
 * See the `CDOHUserType` for possible values.
 */
@property (assign, readonly) CDOHUserType type;

/**
 * The login handle (or username) used by the user.
 */
@property (readonly, copy) NSString *login;

/**
 * The URL of the users GitHub profile page (HTML version).
 */
@property (strong, readonly) NSURL *profileURL;

/**
 * The number of public repositories of the user.
 */
@property (readonly) NSUInteger publicRepositoriesCount;

/**
 * The total number of private repositories the user is a member of.
 *
 * @warning **Important:** If the instance does not represent an authenticated
 * user this will be zero (`0`). 
 */
@property (readonly) NSUInteger privateRepositoriesCount;

/**
 * The total number of private repositories owned by the user.
 *
 * @warning **Important:** If the instance does not represent an authenticated
 * user this will be zero (`0`). 
 */
@property (readonly) NSUInteger privateRepositoriesOwnedCount;

/**
 * The number of public gists by the user.
 */
@property (readonly) NSUInteger publicGistsCount;

/**
 * The number of private gists by the user.
 *
 * @warning **Important:** If the instance does not represent an authenticated
 * user this will be zero (`0`). 
 */
@property (readonly) NSUInteger privateGistsCount;

/**
 * The number people following the user.
 */
@property (readonly) NSUInteger followersCount;

/**
 * The number of people the user is following.
 */
@property (readonly) NSUInteger followingCount;

/**
 * The number of people the user is collaborating with.
 *
 * @warning **Important:** If the instance does not represent an authenticated
 * user this will be zero (`0`).
 */
@property (readonly) NSUInteger collaboratorsCount;

/**
 * The time and date when the user created his or her account.
 */
@property (readonly, strong) NSDate *createdAt;

/**
 * The amount of disk space the user have used up. 
 *
 * @warning **Important:** If the instance does not represent an authenticated
 * user this will be zero (`0`).
 */
@property (readonly) NSUInteger diskUsage;

/**
 * The users plan.
 *
 * @warning **Important:** If the instance does not represent an authenticated
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
 * The location of the user.
 */
@property (readonly, copy) NSString *location;

/**
 * The URL of the users blog or website.
 */
@property (readonly, strong) NSURL *blogURL;

/**
 * The biography of the user.
 *
 * In case the user type of the reciever is an organization
 * (`kCDOHUserTypeOrganization`) this will be `nil`.
 */
@property (readonly, copy) NSString *biography;

/**
 * Wheter the user is hireable or not.
 *
 * In case the user type of the reciever is an organization
 * (`kCDOHUserTypeOrganization`) this will always be `NO`
 */
@property (readonly, getter = isHireable) BOOL hireable;


#pragma mark - Avatar Information
/** @name Avatar Information */
/**
 * The avatar URL of the user.
 */
@property (readonly, strong) NSURL *avatarURL;

/**
 * The gravatar identifier of the user.
 *
 * @see [Gravatar](http://gravatar.com/)
 */
@property (readonly, copy) NSString *gravatarIdentifier;


#pragma mark - Identifying and Comparing Abstract Users
/** @name Identifying and Comparing Abstract Users */
/**
 * Returns a Boolean value that indicates whether a given user is equal to the
 * receiver.
 *
 * As the user identifier integer uniquely identifies a GitHub the receiver and
 * _aUser_ is determined to be equal if their identifiers are equal.
 * They are also equal if the receiver and the _aUser_ instances are the same
 * instance.
 *
 * @param aUser The user with which to compare the reciever.
 * @return `YES` if _aUser_ is equivalent to the reciever, otherwise `NO`.
 */
- (BOOL)isEqualToUser:(CDOHUser *)aUser;


@end
