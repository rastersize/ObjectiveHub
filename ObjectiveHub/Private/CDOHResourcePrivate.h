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
@interface CDOHResource (/*Private*/)

#pragma mark - Handling JSON
/** @name Handling JSON */
/**
 * Safely set resource’s attributes to the values in the (JSON) dictionary.
 */
- (void)setValuesForAttributesWithJSONDictionary:(NSDictionary *)keyedValues;

/**
 * Safely add to, or set, the resource’s relationships using/to the values in
 * the (JSON) dictionary.
 */
- (void)setValuesForRelationshipsWithJSONDictionary:(NSDictionary *)keyedValues;

@end
