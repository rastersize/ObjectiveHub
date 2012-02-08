//
//  CDOHOrganization.h
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


#pragma mark CDOHOrganization Interface
/**
 * An immutable class containing information about a single GitHub organization.
 */
@interface CDOHOrganization : CDOHAbstractUser

#pragma mark - Identifying and Comparing Organizations
/** @name Identifying and Comparing Organizations */
/**
 * Returns a Boolean value that indicates whether a given organization is equal
 * to the receiver.
 *
 * As the organization identifier integer uniquely identifies a GitHub the
 * receiver and _anOrganization_ is determined to be equal if their identifiers
 * are equal. They are also equal if the receiver and the _anOrganization_
 * instances are the same instance.
 *
 * @param anOrganization The user with which to compare the reciever.
 * @return `YES` if _aUser_ is equivalent to the reciever, otherwise `NO`.
 */
- (BOOL)isEqualToOrganization:(CDOHOrganization *)anOrganization;

@end
