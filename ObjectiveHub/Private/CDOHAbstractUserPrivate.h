//
//  CDOHAbstractUserPrivate.h
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


#pragma mark NSCoding and GitHub JSON Keys
/** @name NSCoding and GitHub JSON Keys */
/// Internal dictionary key for the authenticated value.
extern NSString *const kCDOHUserDictionaryAuthenticatedKey;
/// Dictionary key for the login value.
extern NSString *const kCDOHUserDictionaryLoginKey;
/// Dictionary key for the id value.
extern NSString *const kCDOHUserDictionaryIDKey;
/// Dictionary key for the avatar URL value.
extern NSString *const kCDOHUserDictionaryAvatarURLKey;
/// Dictionary key for the gravatar ID value.
extern NSString *const kCDOHUserDictionaryGravatarIDKey;
/// Dictionary key for the number of public repositories value.
extern NSString *const kCDOHUserDictionaryPublicReposKey;
/// Dictionary key for the number of public gists value.
extern NSString *const kCDOHUserDictionaryPublicGistsKey;
/// Dictionary key for the number of followers value.
extern NSString *const kCDOHUserDictionaryFollowersKey;
/// Dictionary key for the number of people the user is following value.
extern NSString *const kCDOHUserDictionaryFollowingKey;
/// Dictionary key for the HTML URL value.
extern NSString *const kCDOHUserDictionaryHTMLURLKey;
/// Dictionary key for the created at value.
extern NSString *const kCDOHUserDictionaryCreatedAtKey;
/// Dictionary key for the user type value.
extern NSString *const kCDOHUserDictionaryTypeKey;
/// Dictionary key for the total number of private repositories value.
extern NSString *const kCDOHUserDictionaryTotalPrivateReposKey;
/// Dictionary key for the total number of owned private repositories value.
extern NSString *const kCDOHUserDictionaryOwnedPrivateReposKey;
/// Dictionary key for the number of private gists value.
extern NSString *const kCDOHUserDictionaryPrivateGistsKey;
/// Dictionary key for the total disk usage value.
extern NSString *const kCDOHUserDictionaryDiskUsageKey;
/// Dictionary key for the number of collaborators value.
extern NSString *const kCDOHUserDictionaryCollaboratorsKey;
/// Dictionary key for the plan value.
extern NSString *const kCDOHUserDictionaryPlanKey;

