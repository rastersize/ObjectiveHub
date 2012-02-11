//
//  CDOHResourcePrivate.h
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
/// The API resource URL NSCoding and GitHub JSON key.
extern NSString *const kCDOHResourceAPIResourceURLKey;


#pragma mark - NSCoding Keys
/// The properties dictionary key.
extern NSString *const kCDOHResourcePropertiesDictionaryKey;


#pragma mark - CDOHResource Private Interface
/**
 * Private CDOHResource methods and properties.
 */
@interface CDOHResource () {
	@package
	NSURL *_apiResourceUrl;
}

#pragma mark - API Resource URL
/** @name API Resource URL  */
/**
 * The URL of the API resource represented.
 */
@property (strong, readonly) NSURL *_APIResourceURL;


#pragma mark - Encoding Resources
/** @name Encoding Resources */
/**
 * Merges the subclass resource dictionary with the superclass’s resource
 * dictionary and returns the resulting dictionary.
 *
 * The subclass resource dictionary’s values will overwrite those of the
 * superclass’s resource dictionary if both contain values for the same keys.
 *
 * If both parameters are `nil`, `nil` will be returned. If one of the given
 * dictionaries are `nil` the non-`nil` dictionary will be returned.
 *
 * @param subclassDictionary The subclass resource dictionary.
 * @param superclassDictionary The superclass resource dictionary.
 * @return The subclass resource dictionary merged with the superclass resource
 * dictionary.
 */
+ (NSDictionary *)mergeSubclassDictionary:(NSDictionary *)subclassDictionary withSuperclassDictionary:(NSDictionary *)superclassDictionary;


#pragma mark - Decoding Dictionary Objects
/** @name Decoding Dictionary Objects */
/**
 * Returns the object in the given _dictionary_ for the given _key_.
 *
 * If the object for the given key is not of the given class _ofClass_ but
 * instead a `NSDictionary` object we will initialize a new object of the class
 * and return it. In the case where the type of the object is not recognized or
 * is `nil`, `nil` is returned.
 *
 * _ofClass_ must be a subclass of CDOHResource.
 *
 * @param dictionary The dictionary to get the object from for the given _key_.
 * @param key The key to get the object from the given dictionary.
 * @param ofClass The class to instanciate using the object for the given key if
 * the object is a `NSDictionary`.
 * @return The decoded object or `nil`.
 */
+ (id)resourceObjectFromDictionary:(NSDictionary *)dictionary usingKey:(id)key ofClass:(Class)ofClass;

/**
 * Returns the date object in the given _dictionary_ for the given _key_.
 *
 * If the object for the given key is not a `NSDate` object but instead a
 * `NSString` object we will try to parse it by assuming it is an RFC 3339
 * formatted date string and return it. In the case where the type of the object
 * is not recognized, we could not parse the string or it is `nil` we return
 * `nil`.
 *
 * @param dictionary The dictionary to get the object from for the given _key_.
 * @param key The key to get the date object from the given dictionary.
 * @return The decoded date object or `nil`.
 */
+ (NSDate *)dateObjectFromDictionary:(NSDictionary *)dictionary usingKey:(id)key;

/**
 * Returns the URL object in the given _dictionary_ for the given _key_.
 *
 * If the object for the given key is not a `NSURL` object but instead a
 * `NSString` object we will try to create a `NSURL` object using this string.
 * In the case where we can not create an `NSURL` object `nil` will be
 * returned.
 *
 * @param dictionary The dictionary to get the object from for the given _key_.
 * @param key The key to get the URL object from the given dictionary.
 * @return The decoded URL object or `nil`.
 */
+ (NSURL *)URLObjectFromDictionary:(NSDictionary *)dictionary usingKey:(id)key;


@end
