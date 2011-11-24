//
//  AppDelegate.m
//  ObjectiveHub Test App
//
//  Created by Aron Cedercrantz on 2011-11-13.
//  Copyright (c) 2011 Icomera. All rights reserved.
//

#import "AppDelegate.h"

#import <ObjectiveHub/ObjectiveHub.h>
#import <ObjectiveHub/FGOHError.h>

#import <ObjectiveHub/FGOHUser.h>

#import "FGOHUserPrivate.h"

#import "FGOHTestAppUserCredentials.h"


#define BoolToString(b) (b) ? @"YES" : @"NO"

#define TEST_APP_TEST_ADD_USER_EMAILS		1


@implementation AppDelegate

@synthesize window = _window;
@synthesize hub = _hub;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	_hub = [[ObjectiveHub alloc] initWithUsername:FGOHTestAppUsername password:FGOHTestAppPassword];
	NSLog(@"hub: %@", self.hub);
	
	// Should fail:
	[self.hub userWithLogin:@"schaconadad" success:^(FGOHUser *user) {
		NSLog(@"user 1: %@", user);
	} failure:^(FGOHError *error) {
		NSLog(@"user 1 failure: %@", error);
	}];
	
	// Should succeed:
	[self.hub userWithLogin:@"schacon" success:^(FGOHUser *user) {
		NSLog(@"user 2: %@", user);
	} failure:^(FGOHError *error) {
		NSLog(@"user 2 failure: %@", error);
	}];
	
	// Should succeed.
	[self.hub userWithLogin:FGOHTestAppUsername success:^(FGOHUser *user) {
		NSLog(@"authed user: %@", user);
	} failure:^(FGOHError *error) {
		NSLog(@"authed user failure: %@", error);
	}];
	
	// Should succeed.
	[self.hub userWithLogin:FGOHTestAppUsername success:^(FGOHUser *user) {
		NSLog(@"authed user: %@", user);
	} failure:^(FGOHError *error) {
		NSLog(@"authed user failure: %@", error);
	}];
	
	// Should succeed:
	[self.hub userEmails:^(NSArray *emails) {
		NSLog(@"emails: %@", emails);
	} failure:^(FGOHError *error) {
		NSLog(@"emails failure: %@", error);
	}];
	
	// Should succeed:
#if TEST_APP_TEST_ADD_USER_EMAILS
	NSArray *addEmails = [[NSArray alloc] initWithObjects:@"test2@fruitisgood.com", @"test3@fruitisgood.com", nil];
	__weak ObjectiveHub *weakHub = self.hub;
	[self.hub addUserEmails:addEmails success:^(NSArray *emails) {
		NSLog(@"add emails: %@", emails);
		[weakHub deleteUserEmails:addEmails
						  success:^{ NSLog(@"deleted the emails: %@", addEmails); }
						  failure:^(FGOHError *error) { NSLog(@"delete emails failure: %@", addEmails); }];
	} failure:^(FGOHError *error) {
		NSLog(@"add emails failure: %@", error);
	}];
#endif
	
	
}

@end
