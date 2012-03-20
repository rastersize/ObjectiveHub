//
//  NSDictionary+ObjectiveHub.m
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

#import "NSDictionary+ObjectiveHub.h"

#import "CDOHResource.h"

#import "NSDate+ObjectiveHub.h"
#import "NSString+ObjectiveHub.h"

#import "CDOHCommon.h"


#pragma mark NSDictionary ObjectiveHub Category Private Interface
@interface NSDictionary (ObjectiveHub_Private)

#pragma mark - Accessing Encoded Values
// Executes the given _block_ with the object for the given _key_. If the object
// at _key_ is of the type NSNull `nil` will be returned and the block will not
// be executed. The same goes if no object is found for the given _key_.
- (id)cdoh_decodeObjectForKey:(id)key block:(void (^)(id objFromDict, id *retObj))block;

@end


#pragma mark - NSDictionary ObjectiveHub Category Implementation
CDOH_FIX_CATEGORY_BUG(NSDictionary_ObjectiveHub)
@implementation NSDictionary (ObjectiveHub)

#pragma mark - Accessing Values
- (id)cdoh_objectOrNilForKey:(id)key
{
	id objFromDict = [self objectForKey:key];
	if ([objFromDict isKindOfClass:[NSNull class]]) {
		objFromDict = nil;
	}
	
	return objFromDict;
}


#pragma mark - Accessing Encoded Values
- (id)cdoh_resourceForKey:(id __unused)key ofClass:(Class __unused)ofClass
{
	NSAssert(NO, @"remove me");
	return nil;/*[self cdoh_decodeObjectForKey:key block:^(id __unused objFromDict, __autoreleasing id *__unused retObj) {
		if ([objFromDict isKindOfClass:ofClass]) {
			*retObj = [objFromDict copy];
		} else if ([objFromDict isKindOfClass:[NSDictionary class]]) {
			*retObj = [[ofClass alloc] initWithJSONDictionary:objFromDict];
		}
	}];*/
}

- (NSDate *)cdoh_dateForKey:(id)key
{
	return [self cdoh_decodeObjectForKey:key block:^(id objFromDict, __autoreleasing id *retObj) {
		if ([objFromDict isKindOfClass:[NSDate class]]) {
			*retObj = [objFromDict copy];
		} else if ([objFromDict isKindOfClass:[NSString class]]) {
			NSDate *parsedDateString = [objFromDict cdoh_dateUsingRFC3339Format];
			*retObj = parsedDateString;
		}
	}];
}

- (NSURL *)cdoh_URLForKey:(id)key
{
	return [self cdoh_decodeObjectForKey:key block:^(id objFromDict, __autoreleasing id *retObj) {
		if ([objFromDict isKindOfClass:[NSURL class]]) {
			*retObj = [objFromDict copy];
		} else if ([objFromDict isKindOfClass:[NSString class]]) {
			NSURL *parsedUrl = [[NSURL alloc] initWithString:objFromDict];
			*retObj = parsedUrl;
		}
	}];
}

- (NSNumber *)cdoh_numberForKey:(id)key
{
	return [self cdoh_decodeObjectForKey:key block:^(id objFromDict, __autoreleasing id *retObj) {
		if ([objFromDict isKindOfClass:[NSNumber class]]) {
			*retObj = [objFromDict copy];
		} else if ([objFromDict isKindOfClass:[NSString class]]) {
			NSNumber *parsedNum = [[NSNumber alloc] initWithInteger:[objFromDict integerValue]];
			*retObj = parsedNum;
		}
	}];
}

- (id)cdoh_decodeObjectForKey:(id)key block:(void (^)(id objFromDict, id *retObj))block
{
	__autoreleasing id retObj = nil;
	id objFromDict = [self objectForKey:key];
	
	if (objFromDict != nil && ![objFromDict isKindOfClass:[NSNull class]]) {
		block(objFromDict, &retObj);
	}
	
	return retObj;
}


#pragma mark - Accessing Scalar Values
- (BOOL)cdoh_boolForKey:(id)key
{
	return [[self cdoh_numberForKey:key] boolValue];
}

- (NSInteger)cdoh_integerForKey:(id)key
{
	return [[self cdoh_numberForKey:key] integerValue];
}

- (NSUInteger)cdoh_unsignedIntegerForKey:(id)key
{
	return [[self cdoh_numberForKey:key] unsignedIntegerValue];
}

- (double)cdoh_doubleForKey:(id)key
{
	return [[self cdoh_numberForKey:key] doubleValue];
}


@end
