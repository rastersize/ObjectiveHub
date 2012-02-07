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

@implementation CDOHClientTests

@synthesize client = _client;

#pragma mark - Test Life Cycle
- (void)setUp
{
	CDOHTestsUserCredentials *cred = [[CDOHTestsUserCredentials alloc] init];
	_client = [[CDOHClient alloc] initWithUsername:cred.username password:cred.password];
}

- (void)tearDown
{
	_client = nil;
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


@end
