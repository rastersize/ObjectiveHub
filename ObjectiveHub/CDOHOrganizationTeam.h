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

#import <ObjectiveHub/CDOHResource.h>


#pragma mark - Team Permission String Constants
/// Team permission string representing teams where team members can pull, but
/// not push or administer the repositories accessible by the team.
extern NSString *const kCDOHOrganizationTeamPermissionPull;
/// Team permission string representing teams where team members can pull and
/// push, but not administer the repositories accessible by the team.
extern NSString *const kCDOHOrganizationTeamPermissionPush;
/// Team permission string representing teams where team members can pull, push
/// and administer the repositories accessible by the team.
extern NSString *const kCDOHOrganizationTeamPermissionAdminister;


#pragma mark - CDOHOrganizationTeam Interface
@interface CDOHOrganizationTeam : CDOHResource

#pragma mark - Identification Information
/** @name Identification Information */
/**
 * The team identifier.
 */
@property (readonly) NSUInteger identifier;

/**
 * The name of the team.
 */
@property (copy, readonly) NSString *name;

/**
 * The permission level of the team.
 *
 * Can be any one of the following string constants:
 *
 * - `kCDOHOrganizationTeamPermissionPull`; team members can pull, but not push
 *   or administer the repositories accessible by the team.
 * - `kCDOHOrganizationTeamPermissionPush`; team members can pull and push, but
 *   not administer the repositories accessible by the team.
 * - `kCDOHOrganizationTeamPermissionAdminister`; team members can pull, push and
 *   administer the repositories accessible by the team.
 *
 * @see [CDOHClientProtocol organizationTeamMembers:pages:success:failure:]
 * @see [CDOHClientProtocol organizationTeamRepositories:pages:success:failure:]
 */
@property (copy, readonly) NSString *permission;


#pragma mark - Meta Information
/** @name Meta Information */
/**
 * The number of users that are a member of the team.
 */
@property (readonly) NSUInteger membersCount;

/**
 * The number of repositories associated with the team.
 */
@property (readonly) NSUInteger repositoriesCount;


#pragma mark - Identifying and Comparing Organization Teams
/** @name Identifying and Comparing Organization Teams */
/**
 * Returns a Boolean value that indicates whether the given organization team,
 * _aTeam_, is equal to the receiver.
 *
 * The receiver and _aTeam_ is determined to be equal if their identifiers are
 * equal.
 *
 * @param aRepository The repository with which to compare the reciever.
 * @return `YES` if _aRepository_ is equivalent to the reciever, otherwise `NO`.
 */
- (BOOL)isEqualToOrganizationTeam:(CDOHOrganizationTeam *)aTeam;

@end
