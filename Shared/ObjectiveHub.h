//
//  ObjectiveHub.h
//  ObjectiveHub
//
//  Created by Aron Cedercrantz on 2011-11-09.
//  Copyright (c) 2011 Fruit is Good. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark Constants


#pragma mark - ObjectiveHub Interface
/**
 * Objective-C class for comunicating with GitHub.
 *
 * Currently version 3 of the GitHub API is used internally.
 */
@interface ObjectiveHub : NSObject

#pragma mark - Initializing ObjectiveHub
/** @name Initializing ObjectiveHub */
/**
 * Initializes and returns an `ObjectiveHub` instance that uses the given
 * username and password for authentication with GitHub.
 *
 * @param username The username used to authenticate with GitHub.
 * @param password The password used to authenticate with GitHub.
 * @return An `ObjectiveHub` instance initialized with the given username and 
 * password.
 */
- (id)initWithUsername:(NSString *)username password:(NSString *)password;


#pragma mark - User Credentials
/** @name User Credentials */
/**
 * The username used to authenticate with GitHub.
 *
 * @see password
 */
@property (copy) NSString *username;

/**
 * The password used to authenticate with GitHub.
 *
 * @see username
 */
@property (copy) NSString *password;




@end
