//
//  CDOHPlan.m
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

#import "CDOHPlan.h"
#import "CDOHPlanPrivate.h"
#import "CDOHResourcePrivate.h"


#pragma mark Dictionary Keys
NSString *const kCDOHPlanNameKey					= @"name";
NSString *const kCDOHPlanSpaceKey					= @"space";
NSString *const kCDOHPlanCollaboratorsKey			= @"collaborators";
NSString *const kCDOHPlanPrivateRepositoriesKey	= @"private_repos";


#pragma mark - CDOHPlan Implementation
@implementation CDOHPlan

#pragma mark - Synthesizing
@synthesize name = _name;
@synthesize space = _space;
@synthesize collaborators = _collaborators;
@synthesize privateRepositories = _privateRepositories;


#pragma mark - Initializing an CDOHPlan Instance
- (id)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super initWithDictionary:dictionary];
	if (self) {
		_name = [[dictionary valueForKey:kCDOHPlanNameKey] copy];
		
		_space = [[dictionary valueForKey:kCDOHPlanSpaceKey] unsignedIntegerValue];
		_collaborators = [[dictionary valueForKey:kCDOHPlanCollaboratorsKey] unsignedIntegerValue];
		_privateRepositories = [[dictionary valueForKey:kCDOHPlanPrivateRepositoriesKey] unsignedIntegerValue];
	}
	
	return self;
}


#pragma mark - Encoding Resources
- (NSDictionary *)encodeAsDictionary
{
	NSDictionary *finalDictionary = nil;
	NSDictionary *superDictionary = [super encodeAsDictionary];
	
	NSNumber *spaceNumber			= [NSNumber numberWithUnsignedInteger:self.space];
	NSNumber *collaboratorsNumber	= [NSNumber numberWithUnsignedInteger:self.collaborators];
	NSNumber *privateReposNumber	= [NSNumber numberWithUnsignedInteger:self.privateRepositories];
	
	NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
								self.name,				kCDOHPlanNameKey,
								spaceNumber,			kCDOHPlanSpaceKey,
								collaboratorsNumber,	kCDOHPlanCollaboratorsKey,
								privateReposNumber,		kCDOHPlanPrivateRepositoriesKey,
								nil];
	
	finalDictionary = [CDOHResource mergeSubclassDictionary:dictionary withSuperclassDictionary:superDictionary];
	return finalDictionary;
}


#pragma mark - Identifying and Comparing Plans
- (BOOL)isEqual:(id)other
{
	if (other == self) {
		return YES;
	}
	if (!other || ![other isKindOfClass:[self class]]) {
		return NO;
	}
	return [self isEqualToPlan:other];
}

- (BOOL)isEqualToPlan:(CDOHPlan *)aPlan
{
	if (aPlan == self) {
		return YES;
	}
	
	return ([aPlan.name isEqualToString:self.name] &&
			aPlan.space == self.space &&
			aPlan.collaborators == self.collaborators &&
			aPlan.privateRepositories == self.privateRepositories);
}

- (NSUInteger)hash
{
	NSUInteger prime = 31;
	NSUInteger hash = 1;
	
	hash = [self.name hash];
	hash = prime * hash + self.space;
	hash = prime * hash + self.collaborators;
	hash = prime * hash + self.privateRepositories;
	
	return hash;
}


#pragma mark - Describing a Plan Object
- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@: %p { name = %@ }>", [self class], self, self.name];
}


@end
