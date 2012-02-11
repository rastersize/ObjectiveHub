//
//  CDOHPlanTests.m
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

#import "CDOHPlanTests.h"
#import "CDOHPlan.h"

@implementation CDOHPlanTests

#pragma mark - Tested Class
+ (Class)testedClass
{
	return [CDOHPlan class];
}


#pragma mark - Test Dictionaries
+ (NSDictionary *)firstTestDictionary
{
	static NSDictionary *dictionary = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSDictionary *superDict = [super firstTestDictionary];
		NSDictionary *localDict = [[NSDictionary alloc] initWithObjectsAndKeys:
								   @"small",						kCDOHPlanNameKey,
								   CDOHTestNumFromUInteger(1234),	kCDOHPlanSpaceKey,
								   CDOHTestNumFromUInteger(5),		kCDOHPlanCollaboratorsKey,
								   CDOHTestNumFromUInteger(10),		kCDOHPlanPrivateRepositoriesKey,
								   nil];
		
		dictionary = [CDOHResource mergeSubclassDictionary:localDict withSuperclassDictionary:superDict];
	});
	
	return dictionary;
}

// A plan is equal if all its properties are equal
+ (NSDictionary *)firstTestDictionaryAlt
{
	return [self firstTestDictionary];
}

+ (NSDictionary *)secondTestDictionary
{
	static NSDictionary *dictionary = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSDictionary *superDict = [super firstTestDictionary];
		NSDictionary *localDict = [[NSDictionary alloc] initWithObjectsAndKeys:
								   @"medium",						kCDOHPlanNameKey,
								   CDOHTestNumFromUInteger(1234),	kCDOHPlanSpaceKey,
								   CDOHTestNumFromUInteger(5),		kCDOHPlanCollaboratorsKey,
								   CDOHTestNumFromUInteger(10),		kCDOHPlanPrivateRepositoriesKey,
								   nil];

		
		dictionary = [CDOHResource mergeSubclassDictionary:localDict withSuperclassDictionary:superDict];
	});
	
	return dictionary;
}



@end
