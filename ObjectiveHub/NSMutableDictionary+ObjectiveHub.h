//
//  NSMutableDictionary+ObjectiveHub.h
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

#pragma mark - Forward Class Declarations
@class CDOHResource;


#pragma mark - NSMutableDictionary ObjectiveHub Category Interface
/**
 * Helper methods for inteacting with `NSMutableDictionary` objects.
 */
@interface NSMutableDictionary (ObjectiveHub)

#pragma mark - Adding Entries to a Mutable Dictionary
/** @name Adding Entries to a Mutable Dictionary */
/**
 * Set the given object _obj_ for the given _key_.
 *
 * @warning This method differs in behaviour to `setObject:forKey:` such that if
 * the key is `nil` no exception will be thrown in this implementation.
 *
 * @param obj The object to be set for the given _key_. If the object is `nil`
 * and their exist an object for the key it will be removed otherwise nothing
 * will be performed.
 * @param key The key which the given _obj_ should be associated with.
 */
- (void)cdoh_setObject:(id)obj forKey:(id)key;


#pragma mark - Encoding Objects and Adding Them to a Mutable Dictionary
/** @name Encoding Objects and Adding Them to a Mutable Dictionary */
/**
 * Encode, recursively, the given resource as a dictionary and set it for the
 * given _key_.
 *
 * @param resource The resource to be set (and encoded) for the given _key_.
 * @param key The key which the given _resource_ should be associated with.
 */
- (void)cdoh_encodeAndSetResource:(CDOHResource *)resource forKey:(id)key;

/**
 * Encode the given date as a RFC 3339 compliant string and set it for the given
 * _key_.
 * 
 * @param date The date to be set (and encoded) for the given _key_.
 * @param key The key which the given _date_ should be associated with.
 */
- (void)cdoh_encodeAndSetDate:(NSDate *)date forKey:(id)key;

/**
 * Encode the given URL as a string and set it for the given _key_.
 * 
 * @param url The URL to be set (and encoded) for the given _key_.
 * @param key The key which the given _url_ should be associated with.
 */
- (void)cdoh_encodeAndSetURL:(NSURL *)url forKey:(id)key;


#pragma mark - Adding Scalar Entries to a Mutable Dictionary
/** @name Adding Scalar Entries to a Mutable Dictionary */
/**
 * Set the value for the given _key_ to an `NSNumber` representing the given
 * boolean _flag_.
 *
 * @param flag The boolean to be wrapped with a `NSNumber` and set for the given
 * _key_.
 * @param key The key which the given boolean _flag_ should be associated with.
 */
- (void)cdoh_setBool:(BOOL)flag forKey:(id)key;

/**
 * Set the value for the given _key_ to an `NSNumber` representing the given
 * integer _value_.
 *
 * @param value The integer to be wrapped with a `NSNumber` and set for the
 * given _key_.
 * @param key The key which the given integer _value_ should be associated with.
 */
- (void)cdoh_setInteger:(NSInteger)value forKey:(id)key;

/**
 * Set the value for the given _key_ to an `NSNumber` representing the given
 * unsigned integer _value_.
 *
 * @param value The unsigned integer to be wrapped with a `NSNumber` and set for
 * the given _key_.
 * @param key The key which the given unsigned integer _value_ should be
 * associated with.
 */
- (void)cdoh_setUnsignedInteger:(NSUInteger)value forKey:(id)key;

/**
 * Set the value for the given _key_ to an `NSNumber` representing the given
 * double _value_.
 *
 * @param value The double to be wrapped with a `NSNumber` and set for the given
 * _key_.
 * @param key The key which the given double _value_ should be associated with.
 */
- (void)cdoh_setDouble:(double)value forKey:(id)key;

@end
