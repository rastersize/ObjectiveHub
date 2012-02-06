//
//  CDOHResource.m
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

#import "CDOHResource.h"
#import "CDOHResourcePrivate.h"

#import "NSString+ObjectiveHub.h"


#pragma mark NSCoding and GitHub JSON Keys
NSString *const kCDOHResourceAPIResourceURLKey			=  @"url";


#pragma mark - NSCoding Keys
NSString *const kCDOHResourcePropertiesDictionaryKey	= @"CDOHResourcePropertiesDictionary";


#pragma mark - CDOHResource Private Interface
@interface CDOHResource ()

#pragma mark - Decoding Dictionary Objects
- (id)decodeObjectFromDictionary:(NSDictionary *)dictionary usingKey:(id)usingKey block:(void (^)(id objFromDict, id *retObj))block;

@end


#pragma mark - CDOHResource Implementation
@implementation CDOHResource

#pragma mark - API Resource URL
@synthesize _APIResourceURL = _apiResourceUrl;


#pragma mark - Initializing an CDOHPlan Instance
- (id)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if (self) {
		_apiResourceUrl = [dictionary objectForKey:kCDOHResourceAPIResourceURLKey];
	}
	
	return self;
}


#pragma mark - Decoding Dictionary Objects
- (id)resourceObjectFromDictionary:(NSDictionary *)dictionary usingKey:(id)usingKey ofClass:(Class)ofClass
{
	return [self decodeObjectFromDictionary:dictionary usingKey:usingKey block:^(id objFromDict, id *retObj) {
		if ([objFromDict isKindOfClass:ofClass]) {
			*retObj = [objFromDict copy];
		} else if ([objFromDict isKindOfClass:[NSDictionary class]]) {
			*retObj = [[ofClass alloc] initWithDictionary:objFromDict];
		}
	}];
}

- (NSDate *)dateObjectFromDictionary:(NSDictionary *)dictionary usingKey:(id)usingKey
{
	return [self decodeObjectFromDictionary:dictionary usingKey:usingKey block:^(id objFromDict, id *retObj) {
		if ([objFromDict isKindOfClass:[NSDate class]]) {
			*retObj = [objFromDict copy];
		} else if ([objFromDict isKindOfClass:[NSString class]]) {
			NSDate *parsedDateString = [objFromDict cdoh_dateUsingRFC3339Format];
			*retObj = parsedDateString;
		}
	}];
}

- (id)decodeObjectFromDictionary:(NSDictionary *)dictionary usingKey:(id)usingKey block:(void (^)(id objFromDict, id *retObj))block
{
	id retObj = nil;
	id objFromDict = [dictionary objectForKey:usingKey];
	
	if (objFromDict) {
		block(objFromDict, &retObj);
	}
	
	return retObj;
}


#pragma mark - Encoding Resources
- (NSDictionary *)encodeAsDictionary
{
	NSDictionary *resourceDict = nil;
	
	resourceDict = [[NSDictionary alloc] initWithObjectsAndKeys:
					_apiResourceUrl, kCDOHResourceAPIResourceURLKey,
					nil];
	
	return resourceDict;
}


#pragma mark - Identifying and Comparing Users
- (BOOL)isEqual:(id)other
{
	if (other == self) {
		return YES;
	}
	if (!other || ![other isKindOfClass:[self class]]) {
		return NO;
	}
	return [self isEqualToResource:other];
}

- (BOOL)isEqualToResource:(CDOHResource *)aResource
{
	if (aResource == self) {
		return YES;
	}
	
	return ([self._APIResourceURL isEqual:aResource._APIResourceURL]);
}

- (NSUInteger)hash
{
	// We add "137" so that we do not have the same hash as just the URL.
	return [self._APIResourceURL hash] + 137;
}


#pragma mark - NSCoding Methods
- (void)encodeWithCoder:(NSCoder *)aCoder
{	
	NSDictionary *resourceDict = [self encodeAsDictionary];
	
	[aCoder encodeObject:resourceDict forKey:kCDOHResourcePropertiesDictionaryKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	NSDictionary *resourceDict = [aDecoder decodeObjectForKey:kCDOHResourcePropertiesDictionaryKey];
	
	self = [self initWithDictionary:resourceDict];
	return self;
}

#pragma mark - NSCopyingMethods
- (id)copyWithZone:(NSZone *)__unused zone
{
	return self;
}


#pragma mark - Describing a Resource Object
- (NSString *)description
{	
	return [NSString stringWithFormat:@"<%@: %p>",
			[self class],
			self];
}


@end

