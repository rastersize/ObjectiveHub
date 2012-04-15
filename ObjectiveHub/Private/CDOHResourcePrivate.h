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

#import "CDOHResource.h"

#import "NSDictionary+ObjectiveHub.h"
#import "NSMutableDictionary+ObjectiveHub.h"


#pragma mark - NSCoding Keys
/// The properties dictionary key.
extern NSString *const kCDOHResourceJSONRepresentationKey;


#pragma mark - JSON To Property Name Mapping
/// Map the given property _prop_ to the given JSON key _jsonKey_.
#if DEBUG
#	define CDOHSetPropertyForJSONKey(prop, jsonKey, dict)	[(dict) setObject:NSStringFromSelector(@selector(prop)) forKey:(jsonKey)]
#else
#	define CDOHSetPropertyForJSONKey(prop, jsonKey, dict)	[(dict) setObject:(@"" # prop) forKey:(jsonKey)]
#endif


#pragma mark - CDOHResource Private Interface
/**
 * Private CDOHResource methods and properties.
 */
@interface CDOHResource (/*Private*/)

#pragma mark - Encoding Resources
/** @name Encoding Resources */
/**
 * Encode the reciever as a JSON dictionary.
 *
 * Behaves much like the `NSCoding` method `encodeWithCoder:`. Subclasses
 * overriding this method must call the super implementation.
 * 
 *
 * @param jsonDictionary A mutable dictionary which the resource should be
 * encoded to as a JSON compliant dictionary.
 */
- (void)encodeWithJSONDictionary:(NSMutableDictionary *)jsonDictionary;


#pragma mark - JSON To Property Name Mapping
/** @name JSON To Property Name Mapping */
/**
 * Fills in the given dictionary with a mapping from JSON key to property name
 * for each property.
 */
+ (void)JSONKeyToPropertyNameDictionary:(NSMutableDictionary *)dictionary;

/**
 * Dictionary of JSON key to property name.
 *
 * Every subclass of `CDOHResource` should implement their own version of this
 * method.
 */
+ (NSDictionary *)JSONKeyToPropertyName;


@end
