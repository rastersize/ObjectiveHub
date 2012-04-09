//
//  NSDictionary+ObjectiveHub.h
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


#pragma mark - NSDictionary ObjectiveHub Category Interface
/**
 * Helper methods for accessing known types of objects in a dictionary.
 */
@interface NSDictionary (ObjectiveHub)

#pragma mark - Accessing Values
/** @name Accessing Values */
/**
 * Returns the object in this dictionary for the given _key_, or `nil` if no
 * object for the given key could be found or the found object was `NSNull`.
 *
 * If the object for the given key is not a `NSNumber` object but instead a
 * `NSString` object we will try to create a `NSNumber` object using the
 * string. In the case where we can not create or find a `NSNumber` object `nil`
 * will be returned.
 *
 * @param key The key to get the URL object.
 * @return The decoded URL object or `nil`.
 */
- (id)cdoh_objectOrNilForKey:(id)key;


#pragma mark - Accessing Encoded Values
/** @name Accessing Encoded Values */
/**
 * Returns the object in this dictionary for the given _key_.
 *
 * If the object for the given key is not of the given class _ofClass_ but
 * instead a `NSDictionary` object we will initialize a new object of the class
 * and return it. In the case where the type of the object is not recognized or
 * is `nil`, `nil` is returned.
 *
 * _ofClass_ must be a subclass of CDOHResource.
 *
 * @param key The key to get the object.
 * @param ofClass The class to instanciate using the object for the given key if
 * the object is a `NSDictionary`.
 * @return The decoded object or `nil`.
 */
- (id)cdoh_resourceForKey:(id)key ofClass:(Class)ofClass;

/**
 * Returns the date object in this dictionary for the given _key_.
 *
 * If the object for the given key is not a `NSDate` object but instead a
 * `NSString` object we will try to parse it by assuming it is an RFC 3339
 * formatted date string and return it. In the case where the type of the object
 * is not recognized, we could not parse the string or it is `nil` we return
 * `nil`.
 *
 * @param key The key to get the date object.
 * @return The decoded date object or `nil`.
 */
- (NSDate *)cdoh_dateForKey:(id)key;

/**
 * Returns the URL object in this dictionary for the given _key_.
 *
 * If the object for the given key is not a `NSURL` object but instead a
 * `NSString` object we will try to create a `NSURL` object using the string.
 * In the case where we can not create an `NSURL` object `nil` will be
 * returned.
 *
 * @param key The key associated with the sought URL object.
 * @return The decoded URL object or `nil`.
 */
- (NSURL *)cdoh_URLForKey:(id)key;

/**
 * Returns the `NSNumber` object in this dictionary for the given _key_.
 *
 * If the object for the given key is not a `NSNumber` object but instead a
 * `NSString` object we will try to create a `NSNumber` object using the
 * string and treating it as it contains a `NSInteger` value. In the case where
 * we can not create or find a `NSNumber` object `nil` will be returned.
 *
 * @param key The key associated with the sought `NSNumber` object.
 * @return The decoded URL object or `nil`.
 */
- (NSNumber *)cdoh_numberForKey:(id)key;


#pragma mark - Accessing Scalar Values
/** @name Accessing Scalar Values */
/**
 * Returns the boolean value wrapped by a `NSNumber` associated with the given
 * _key_.
 *
 * If no object exists for the given _key_ `NO` will be returned. In the case
 * where the object associated with _key_ is not an instance of `NSNumber` an
 * exception will be raised.
 *
 * @param key The key associated with the sought boolean value.
 * @return The boolean value associated with the given _key_.
 */
- (BOOL)cdoh_boolForKey:(id)key;

/**
 * Returns the integer value wrapped by a `NSNumber` associated with the given
 * _key_.
 *
 * If no object exists for the given _key_ `0` (zero) will be returned. In the
 * case where the object associated with _key_ is not an instance of `NSNumber`
 * an exception will be rasied.
 *
 * @param key The key associated with the sought integer value.
 * @return The integer value associated with the given _key_.
 */
- (NSInteger)cdoh_integerForKey:(id)key;

/**
 * Returns the unsigned integer value wrapped by a `NSNumber` associated with
 * the given _key_.
 *
 * If no object exists for the given _key_ `0` (zero) will be returned. In the
 * case where the object associated with _key_ is not an instance of `NSNumber`
 * an exception will be rasied.
 *
 * @param key The key associated with the sought unsigned integer value.
 * @return The unsigned integer value associated with the given _key_.
 */
- (NSUInteger)cdoh_unsignedIntegerForKey:(id)key;

/**
 * Returns the double value wrapped by a `NSNumber` associated with the given
 * _key_.
 *
 * If no object exists for the given _key_ `0.0f` (zero) will be returned. In
 * the case where the object associated with _key_ is not an instance of
 * `NSNumber` an exception will be rasied.
 *
 * @param key The key associated with the sought double value.
 * @return The double value associated with the given _key_.
 */
- (double)cdoh_doubleForKey:(id)key;


@end
