//
//  CDOHClientTests.h
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


#import "CDOHClientTests.h"
#import "CDOHTestsUserCredentials.h"

#import "CDOHClient.h"
#import "CDOHError.h"
#import "CDOHResponse.h"
#import "CDOHUser.h"
#import "CDOHPlan.h"


@implementation CDOHClientTests {
	dispatch_queue_t _queue;
}

@synthesize client = _client;

#pragma mark - Test Life Cycle
- (void)setUp
{
	_queue = dispatch_get_main_queue(); //dispatch_queue_create("com.libobjectivehub.tests.CDOHClientTests", DISPATCH_QUEUE_SERIAL);
	
	CDOHTestsUserCredentials *cred = [[CDOHTestsUserCredentials alloc] init];
	_client = [[CDOHClient alloc] initWithUsername:cred.username password:cred.password];
}

- (void)tearDown
{
	//_client = nil;
}


#pragma mark - CDOHPagesArrayForPageIndexes Tests
- (void)testCDOHPagesArrayForPageIndexesMacro
{
	NSArray *controlArray = [[NSArray alloc] initWithObjects:
							 [NSNumber numberWithUnsignedInteger:9],
							 [NSNumber numberWithUnsignedInteger:2],
							 [NSNumber numberWithUnsignedInteger:123124],
							 [NSNumber numberWithUnsignedInteger:84239847392],
							 [NSNumber numberWithUnsignedInteger:0],
							 [NSNumber numberWithUnsignedInteger:1],
							 nil];
	
	NSArray *pages = CDOHPagesArrayForPageIndexes(9, 2, 123124, 84239847392, 0, 1);
	
	STAssertTrue([pages isEqual:controlArray], @"Pages array should be equal to control array");
}


#pragma mark - CDOHClient Class Tests
- (void)testInitWithUsernameAndPassword
{
	NSString *username = @"testUser";
	NSString *password = @"testPassword";
	
	CDOHClient *objHub = [[CDOHClient alloc] initWithUsername:username password:password];
	
	STAssertNotNil(objHub, @"ObjectiveHub instance objHub should not return nil");
	STAssertTrue(objHub.username == username, @"objHub.username should be equal to username");
	STAssertTrue(objHub.password == password, @"objHub.password should be equal to password");
}


#pragma mark - GitHub Communication Tests
- (void)testNoAuthenticatedUser
{
	__unsafe_unretained CDOHClientTests *blockSelf = self;
	
	// Should call failure block immediately
	dispatch_async(_queue, ^{
		NSString *tmpUsername = self.client.username;
		NSString *tmpPassword = self.client.password;
		
		blockSelf.client.username = nil;
		blockSelf.client.password = nil;
		STAssertNoThrow(
			[blockSelf.client user:^(CDOHResponse *response) {
				STAssertTrue(NO, @"Should always fail when no authenticated user is set (response: %@)", response);
			} failure:^(CDOHError *error) {
				STAssertEqualObjects(kCDOHErrorDomain, [error domain], @"Error domain should be kCDOHErrorDomain (%@) was %@", kCDOHErrorDomain, [error domain]);
				STAssertTrue(kCDOHErrorCodeNoAuthenticatedUser == [error code], @"Error code when no authed user is set should be kCDOHErrorCodeNoAuthenticatedUser (%d) was (%d)", kCDOHErrorCodeNoAuthenticatedUser, [error code]);
			}],
			@"Should not throw any exception but call the failure block."
		);
		blockSelf.client.username = tmpUsername;
		blockSelf.client.password = tmpPassword;
	});
	
	// Should call failure block immediately
	dispatch_async(_queue, ^{
		NSString *tmpUsername = blockSelf.client.username;
		NSString *tmpPassword = blockSelf.client.password;
		
		blockSelf.client.username = @"login";
		blockSelf.client.password = nil;
		STAssertNoThrow(
			[blockSelf.client user:^(CDOHResponse *response) {
				STAssertTrue(NO, @"Should always fail when no authenticated user is set (response: %@)", response);
			} failure:^(CDOHError *error) {
				STAssertEqualObjects(kCDOHErrorDomain, [error domain], @"Error domain should be kCDOHErrorDomain (%@) was %@", kCDOHErrorDomain, [error domain]);
				STAssertTrue(kCDOHErrorCodeNoAuthenticatedUser == [error code], @"Error code when no authed user is set should be kCDOHErrorCodeNoAuthenticatedUser (%d) was (%d)", kCDOHErrorCodeNoAuthenticatedUser, [error code]);
			}],
			@"Should not throw any exception but call the failure block."
		);
		blockSelf.client.username = tmpUsername;
		blockSelf.client.password = tmpPassword;
	});
	
	// Should call failure block immediately
	dispatch_async(_queue, ^{
		NSString *tmpUsername = blockSelf.client.username;
		NSString *tmpPassword = blockSelf.client.password;
		
		blockSelf.client.username = nil;
		blockSelf.client.password = @"password";
		STAssertNoThrow(
			[self.client user:^(CDOHResponse *response) {
				STAssertTrue(NO, @"Should always fail when no authenticated user is set (response: %@)", response);
			} failure:^(CDOHError *error) {
				STAssertEqualObjects(kCDOHErrorDomain, [error domain], @"Error domain should be kCDOHErrorDomain (%@) was %@", kCDOHErrorDomain, [error domain]);
				STAssertTrue(kCDOHErrorCodeNoAuthenticatedUser == [error code], @"Error code when no authed user is set should be kCDOHErrorCodeNoAuthenticatedUser (%d) was (%d)", kCDOHErrorCodeNoAuthenticatedUser, [error code]);
			}],
			@"Should not throw any exception but call the failure block."
		);
		blockSelf.client.username = tmpUsername;
		blockSelf.client.password = tmpPassword;
	});
	
	// Should throw an exception named NSInternalInconsistencyException
	// Should call failure block immediately
	dispatch_async(_queue, ^{
		NSString *tmpUsername = blockSelf.client.username;
		NSString *tmpPassword = blockSelf.client.password;
		
		blockSelf.client.username = nil;
		blockSelf.client.password = nil;
		STAssertThrows(
		//STAssertThrowsSpecificNamed(
			[blockSelf.client user:^(CDOHResponse *response) {
				STAssertTrue(NO, @"Should always fail when no authenticated user is set (response: %@)", response);
			} failure:NULL],
			//NSException,
			//NSInternalInconsistencyException,
			@"Should always fail with an NSInternalInconsistencyException when no authenticated user is set (username set = %@, password set = %@.",
			(blockSelf.client.username ? @"YES" : @"NO"),
			(blockSelf.client.password ? @"YES" : @"NO")
		);
		blockSelf.client.username = tmpUsername;
		blockSelf.client.password = tmpPassword;
	});
}

