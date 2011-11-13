//
//  AppDelegate.m
//  ObjectiveHub Test App
//
//  Created by Aron Cedercrantz on 2011-11-13.
//  Copyright (c) 2011 Icomera. All rights reserved.
//

#import "AppDelegate.h"

#import <ObjectiveHub/ObjectiveHub.h>
#import <ObjectiveHub/FGOHUser.h>
#import "FGOHUserPrivate.h"

#import "FGOHTestAppUserCredentials.h"


#define BoolToString(b) (b) ? @"YES" : @"NO"


@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	ObjectiveHub *hub = [[ObjectiveHub alloc] initWithUsername:FGOHTestAppUsername password:FGOHTestAppPassword];
	NSLog(@"hub: %@", hub);
	
	[hub userWithLogin:@"schacon"
			   success:^(FGOHUser *user) {
				   NSLog(@"user: %@", user);
			   }
			   failure:^(NSError *error) {
				   NSLog(@"failure: %@", error);
			   }];
}

@end
