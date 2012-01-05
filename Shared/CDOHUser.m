//
//  CDOHUser.m
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

#import "CDOHUser.h"
#import "CDOHUserPrivate.h"


#pragma mark NSCoding and GitHub JSON Keys
NSString *const kCDOHUserDictionaryHireableKey			= @"hireable";
NSString *const kCDOHUserDictionaryBioKey				= @"bio";


#pragma mark - CDOHUser Implementation
@implementation CDOHUser

#pragma mark - Synthesization
@synthesize biography = _biography;
@synthesize hireable = _hireable;


#pragma mark - Initializing an CDOHUser Instance
- (id)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super initWithDictionary:dictionary];
	if (self) {
		NSString *bio = [dictionary valueForKey:kCDOHUserDictionaryBioKey];
		_biography = [bio copy];
		
		NSNumber *hireable = [dictionary valueForKey:kCDOHUserDictionaryHireableKey];
		_hireable = [hireable boolValue];
	}
	
	return self;
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
	if (aUser == self) {
		return YES;
	}
	
	return (aUser.identifier == self.identifier);
}


#pragma mark - NSCoding Methods
- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super initWithCoder:decoder];
	
	NSDictionary *dictionary = [decoder decodeObjectForKey:@"CDOHUserPropertiesDictionary"];
	self = [self initWithDictionary:dictionary];
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
	[super encodeWithCoder:coder];

	NSNumber *hireableNumber	= [NSNumber numberWithBool:_hireable];
	NSDictionary *dictionary	= [NSDictionary dictionaryWithObjectsAndKeys:
								   _biography,		kCDOHUserDictionaryBioKey,
								   hireableNumber,	kCDOHUserDictionaryHireableKey,
								   nil];
	
	[coder encodeObject:dictionary forKey:@"CDOHUserPropertiesDictionary"];
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
