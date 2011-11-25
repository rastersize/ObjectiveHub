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
#import <ObjectiveHub/CDOHUser.h>


#pragma mark - Private Imports
#import "CDOHUserPrivate.h"
#import "FGOHTestAppUserCredentials.h"


#define BoolToString(b) (b) ? @"YES" : @"NO"


@implementation AppDelegate

@synthesize window = _window;
@synthesize hub = _hub;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	_hub = [[ObjectiveHub alloc] initWithUsername:FGOHTestAppUsername password:FGOHTestAppPassword];
	NSLog(@"hub: %@", self.hub);
	
	// Should fail:
	[self.hub userWithLogin:@"schaconadad" success:^(CDOHUser *user) {
		NSLog(@"user 1: %@", user);
	} failure:^(FGOHError *error) {
		NSLog(@"user 1 failure: %@", error);
	}];
	
	// Should succeed:
	[self.hub userWithLogin:@"schacon" success:^(CDOHUser *user) {
		NSLog(@"user 2: %@", user);
	} failure:^(FGOHError *error) {
		NSLog(@"user 2 failure: %@", error);
	}];
	
	// Should succeed.
	[self.hub userWithLogin:FGOHTestAppUsername success:^(CDOHUser *user) {
		NSLog(@"authed user: %@", user);
	} failure:^(FGOHError *error) {
		NSLog(@"authed user failure: %@", error);
	}];
	
	// Should succeed:
	NSDictionary *updateUserDefaultDict = [NSDictionary dictionaryWithObjectsAndKeys:
										   [[NSDate date] description], kFGOHUserDictionaryNameKey,
										   @"test@example.com", kFGOHUserDictionaryEmailKey,
										   @"http://example.com/", kFGOHUserDictionaryBlogKey,
										   @"Example", kFGOHUserDictionaryCompanyKey,
										   @"localhost", kFGOHUserDictionaryLocationKey,
										   [NSNumber numberWithBool:NO], kFGOHUserDictionaryHireableKey,
										   @"No bio", kFGOHUserDictionaryBioKey,
										   nil];
	NSDictionary *updateUserDict = [NSDictionary dictionaryWithObjectsAndKeys:
									[[NSDate date] description], kFGOHUserDictionaryNameKey,
									@"github@example.com", kFGOHUserDictionaryEmailKey,
									@"http://example.org/blog", kFGOHUserDictionaryBlogKey,
									@"Example Corp", kFGOHUserDictionaryCompanyKey,
									@"California", kFGOHUserDictionaryLocationKey,
									[NSNumber numberWithBool:YES], kFGOHUserDictionaryHireableKey,
									@"Test user biography", kFGOHUserDictionaryBioKey,
									nil];
	[self.hub updateUserWithDictionary:updateUserDict success:^(CDOHUser *updatedUser) {
		NSLog(@"update user: %@ (location: %@)", updatedUser, updatedUser.location);
		[self.hub updateUserWithDictionary:updateUserDefaultDict success:^(CDOHUser *updatedUser) {
			NSLog(@"update user to default: %@ (location: %@)", updatedUser, updatedUser.location);
		} failure:^(FGOHError *error) {
			NSLog(@"update user to default failure: %@", error);
		}];
	} failure:^(FGOHError *error) {
		NSLog(@"update user failure: %@", error);
	}];
	
	// Should succeed:
	[self.hub userEmails:^(NSArray *emails) {
		NSLog(@"emails: %@", emails);
	} failure:^(FGOHError *error) {
		NSLog(@"emails failure: %@", error);
	}];
	
	// Should succeed:
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
}

@end
