//
//  ObjectiveHub_MacTests.m
//  ObjectiveHub-MacTests
//
//  Created by Aron Cedercrantz on 2011-11-09.
//  Copyright (c) 2011 Icomera. All rights reserved.
//

#import "ObjectiveHub_Tests.h"
#import "CDOHClient.h"

@implementation ObjectiveHub_Tests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testInitWithUsernameAndPassword
{
	NSString *username = @"testUser";
	NSString *password = @"testPassword";
	
	CDOHClient *objHub = [[CDOHClient alloc] initWithUsername:username password:password];
	
	STAssertNotNil(objHub, @"ObjectiveHub instance objHub should not return nil");
	STAssertTrue(objHub.username == username, @"objHub.username should be equal to username");
	STAssertTrue(objHub.password == password, @"objHub.password should be equal to password");
}

@end
