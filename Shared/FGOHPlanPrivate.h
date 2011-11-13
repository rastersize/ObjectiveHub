//
//  FGOHPlanPrivate.h
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

#import "FGOHPlan.h"


#pragma mark Dictionary Keys
/// Dictionary key for the name value.
extern NSString *const kFGOHPlanDictionaryNameKey;
/// Dictionary key for the name value.
extern NSString *const kFGOHPlanDictionarySpaceKey;
/// Dictionary key for the name value.
extern NSString *const kFGOHPlanDictionaryCollaboratorsKey;
/// Dictionary key for the name value.
extern NSString *const kFGOHPlanDictionaryPrivateRepositoriesKey;


#pragma mark - FGOHPlan Private Interface
/**
 * Private FGOHPlan additions.
 */
@interface FGOHPlan ()


#pragma mark - Initializing an FGOHPlan Instance
/** @name Initializing an FGOHPlan Instance */
/**
 * Initializes and returns an `FGOHPlan` instance intialized with the values of
 * the given dictionary.
 *
 * @param dictionary A dictionary containing user information.
 * @return An `FGOHPlan` instance initialized with the given dictionary.
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
