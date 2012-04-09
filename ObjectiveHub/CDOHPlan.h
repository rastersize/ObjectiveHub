//
//  CDOHPLan.h
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


/**
 * The `CDOHPlan` class models a GitHub user (as represented by `CDOHUser`)
 * plan. For example, the "free" and the "small" plans.
 */
@interface CDOHPlan : CDOHResource

#pragma mark - Plan Name
/** @name Plan Name */
/**
 * Name of the plan.
 *
 * The name uniquely identifies a plan. 
 */
@property (copy, readonly) NSString *name;


#pragma mark - Plan Details
/** @name Plan Details */
/**
 * The maximum amount of space a user may use with this plan.
 */
@property (assign, readonly) NSUInteger space;

/**
 * The maximum number of collaborators a user may have with this plan.
 */
@property (assign, readonly) NSUInteger collaboratorsCount;

/**
 * The maximum number of repositories a user may have with this plan.
 */
@property (assign, readonly) NSUInteger privateRepositoriesCount;


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
- (BOOL)isEqualToPlan:(CDOHPlan *)aPlan;


@end
