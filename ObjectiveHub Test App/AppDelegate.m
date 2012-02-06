//
//  AppDelegate.h
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

#import "AppDelegate.h"

#import <ObjectiveHub/ObjectiveHub.h>

#pragma mark - Private Imports
#import "CDOHUserPrivate.h"
#import "CDOHTestAppUserCredentials.h"


#define BoolToString(b) (b) ? @"YES" : @"NO"


@implementation AppDelegate

@synthesize window = _window;
@synthesize hub = _hub;

- (void)applicationDidFinishLaunching:(NSNotification *)__unused aNotification
{
	dispatch_queue_t queue = dispatch_queue_create("com.cedercrantz.objectivehub.testapp", NULL);
	dispatch_suspend(queue);

	CDOHTestAppUserCredentials *cred = [[CDOHTestAppUserCredentials alloc] init];
	_hub = [[CDOHClient alloc] initWithUsername:cred.username password:cred.password];
	NSLog(@"hub: %@", self.hub);
	
	// Should fail:
	/*dispatch_async(queue, ^{
		[self.hub userWithLogin:@"schaconadad" success:^(CDOHUser *user) {
			NSLog(@"user 1: %@", user);
		} failure:^(CDOHError *error) {
			NSLog(@"user 1 failure: %@", error);
		}];
	});*/
	
	// Should succeed:
	/*dispatch_async(queue, ^{
		[self.hub userWithLogin:@"schacon" success:^(CDOHUser *user) {
			NSLog(@"user 2: %@", user);
		} failure:^(CDOHError *error) {
			NSLog(@"user 2 failure: %@", error);
		}];
	});*/
	/*
	// Should succeed.
	dispatch_async(queue, ^{
		[self.hub userWithLogin:CDOHTestAppUsername success:^(CDOHUser *user) {
			NSLog(@"authed user: %@", user);
		} failure:^(CDOHError *error) {
			NSLog(@"authed user failure: %@", error);
		}];
	});
	 
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
	dispatch_async(queue, ^{
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
	});
	
	// Should succeed:
	dispatch_async(queue, ^{
		[self.hub userEmails:^(NSArray *emails) {
			NSLog(@"emails: %@", emails);
		} failure:^(CDOHError *error) {
			NSLog(@"emails failure: %@", error);
		}];
	});
	
	// Should succeed:
	NSArray *addEmails = [[NSArray alloc] initWithObjects:@"test2@fruitisgood.com", @"test3@fruitisgood.com", nil];
	__weak ObjectiveHub *weakHub = self.hub;
	dispatch_async(queue, ^{
		[self.hub addUserEmails:addEmails success:^(NSArray *emails) {
			NSLog(@"add emails: %@", emails);
			[weakHub deleteUserEmails:addEmails
							  success:^{ NSLog(@"deleted the emails: %@", addEmails); }
							  failure:^(CDOHError __unused *error) { NSLog(@"delete emails failure: %@", addEmails); }];
		} failure:^(CDOHError *error) {
			NSLog(@"add emails failure: %@", error);
		}];
	});
	
	// Should yield at least 1 user
	dispatch_async(queue, ^{
		[self.hub watchersOfRepository:@"CDEvents" repositoryOwner:@"rastersize" success:^(NSArray *watchers) {
			NSLog(@"repo watchers: %@", watchers);
		} failure:^(CDOHError *error) {
			NSLog(@"repo watchers failed: %@", error);
		}];
	});
	
	// Should yield an enormouse amount of people
	dispatch_async(queue, ^{
		[self.hub watchersOfRepository:@"bootstrap" repositoryOwner:@"twitter" success:^(NSArray *watchers, NSDictionary *responseDict) {
			NSLog(@"repo watchers: %@", watchers);
			NSLog(@"repo response dict: %@", responseDict);
		} failure:^(CDOHError *error) {
			NSLog(@"repo watchers failed: %@", error);
		}];
	});
	
	[self.hub userWithLogin:nil success:^(CDOHUser *user) {
		NSLog(@"should not be called, user: %@", user);
	} failure:^(CDOHError *error) {
		NSLog(@"error desc: %@", error);
		NSLog(@"error reason: %@", [error localizedFailureReason]);
		NSLog(@"error recovery sugg: %@", [error localizedRecoverySuggestion]);
	}];
	
	BOOL didThrowException = NO;
	@try {
		[self.hub userWithLogin:nil success:NULL failure:NULL];
	} @catch (NSException *e) {
		didThrowException = YES;
		NSLog(@"%@", e);
	}
	NSLog(@"didThrowExeption: %@", didThrowException ? @"YES" : @"NO");*/
	
	dispatch_async(queue, ^{
		[self.hub repository:@"CDEvents" owner:@"rastersize" success:^(CDOHResponse *response) {
			NSLog(@"repository response: %@", response);
		} failure:^(CDOHError *error) {
			NSLog(@"repository failure: %@", error);
		}];
	});
	
	/*dispatch_async(queue, ^{
		[self.hub repositoriesWatchedByUser:@"rastersize" pages:nil success:^(CDOHResponse *response) {
			NSLog(@"%@", response);
			NSLog(@"%@", response.resource);
			NSLog(@"paginated: %d", response.isPaginated);
			NSLog(@"page: %lu", response.page);
			NSLog(@"hasNextPage: %d", response.hasNextPage);
			NSLog(@"nextPage: %lu", response.nextPage);
			NSLog(@"hasPreviousPage: %d", response.hasPreviousPage);
			NSLog(@"previousPage: %lu", response.previousPage);
			NSLog(@"lastPage: %lu", response.lastPage);
			
			if (response.hasNextPage && response.nextPage == 2) {
				NSLog(@"Loading page 2…");
				[response loadNextPage];
			}
		} failure:^(CDOHError *error) {
			NSLog(@"repos watched by error: %@", error);
		}];
	});*/
	
	dispatch_resume(queue);
}

@end
