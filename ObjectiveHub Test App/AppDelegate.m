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
#import "CDOHResourcePrivate.h"
#import "CDOHTestAppUserCredentials.h"


#define BoolToString(b) (b) ? @"YES" : @"NO"


@implementation AppDelegate

@synthesize window = _window;
@synthesize hub = _hub;

- (void)applicationDidFinishLaunching:(NSNotification *__unused)aNotification
{
	dispatch_queue_t queue = dispatch_queue_create("com.cedercrantz.objectivehub.testapp", NULL);
	dispatch_suspend(queue);

	CDOHTestAppUserCredentials *cred = [[CDOHTestAppUserCredentials alloc] init];
	_hub = [[CDOHClient alloc] initWithUsername:cred.username password:cred.password];
	NSLog(@"hub: %@", self.hub);
	
	__weak AppDelegate *blockSelf = self;
	
	dispatch_async(queue, ^{
		[blockSelf.hub repositoriesWatchedByUser:@"rastersize" pages:nil success:^(CDOHResponse *response) {
			//NSLog(@"response: %@", response);
			CDOHRepository *repo = [((NSArray *)response.resource) lastObject];
			NSLog(@"repo: %@", repo);
			
			NSData *encodedData = [NSKeyedArchiver archivedDataWithRootObject:repo];
			CDOHRepository *decodedRepo = [NSKeyedUnarchiver unarchiveObjectWithData:encodedData];
			NSLog(@"decodedRepo: %@", decodedRepo);
			
			NSLog(@"[repo isEqual:decodedRepo] => %@", [repo isEqual:decodedRepo] ? @"YES" : @"NO");
			NSLog(@"[repo _APIResourceURL] == %@", [repo _APIResourceURL]);
			NSLog(@"[decodedRepo _APIResourceURL] == %@", [decodedRepo _APIResourceURL]);
		} failure:^(CDOHError *error) {
			NSLog(@"error %@", error);
		}];
	});
	
	dispatch_resume(queue);
	dispatch_release(queue);
	
	//NSLog(@"resource: %@", [CDOHResource encodableKeys]);
	//NSLog(@"org team: %@", [CDOHOrganizationTeam encodableKeys]);
	
	/*
	NSLog(@"resource: %@", [CDOHResource completePropertyToJSONKeyDictionary]);
	NSLog(@"abstract user: %@", [CDOHAbstractUser completePropertyToJSONKeyDictionary]);
	NSLog(@"user: %@", [CDOHUser completePropertyToJSONKeyDictionary]);
	NSLog(@"org: %@", [CDOHOrganization completePropertyToJSONKeyDictionary]);
	NSLog(@"org team: %@", [CDOHOrganizationTeam completePropertyToJSONKeyDictionary]);
	NSLog(@"plan: %@", [CDOHPlan completePropertyToJSONKeyDictionary]);
	NSLog(@"repo: %@", [CDOHRepository completePropertyToJSONKeyDictionary]);
	*/
	
	NSLog(@"DONE!");
}

@end