- (void)testGetAuthenticatedUser
{
	__unsafe_unretained CDOHClientTests *blockSelf = self;
	
	dispatch_async(_queue, ^{
		[blockSelf.client user:^(CDOHResponse *response) {
			STAssertTrue([response.resource isKindOfClass:[CDOHUser class]], @"Resource should be a CDOHUser instance was: %@", [response.resource class]);
			
			CDOHUser *user = response.resource;
			STAssertEqualObjects(blockSelf.client.username, user.login, @"Client username (%@) should match user login (%@).", blockSelf.client.username, user.login);
			STAssertTrue(user.isAuthenticated, @"User object recieved should be authenticated.");
			STAssertNotNil(user.plan, @"Authenticated user’s plan should not be nil.");
			STAssertTrue([user.plan isKindOfClass:[CDOHPlan class]], @"Authenticated user’s plan should be of type CDOHPlan was %@.", [user.plan class]);
		} failure:^(CDOHError *error) {
			STAssertTrue(NO, @"Request failed with error: %@", error);
		}];
	});
}

- (void)testGetUserWithLogin
{
	__unsafe_unretained CDOHClientTests *blockSelf = self;
	
	dispatch_async(_queue, ^{
		NSString *login = @"octocat";
		NSLog(@"blockSelf: %@", blockSelf);
		[blockSelf.client userWithLogin:login success:^(CDOHResponse *response) {
			NSLog(@"det här går liiite fort imo");
			STAssertTrue([response.resource isKindOfClass:[CDOHUser class]], @"Resource should be a CDOHUser instance was: %@", [response.resource class]);
			
			CDOHUser *user = response.resource;
			STAssertEqualObjects(login, user.login, @"Client username (%@) should match user login (%@).", login, user.login);
			STAssertFalse(!user.isAuthenticated, @"User object recieved should not be authenticated.");
			STAssertNil(user.plan, @"Authenticated user’s plan should be nil.");
			STAssertEqualObjects(@"octocat@github.com", user.email, @"Email address should be %@ was %@", @"octocat@github.com", user.email);
			STAssertEqualObjects([NSURL URLWithString:@"http://www.github.com/blog"], user.htmlURL, @"HTML URL should be %@ was %@", [NSURL URLWithString:@"http://www.github.com/blog"], user.htmlURL);
		} failure:^(CDOHError *error) {
			STAssertTrue(NO, @"Request failed with error: %@", error);
		}];
	});
}


@end
