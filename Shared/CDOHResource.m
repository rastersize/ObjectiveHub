//
//  CDOHResource.m
//  ObjectiveHub
//
//  Copyright 2011 Aron Cedercrantz. All rights reserved.
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


#pragma mark NSCoding and GitHub JSON Keys
NSString *const kCDOHResourceAPIResourceURLKey =  @"url";


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


#pragma mark - NSCoding Methods
- (void)encodeWithCoder:(NSCoder *)aCoder
{	
	[aCoder encodeObject:_apiResourceUrl forKey:kCDOHResourceAPIResourceURLKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	id decodedApiResourceUrl = [aDecoder decodeObjectForKey:kCDOHResourceAPIResourceURLKey];
	NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
						  decodedApiResourceUrl, kCDOHResourceAPIResourceURLKey,
						  nil];
	
	self = [self initWithDictionary:dict];
	return self;
}

#pragma mark - NSCopyingMethods
- (id)copyWithZone:(NSZone *)__unused zone
{
	return self;
}


@end

