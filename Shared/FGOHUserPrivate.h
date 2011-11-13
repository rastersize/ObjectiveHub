//
//  FGOHUserPrivate.h
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


#pragma mark Dictionary Keys
/** @name Dictionary Keys */
/// Dictionary key for the login value.
extern NSString *const kFGOHUserDictionaryLoginKey;
/// Dictionary key for the id value.
extern NSString *const kFGOHUserDictionaryIdKey;
/// Dictionary key for the avatar URL value.
extern NSString *const kFGOHUserDictionaryAvatarUrlKey;
/// Dictionary key for the API URL value.
extern NSString *const kFGOHUserDictionaryUrlKey;
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
extern NSString *const kFGOHUserDictionaryHtmlUrlKey;
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
/// Dictionary key for the authenticated value.
extern NSString *const kFGOHUserDictionaryAuthenticatedKey;


#pragma mark - FGOHUser Private Interface
/**
 * Private FGOHUser additions.
 */
@interface FGOHUser ()


#pragma mark - Initializing an FGOHUser Instance
/** @name Initializing an FGOHUser Instance */
/**
 * Initializes and returns an `FGOHUser` instance intialized with the values of
 * the given dictionary.
 *
 * @param dictionary A dictionary containing user information.
 * @return An `FGOHUser` instance initialized with the given dictionary.
 * @private
 */
- (id)initWithDictionary:(NSDictionary *)dictionary;


#pragma mark - Transform Between Instance Variables and Dictionary
/**
 * Encode instance as a dictionary.
 *
 * @return The instance variables encoded into a dictionary.
 * @private
 */
- (NSDictionary *)encodeAsDictionary;

/**
 * Setup the instance variables using the values in the dictionary.
 *
 * @param dictionary The dictionary containing the values which the instance
 * variables should be set to.
 * @private
 */
- (void)setupUsingDictionary:(NSDictionary *)dictionary;

@end
