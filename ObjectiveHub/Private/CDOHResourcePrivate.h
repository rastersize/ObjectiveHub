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

#import "NSDictionary+ObjectiveHub.h"
#import "NSMutableDictionary+ObjectiveHub.h"


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

#pragma mark - Handling Resource Encoding and Decoding
/** @name Handling Resource Encoding and Decoding */
/**
 * Returns an array of key paths representing the encodeable (and as such
 * also decodable) attributes of the resource.
 *
 * The default implementation returns the key path for all the properties of the
 * class and its super classes (except the superclass of CDOHResource, i.e.
 * NSObject).
 *
 * @return An array of `NSString` objects, each of which contains a key path to
 * one of the resource’s attributes.
 */
+ (NSArray *)encodableKeyPaths;

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





@end
