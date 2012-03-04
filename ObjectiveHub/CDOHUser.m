//
//  CDOHUser.m
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

#import "CDOHUser.h"
#import "CDOHUserPrivate.h"
#import "CDOHResourcePrivate.h"


#pragma mark NSCoding and GitHub JSON Keys
NSString *const kCDOHUserHireableKey		= @"hireable";
NSString *const kCDOHUserBioKey				= @"bio";
NSString *const kCDOHUserContributionsKey	= @"contributions";


#pragma mark - CDOHUser Implementation
@implementation CDOHUser

#pragma mark - Synthesization
@synthesize biography = _biography;
@synthesize hireable = _hireable;
@synthesize contributions = _contributions;


#pragma mark - Initializing an CDOHUser Instance
- (id)initWithJSONDictionary:(NSDictionary *)dictionary
{
	self = [super initWithJSONDictionary:dictionary];
	if (self) {
		_biography = [[dictionary objectForKey:kCDOHUserBioKey] copy];
		_hireable = [[dictionary objectForKey:kCDOHUserHireableKey] boolValue];
		_contributions = [[dictionary objectForKey:kCDOHUserContributionsKey] unsignedIntegerValue];
	}
	
	return self;
}


#pragma mark - Encoding Resources
- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		_biography = [[aDecoder decodeObjectForKey:kCDOHUserBioKey] copy];
		_hireable = [aDecoder decodeBoolForKey:kCDOHUserHireableKey];
		_contributions = [[aDecoder decodeObjectForKey:kCDOHUserContributionsKey] unsignedIntegerValue];
	}
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[super encodeWithCoder:aCoder];
	
	[aCoder encodeObject:_biography forKey:kCDOHUserBioKey];
	[aCoder encodeBool:_hireable forKey:kCDOHUserHireableKey];
	[aCoder encodeObject:[NSNumber numberWithUnsignedInteger:_contributions] forKey:kCDOHUserContributionsKey];
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
	return [self isEqualToUser:other];
}

- (BOOL)isEqualToUser:(CDOHUser *)aUser
{
	return [self isEqualToAbstractUser:aUser];
}


#pragma mark - Describing a User Object
- (NSString *)description
{	
	return [NSString stringWithFormat:@"<%@: %p { id = %d, login = %@, is authed = %@ }>",
			[self class],
			self,
			self.identifier,
			self.login,
			(self.isAuthenticated ? @"YES" : @"NO")];
}


@end
