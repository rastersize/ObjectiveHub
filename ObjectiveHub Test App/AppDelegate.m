//
//  AppDelegate.m
//  ObjectiveHub Test App
//
//  Created by Aron Cedercrantz on 2011-11-13.
//  Copyright (c) 2011 Icomera. All rights reserved.
//

#import "AppDelegate.h"

#import <ObjectiveHub/ObjectiveHub.h>
#import <ObjectiveHub/CDOHError.h>
#import <ObjectiveHub/CDOHUser.h>


#pragma mark - Private Imports
#import "CDOHUserPrivate.h"
#import "CDOHTestAppUserCredentials.h"


#define BoolToString(b) (b) ? @"YES" : @"NO"


@implementation AppDelegate

@synthesize window = _window;
@synthesize hub = _hub;

- (void)applicationDidFinishLaunching:(NSNotification *)__unused aNotification
{
	_hub = [[ObjectiveHub alloc] initWithUsername:CDOHTestAppUsername password:CDOHTestAppPassword];
	NSLog(@"hub: %@", self.hub);
	
	// Should fail:
	[self.hub userWithLogin:@"schaconadad" success:^(CDOHUser *user) {
		NSLog(@"user 1: %@", user);
	} failure:^(CDOHError *error) {
		NSLog(@"user 1 failure: %@", error);
	}];
	
	// Should succeed:
	[self.hub userWithLogin:@"schacon" success:^(CDOHUser *user) {
		NSLog(@"user 2: %@", user);
	} failure:^(CDOHError *error) {
		NSLog(@"user 2 failure: %@", error);
	}];
	
	// Should succeed.
	[self.hub userWithLogin:CDOHTestAppUsername success:^(CDOHUser *user) {
		NSLog(@"authed user: %@", user);
	} failure:^(CDOHError *error) {
		NSLog(@"authed user failure: %@", error);
	}];
	
	// Should succeed:
	NSDictionary *updateUserDefaultDict = [NSDictionary dictionaryWithObjectsAndKeys:
										   [[NSDate date] description], kCDOHUserDictionaryNameKey,
										   @"test@example.com", kCDOHUserDictionaryEmailKey,
										   @"http://example.com/", kCDOHUserDictionaryBlogKey,
										   @"Example", kCDOHUserDictionaryCompanyKey,
										   @"localhost", kCDOHUserDictionaryLocationKey,
										   [NSNumber numberWithBool:NO], kCDOHUserDictionaryHireableKey,
										   @"No bio", kCDOHUserDictionaryBioKey,
										   nil];
	NSDictionary *updateUserDict = [NSDictionary dictionaryWithObjectsAndKeys:
									[[NSDate date] description], kCDOHUserDictionaryNameKey,
									@"github@example.com", kCDOHUserDictionaryEmailKey,
									@"http://example.org/blog", kCDOHUserDictionaryBlogKey,
									@"Example Corp", kCDOHUserDictionaryCompanyKey,
									@"California", kCDOHUserDictionaryLocationKey,
									[NSNumber numberWithBool:YES], kCDOHUserDictionaryHireableKey,
									@"Test user biography", kCDOHUserDictionaryBioKey,
									nil];
	[self.hub updateUserWithDictionary:updateUserDict success:^(CDOHUser *updatedUser) {
		NSLog(@"update user: %@ (location: %@)", updatedUser, updatedUser.location);
		[self.hub updateUserWithDictionary:updateUserDefaultDict success:^(CDOHUser *innerUpdatedUser) {
			NSLog(@"update user to default: %@ (location: %@)", innerUpdatedUser, innerUpdatedUser.location);
		} failure:^(CDOHError *error) {
			NSLog(@"update user to default failure: %@", error);
		}];
	} failure:^(CDOHError *error) {
		NSLog(@"update user failure: %@", error);
	}];
	
	// Should succeed:
	[self.hub userEmails:^(NSArray *emails) {
		NSLog(@"emails: %@", emails);
	} failure:^(CDOHError *error) {
		NSLog(@"emails failure: %@", error);
	}];
	
	// Should succeed:
	NSArray *addEmails = [[NSArray alloc] initWithObjects:@"test2@fruitisgood.com", @"test3@fruitisgood.com", nil];
	__weak ObjectiveHub *weakHub = self.hub;
	[self.hub addUserEmails:addEmails success:^(NSArray *emails) {
		NSLog(@"add emails: %@", emails);
		[weakHub deleteUserEmails:addEmails
						  success:^{ NSLog(@"deleted the emails: %@", addEmails); }
						  failure:^(CDOHError *error) { NSLog(@"delete emails failure: %@", addEmails); }];
	} failure:^(CDOHError *error) {
		NSLog(@"add emails failure: %@", error);
	}];
}

@end
