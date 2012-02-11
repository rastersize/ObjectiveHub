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
#import "CDOHAbstractUser.h"


#pragma mark - Dictionary Representation Keys
/// User dictionary representation key for the user biography.
extern NSString *const kCDOHUserBioKey;
/// User dictionary representation key for the user hireable status.
extern NSString *const kCDOHUserHireableKey;
/// User dictionary representation key for the number of contributions a user
/// have made to a specific repository.
extern NSString *const kCDOHUserContributionsKey;


#pragma mark - CDOHUser Interface
/**
 * An immutable class containing information about a single "normal" GitHub
 * user, i.e. not an organization.
 */
@interface CDOHUser : CDOHAbstractUser

#pragma mark - Personal Information
/** @name Personal Information */
/**
 * The biography of the user.
 */
@property (readonly, copy) NSString *biography;

/**
 * Wheter the user is hireable or not.
 */
@property (readonly, getter = isHireable) BOOL hireable;


#pragma mark - Repository Contributions
/** @name Repository Contributions */
/**
 * The number of contributions the user have made to a specific repository.
 *
 * Only set if you specifically request the contributors of a specific
 * repository. Otherwise it will be 0.
 *
 * @see repositoryContributors:owner:success:failure:
 * @see repositoryContributors:owner:anonymous:success:failure:
 */
@property (readonly, assign) NSUInteger contributions;


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

@end
