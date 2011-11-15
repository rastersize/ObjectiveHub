//
//  FGOHPlan.h
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


#pragma mark FGOHPlan Interface
/**
 * A GitHub plan and the restrictions it impose on the user.
 */
@interface FGOHPlan : NSObject <NSCopying, NSCoding>

#pragma mark - Metadata
/** @name Plan Metadata */
/**
 * The name of the plan.
 */
@property (readonly, copy) NSString *name;


#pragma mark - Limitations
/** @name Limitations */
/**
 * The maximum number of space a user may use with this plan.
 */
@property (readonly) NSUInteger space;

/**
 * The maximum number of collaborators a user may have with this plan.
 */
@property (readonly) NSUInteger collaborators;

/**
 * The maximum number of repositories a user may have with this plan.
 */
@property (readonly) NSUInteger privateRepositories;


#pragma mark - Identifying and Comparing Plans
/** @name Identifying and Comparing Plans */
/**
 * Returns a Boolean value that indicates whether a given plan is equal to the
 * receiver.
 *
 * The receiver and _aPlan_ is determined to be equal if their names, maximum
 * space, number of maximum collaborators and maximum number of private
 * repositories are equal.
 *
 * @param aPlan The plan with which to compare the reciever.
 * @return `YES` if _aPlan_ is equivalent to the reciever, otherwise `NO`.
 */
- (BOOL)isEqualToPlan:(FGOHPlan *)aPlan;

/**
 * Returns an unsigned integer that can be used as a has table address.
 *
 * If two user objects are equal (as determined by the isEqualToPlan: method),
 * they will have the same hash value.
 *
 * @return An unsigned integer that can be used as a has table address.
 */
- (NSUInteger)hash;


@end
