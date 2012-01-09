//
//  CDOHTestAppUserCredentials.m
//  ObjectiveHub
//
//  Created by Aron Cedercrantz on 2012-01-09.
//  Copyright (c) 2012 Aron Cedercrantz. All rights reserved.
//

#import "CDOHTestAppUserCredentials.h"

@implementation CDOHTestAppUserCredentials

@synthesize username;
@synthesize password;

- (id)init
{
	self = [super init];
	if (self) {
		NSURL *accountPlistURL = [[NSBundle mainBundle] URLForResource:@"account" withExtension:@"plist"];
		NSDictionary *account = [NSDictionary dictionaryWithContentsOfURL:accountPlistURL];
		username = [account objectForKey:@"username"];
		password = [account objectForKey:@"password"];
	}
	
	return self;
}

@end
