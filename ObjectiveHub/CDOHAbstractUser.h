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

#import <ObjectiveHub/_CDOHAbstractUser.h>


#pragma mark - GitHub JSON Dictionary Keys
/// Abstract user dictionary key for the name of the user.
extern NSString *const kCDOHUserNameKey;
/// Abstract user dictionary key for the company name.
extern NSString *const kCDOHUserCompanyKey;
/// Abstract user dictionary key for the name value.
extern NSString *const kCDOHUserBlogKey;
/// Abstract user dictionary key for the location value.
extern NSString *const kCDOHUserLocationKey;
/// Abstract user dictionary key for the email value.
extern NSString *const kCDOHUserEmailKey;
/// Abstract user dictionary key for the login value.
extern NSString *const kCDOHUserLoginKey;
/// Abstract user dictionary key for the identifier value.
extern NSString *const kCDOHUserIdentifierKey;
/// Abstract user dictionary key for the avatar URL value.
extern NSString *const kCDOHUserAvatarURLKey;
/// Abstract user dictionary key for the gravatar ID value.
extern NSString *const kCDOHUserGravatarIDKey;
/// Abstract user dictionary key for the number of public repositories value.
extern NSString *const kCDOHUserPublicReposKey;
/// Abstract user dictionary key for the number of public gists value.
extern NSString *const kCDOHUserPublicGistsKey;
/// Abstract user dictionary key for the number of followers value.
extern NSString *const kCDOHUserFollowersKey;
/// Abstract user dictionary key for the number of people the user is following value.
extern NSString *const kCDOHUserFollowingKey;
/// Abstract user dictionary key for the HTML URL value.
extern NSString *const kCDOHUserHTMLURLKey;
/// Abstract user dictionary key for the created at value.
extern NSString *const kCDOHUserCreatedAtKey;
/// Abstract user dictionary key for the user type value.
extern NSString *const kCDOHUserTypeKey;
/// Abstract user dictionary key for the total number of private repositories value.
extern NSString *const kCDOHUserTotalPrivateReposKey;
/// Abstract user dictionary key for the total number of owned private repositories value.
extern NSString *const kCDOHUserOwnedPrivateReposKey;
/// Abstract user dictionary key for the number of private gists value.
extern NSString *const kCDOHUserPrivateGistsKey;
/// Abstract user dictionary key for the total disk usage value.
extern NSString *const kCDOHUserDiskUsageKey;
/// Abstract user dictionary key for the number of collaborators value.
extern NSString *const kCDOHUserCollaboratorsKey;
/// Abstract user dictionary key for the plan value.
extern NSString *const kCDOHUserPlanKey;


#pragma mark - User Type Keys
/// User type key for "normal" GitHub users.
extern NSString *const KCDOHUserTypeUserKey;
/// User type key for organization users.
extern NSString *const kCDOHUserTypeOrganizationKey;


#pragma mark - CDOHAbstractUser Interface
/**
 * An abstract class containing information about a single GitHub user of any
 * type.
 *
 * If you use send the `+resourceWithJSONDictionary:inManagedObjectContex:`
 * message to this class it will try to figure out which concrete class you
 * actually wanted to use. It does this by looking at the value for the key
 * `kCDOHUserTypeKey` and comparing it against the known types. If it does not
 * find a suitable concrete class it will assert.
 *
 * You will probably *not* want to use this class, instead please have a look
 * at the `CDOHUser` and `CDOHOrganization` classes which both extend this class
 * and provides more specific behaviour.
 */
@interface CDOHAbstractUser : _CDOHAbstractUser

#pragma mark - Personal Information
/** @name Avatar Information */
/**
 * The URL of the users avatar.
 */
@property (strong) NSURL *avatarURL;

/**
 * The URL of the users blog or website.
 */
@property (strong) NSURL *blogURL;


#pragma mark - System Information
/** @name GitHub Profile */
/**
 * The URL of the users GitHub profile page (HTML version).
 */
@property (strong) NSURL *profileURL;


@end
