//
//  CDOHResource.h
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

#import "NSDictionary+ObjectiveHub.h"
#import "NSMutableDictionary+ObjectiveHub.h"


#pragma mark GitHub JSON Keys
NSString *const kCDOHResourceJSONResourceURLKey					= @"url";


#pragma mark - NSCoding Key
NSString *const kCDOHResourceJSONRepresentationKey				= @"CDOHResourceJSONRepresentation";


#pragma mark - 
@implementation CDOHResource

@synthesize propertiesWithValue = _propertiesWithValue;
@synthesize resourceURL = _resourceURL;


#pragma mark - Creating and Initializing Resources
+ (instancetype)resourceWithJSONDictionary:(NSDictionary *)jsonDictionary
{
	NSParameterAssert(jsonDictionary != nil);
	
	CDOHResource *resource = [[[self class] alloc] initWithJSONDictionary:jsonDictionary];
	return resource;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary
{
	self = [super init];
	if (self) {
		_resourceURL = [jsonDictionary cdoh_URLForKey:kCDOHResourceJSONResourceURLKey];
		
		NSDictionary *jsonKeyToPropertyName = [[self class] JSONKeyToPropertyName];
		NSMutableArray *valuesSetForKeys = [[NSMutableArray alloc] initWithCapacity:[jsonDictionary count]];
		for (NSString *jsonKey in jsonDictionary) {
			NSString *propertyName = [jsonKeyToPropertyName objectForKey:jsonKey];
			NSAssert(propertyName != nil, @"JSON to property name dictionary is missing property name for JSON key %@", jsonKey);
			[valuesSetForKeys addObject:propertyName];
		}
		_propertiesWithValue = [valuesSetForKeys copy];
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	NSParameterAssert([aDecoder allowsKeyedCoding]);
	
	NSDictionary *jsonDictionary = [aDecoder decodeObjectForKey:@"CDOHResourceJSONRepresentation"];
	self = [self initWithJSONDictionary:jsonDictionary];
	return self;
}


#pragma mark - Encoding
- (void)encodeWithCoder:(NSCoder *)aCoder
{
	NSParameterAssert([aCoder allowsKeyedCoding]);
	
	NSMutableDictionary *jsonDictionary = [NSMutableDictionary dictionary];
	[self encodeWithJSONDictionary:jsonDictionary];
	
	[aCoder encodeObject:jsonDictionary forKey:kCDOHResourceJSONRepresentationKey];
}

- (void)encodeWithJSONDictionary:(NSMutableDictionary *)jsonDictionary
{
	[jsonDictionary cdoh_encodeAndSetURL:_resourceURL forKey:kCDOHResourceJSONResourceURLKey];
}


#pragma mark - 
+ (void)JSONKeyToPropertyNameDictionary:(NSMutableDictionary *)dictionary
{
	CDOHSetPropertyForJSONKey(resourceURL, kCDOHResourceJSONResourceURLKey, dictionary);
}

+ (NSDictionary *)JSONKeyToPropertyName
{
	static NSDictionary *jsonKeyToPropertyName = nil;
	static dispatch_once_t jsonKeyToPropertyNameOnceToken;
	dispatch_once(&jsonKeyToPropertyNameOnceToken, ^{
		NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
		[CDOHResource JSONKeyToPropertyNameDictionary:dictionary];
		jsonKeyToPropertyName = [dictionary copy];
	});
	return jsonKeyToPropertyName;
}


#pragma mark - Checking Which Values Has Been Set
- (BOOL)isValueSetForProperty:(NSString *)propertyName
{
	return [self.propertiesWithValue containsObject:propertyName];
}

- (BOOL)isComplete
{
	NSArray *keys = [[[self class] JSONKeyToPropertyName] allKeys];
	BOOL isComplete = [self.propertiesWithValue isEqualToArray:keys];
	return isComplete;
}


#pragma mark - Identifying and Comparing Resources
- (NSUInteger)hash
{	
	return [self.resourceURL hash];
}

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
	
	return ([self.resourceURL isEqual:aResource.resourceURL]);
}


#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *__unused)zone
{
	// Immutal object
	return self;
}


#pragma mark - Describing a Resource Object
- (NSString *)description
{	
	return [NSString stringWithFormat:@"<%@: %p { resourceURL = %@ } >", [self class], self, _resourceURL];
}



@end
