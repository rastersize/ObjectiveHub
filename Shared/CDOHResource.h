//
//  CDOHResource.h
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


#pragma mark - CDOHResource Interface
/**
 * `CDOHResource` models a GitHub resource. It is intended to be subclassed and
 * as such is not very useful by itself.
 *
 * Instances of `CDOHResource` are immutable.
 */
@interface CDOHResource : NSObject <NSCoding, NSCopying>

#pragma mark - Initializing a CDOHResource Instance
/** @name Initializing an CDOHPlan Instance */
/**
 * Initializes and returns an `CDOHPlan` instance intialized with the values of
 * the given dictionary.
 *
 * @param dictionary A dictionary containing user information.
 * @return An `CDOHPlan` instance initialized with the given dictionary.
 */
- (id)initWithDictionary:(NSDictionary *)dictionary;


#pragma mark - Identifying and Comparing Resources
/** @name Identifying and Comparing Resources */
/**
 * Returns a Boolean value that indicates whether a given resource is equal to
 * the receiver.
 *
 * @param aResource The resource with which to compare the reciever.
 * @return `YES` if _aResource_ is equivalent to the reciever, otherwise `NO`.
 */
- (BOOL)isEqualToResource:(CDOHResource *)aResource;

/**
 * Returns an unsigned integer that can be used as a has table address.
 *
 * If two resource objects are equal (as determined by the isEqualToResource:
 * method), they will have the same hash value.
 *
 * @return An unsigned integer that can be used as a has table address.
 */
- (NSUInteger)hash;

@end
