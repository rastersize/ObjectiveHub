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

#import "NSObject+ObjectiveHub.h"
#import "NSString+ObjectiveHub.h"

#import <objc/runtime.h>


#pragma mark NSCoding and GitHub JSON Keys
NSString *const kCDOHResourceAPIResourceURLKey			=  @"url";


#pragma mark - CDOHResource Implementation
@implementation CDOHResource

#pragma mark - API Resource URL
@synthesize _APIResourceURL = _apiResourceUrl;


#pragma mark - Initializing an CDOHPlan Instance
- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary
{
	self = [super init];
	if (self) {
		_apiResourceUrl = [jsonDictionary cdoh_URLForKey:kCDOHResourceAPIResourceURLKey];
	}
	
	return self;
}


#pragma mark - Handling Resource Encoding and Decoding
- (id)initWithCoder:(NSCoder *)coder
{
	NSAssert([coder allowsKeyedCoding], @"Coder must support keyed coding");
	
	self = [super init];
	if (self) {		
		_apiResourceUrl = [coder decodeObjectForKey:kCDOHResourceAPIResourceURLKey];
	}
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{	
	NSAssert([coder allowsKeyedCoding], @"Coder must support keyed coding");	
	
	[coder encodeObject:_apiResourceUrl forKey:kCDOHResourceAPIResourceURLKey];
}


// Implemented for [redacted] of [redacted] will be added in the [redacted]
// protocol.
+ (BOOL)supportsSecureCoding
{
	return YES;
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

