//
//  CDOHPLan.h
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

#import "CDOHPLan.h"
#import "CDOHResourcePrivate.h"


#pragma mark JSON Dictionary Keys
NSString *const kCDOHPlanNameKey					= @"name";
NSString *const kCDOHPlanSpaceKey					= @"space";
NSString *const kCDOHPlanCollaboratorsKey			= @"collaborators";
NSString *const kCDOHPlanPrivateRepositoriesKey		= @"private_repos";


@implementation CDOHPlan

#pragma mark - Properties
@synthesize name = _name;
@synthesize space = _space;
@synthesize collaboratorsCount = _collaboratorsCount;
@synthesize privateRepositoriesCount = _privateRepositoriesCount;


#pragma mark - Creating and Initializing Resources
- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary
{
	self = [super initWithJSONDictionary:jsonDictionary];
	if (self) {
		_name = [[jsonDictionary cdoh_objectOrNilForKey:kCDOHPlanNameKey] copy];
		
		_space = [jsonDictionary cdoh_unsignedIntegerForKey:kCDOHPlanSpaceKey];
		_collaboratorsCount = [jsonDictionary cdoh_unsignedIntegerForKey:kCDOHPlanCollaboratorsKey];
		_privateRepositoriesCount = [jsonDictionary cdoh_unsignedIntegerForKey:kCDOHPlanPrivateRepositoriesKey];
	}
	
	return self;
}


#pragma mark - Encoding Resources
- (void)encodeWithJSONDictionary:(NSMutableDictionary *)jsonDictionary
{
	[super encodeWithJSONDictionary:jsonDictionary];
	
	[jsonDictionary cdoh_setObject:_name forKey:kCDOHPlanNameKey];
	
	[jsonDictionary cdoh_setUnsignedInteger:_space forKey:kCDOHPlanSpaceKey];
	[jsonDictionary cdoh_setUnsignedInteger:_collaboratorsCount forKey:kCDOHPlanCollaboratorsKey];
	[jsonDictionary cdoh_setUnsignedInteger:_privateRepositoriesCount forKey:kCDOHPlanPrivateRepositoriesKey];
}


#pragma mark - 
+ (void)JSONKeyToPropertyNameDictionary:(NSMutableDictionary *)dictionary
{
	[super JSONKeyToPropertyNameDictionary:dictionary];
	
	CDOHSetPropertyForJSONKey(name,						kCDOHPlanNameKey, dictionary);
	CDOHSetPropertyForJSONKey(space,					kCDOHPlanSpaceKey, dictionary);
	CDOHSetPropertyForJSONKey(collaboratorsCount,		kCDOHPlanCollaboratorsKey, dictionary);
	CDOHSetPropertyForJSONKey(privateRepositoriesCount,	kCDOHPlanPrivateRepositoriesKey, dictionary);
}

+ (NSDictionary *)JSONKeyToPropertyName
{
	static NSDictionary *JSONKeyToPropertyName = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
		[CDOHPlan JSONKeyToPropertyNameDictionary:dictionary];
		JSONKeyToPropertyName = [dictionary copy];
	});
	return JSONKeyToPropertyName;
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
			aPlan.collaboratorsCount == self.collaboratorsCount &&
			aPlan.privateRepositoriesCount == self.privateRepositoriesCount);
}

- (NSUInteger)hash
{
	NSUInteger prime = 31;
	NSUInteger hash = 1;
	
	hash = [self.name hash];
	hash = prime * hash + self.space;
	hash = prime * hash + self.collaboratorsCount;
	hash = prime * hash + self.privateRepositoriesCount;
	
	return hash;
}

@end
