//
//  CDOHClient.m
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

#import "CDOHClient.h"
#import "CDOHClientPrivate.h"
#import "CDOHClientProtocol.h"

#import "CDOHCommon.h"
#import "CDOHLibraryVersion.h"
#import "CDOHError.h"
#import "CDOHLinkRelationshipHeader.h"
#import "CDOHResponse.h"
#import "CDOHResponsePrivate.h"

#import "CDOHNetworkClient.h"
#import "CDOHNetworkClientReply.h"
#import "CDOHAFNetworkingClient.h"

#import "CDOHResource.h"
#import "CDOHResourcePrivate.h"
#import "CDOHAbstractUser.h"
#import "CDOHUser.h"
#import "CDOHOrganization.h"
#import "CDOHOrganizationTeam.h"
#import "CDOHPlan.h"
#import "CDOHRepository.h"

#import "UIApplication+ObjectiveHub.h"

#import <objc/runtime.h>


#pragma mark GitHub API Base URI
/// The base URI for the GitHub API
NSString *const kCDOHGitHubBaseAPIURIString	= @"https://api.github.com";


#pragma mark - GitHub Mime Types
/// Mime type for getting the default type of data as JSON.
NSString *const kCDOHGitHubMimeGenericJSON	= @"application/vnd.github.v3+json";
/// Mime type for getting the raw data as JSON.
NSString *const kCDOHGitHubMimeRawJSON		= @"application/vnd.github.v3.raw+json";
/// Mime type for getting the text only representation of the data, as JSON.
NSString *const kCDOHGitHubMimeTextInJSON	= @"application/vnd.github.v3.text+json";
/// Mime type for getting the resource rendered as HTML as JSON.
NSString *const kCDOHGitHubMimeHtmlInJSON	= @"application/vnd.github.v3.html+json";
/// Mime type for getting raw, text and html versions of a resource in the same
/// response as JSON.
NSString *const kCDOHGitHubMimeFullInJSON	= @"application/vnd.github.v3.full+json";
/// Mime type for getting raw blob data (**not** wrapped in a JSON object).
NSString *const kCDOHGitHubMimeRaw			= @"application/vnd.github.v3.raw";


#pragma mark - ObjectiveHub User Agent
/// ObjectiveHub User Agent Format String
NSString *const kCDOHUserAgentFormat						= @"ObjectiveHub/%@";


#pragma mark - HTTP Header Response Keys
NSString *const kCDOHResponseHeaderXRateLimitLimitKey		= @"X-RateLimit-Limit";
NSString *const kCDOHResponseHeaderXRateLimitRemainingKey	= @"X-RateLimit-Remaining";
NSString *const kCDOHResponseHeaderLocationKey				= @"Location";
NSString *const kCDOHResponseHeaderLinkKey					= @"Link";


#pragma mark - GitHub Relative API Path (Formats)
#pragma mark |- Path Format Keys
NSString *const kCDOHResourceKey							= @"resource";
NSString *const kCDOHPropertyKey							= @"property";
NSString *const kCDOHIdentifierKey							= @"identifier";
NSString *const kCDOHOwnerKey								= @"owner";
NSString *const kCDOHRepositoryKey							= @"repo";
NSString *const kCDOHBaseKey								= @"base";
NSString *const kCDOHHeadKey								= @"head";

#pragma mark |- Resource Path Formats
/// The relative path for a :resource.
NSString *const kCDOHResourcePathFormat						= @"/:resource";
/// The relative path for a :property of a :resource.
NSString *const kCDOHResourcePropertyPathFormat				= @"/:resource/:property";
/// The relative path for a specific :resource identified using :identifier.
NSString *const kCDOHIdentifiedResourcePathFormat			= @"/:resource/:identifier";
/// The relative path for a :property of a :resource identified using :identifier.
NSString *const kCDOHIdentifiedResourcePropertyPathFormat	= @"/:resource/:identifier/:property";
/// The relative path for a :property identified using :identfier of a :resource.
NSString *const kCDOHResourcePropertyIdentifiedPathFormat	= @"/:resource/:property/:identifier";
/// The relative path for a repository (:owner, :repo) for a specific :property
/// of a :resource.
NSString *const kCDOHResourcePropertyRepositoryPathFormat	= @"/:resource/:property/:owner/:repo";

#pragma mark |- Repository Path Formats
NSString *const kCDOHRepositoryPathFormat					= @"/repos/:owner/:repo";
NSString *const kCDOHRepositoryComparePathFormat			= @"/repos/:owner/:repo/compare/:base...:head";

#pragma mark |- Git Data Path Formats
NSString *const kCDOHGitDataResourcePathFormat				= @"/repos/:owner/:repo/git/:resource";
NSString *const kCDOHGitDataResourcePropertyPathFormat		= @"/repos/:owner/:repo/git/:resource/:property";

#pragma mark |- Resources
NSString *const kCDOHResourceBlobs							= @"blobs";
NSString *const kCDOHResourceBranches						= @"branches";
NSString *const kCDOHResourceCollaborators					= @"collaborators";
NSString *const kCDOHResourceCommits						= @"commits";
NSString *const kCDOHResourceCompare						= @"compare";
NSString *const kCDOHResourceContributors					= @"contributors";
NSString *const kCDOHResourceDownloads						= @"downloads";
NSString *const kCDOHResourceForks							= @"forks";
NSString *const kCDOHResourceGists							= @"gists";
NSString *const kCDOHResourceHooks							= @"hooks";
NSString *const kCDOHResourceHub							= @"hub";
NSString *const kCDOHResourceIssues							= @"issues";
NSString *const kCDOHResourceKeys							= @"keys";
NSString *const kCDOHResourceLabels							= @"labels";
NSString *const kCDOHResourceLanguages						= @"languages";
NSString *const kCDOHResourceMilestones						= @"milestones";
NSString *const kCDOHResourceOrganizations					= @"orgs";
NSString *const kCDOHResourcePulls							= @"pulls";
NSString *const kCDOHResourceReceivedEvents					= @"received_events";
NSString *const kCDOHResourceReferences						= @"refs";
NSString *const kCDOHResourceRepositories					= @"repos";
NSString *const kCDOHResourceTags							= @"tags";
NSString *const kCDOHResourceTeams							= @"teams";
NSString *const kCDOHResourceTrees							= @"trees";
NSString *const kCDOHResourceAuthenticatedUser				= @"user";
NSString *const kCDOHResourceUsers							= @"users";
NSString *const kCDOHResourceWatchers						= @"watchers";

#pragma mark |- Resource Properties
NSString *const kCDOHResourcePropertyComments				= @"comments";
NSString *const kCDOHResourcePropertyEmails					= @"emails";
NSString *const kCDOHResourcePropertyEvents					= @"events";
NSString *const kCDOHResourcePropertyFiles					= @"files";
NSString *const kCDOHResourcePropertyFollowers				= @"followers";
NSString *const kCDOHResourcePropertyFollowing				= @"following";
NSString *const kCDOHResourcePropertyForks					= @"forks";
NSString *const kCDOHResourcePropertyMembers				= @"members";
NSString *const kCDOHResourcePropertyMerge					= @"merge";
NSString *const kCDOHResourcePropertyOrganizations			= @"orgs";
NSString *const kCDOHResourcePropertyPublic					= @"public";
NSString *const kCDOHResourcePropertyPublicMembers			= @"public_members";
NSString *const kCDOHResourcePropertyPush					= @"push";
NSString *const kCDOHResourcePropertyRepositories			= @"repos";
NSString *const kCDOHResourcePropertyStar					= @"star";
NSString *const kCDOHResourcePropertyStarred				= @"starred";
NSString *const kCDOHResourcePropertyTeams					= @"teams";
NSString *const kCDOHResourcePropertyWatched				= @"watched";


#pragma mark - Request Parameter Keys
/// The repositories type parameter key.
NSString *const kCDOHParameterRepositoriesTypeKey			= @"type";



// ---------------------------------------------------------------------------//
#pragma mark -
#pragma mark - ObjectiveHub Implementation
// ---------------------------------------------------------------------------//
@implementation CDOHClient

#pragma mark - Synthesizing
@synthesize username = _username;
@synthesize password = _password;
@synthesize itemsPerPage = _itemsPerPage;
@synthesize baseURL = _baseUrl;
@synthesize showNetworkActivityStatusAutomatically = _showNetworkActivityStatusAutomatically;

@synthesize managedObjectContext =_managedObjectContext;
@synthesize networkClient = _networkClient;


#pragma mark - Network Client Adapters
+ (NSMutableArray *)registeredNetworkClientAdapters
{
	static NSMutableArray *registeredNetworkClientAdapters = nil;
	static dispatch_once_t registeredNetworkClientAdaptersToken;
	dispatch_once(&registeredNetworkClientAdaptersToken, ^{
		registeredNetworkClientAdapters = [[NSMutableArray alloc] initWithObjects:
										   [CDOHAFNetworkingClient class],
										   nil];
	});
	
	return registeredNetworkClientAdapters;
}

+ (BOOL)registerNetworkClientAdapterClass:(Class)adapterClass
{
	if (class_conformsToProtocol(adapterClass, @protocol(CDOHNetworkClient))) {
		@synchronized(self) {
			[[self registeredNetworkClientAdapters] insertObject:adapterClass atIndex:0];
		}
		
		return YES;
	}
	return NO;
}

+ (void)unregisterNetworkClientAdapterClass:(Class)adapterClass
{
	@synchronized(self) {
		[[self registeredNetworkClientAdapters] removeObject:adapterClass];
	}
}

+ (Class)networkClientAdapaterClass
{
	Class adapterClass = nil;

	@synchronized(self) {
		for (Class registeredClass in [self registeredNetworkClientAdapters]) {
			if ([registeredClass checkDependencies]) {
				adapterClass = registeredClass;
				break;
			}
		}
	}
	
	return adapterClass;
}


#pragma mark - Initializing ObjectiveHub
- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
	self = [super init];
	if (self) {
		_itemsPerPage = kCDOHDefaultItemsPerPage;
		_managedObjectContext = managedObjectContext;
		
		_baseUrl = [NSURL URLWithString:kCDOHGitHubBaseAPIURIString];
		NSDictionary *defaultHeaders = [[self class] defaultNetworkClientHTTPHeaders];
		Class networkClientClass = [[self class] networkClientAdapaterClass];
		_networkClient = [[networkClientClass alloc] initWithBaseURL:_baseUrl defaultHeaders:defaultHeaders];
	}
	
	return self;
}

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext username:(NSString *)username password:(NSString *)password
{
	self = [self initWithManagedObjectContext:managedObjectContext];
	if (self) {
		_username = [username copy];
		_password = [password copy];
	}
	
	return self;
}


#pragma mark - Describing a User Object
- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@: %p { GitHub API URI = %@, username = %@, password is set = %@ }>", [self class], self, kCDOHGitHubBaseAPIURIString, self.username, (self.password ? @"YES" : @"NO")];
}


#pragma mark - Configuration Options
- (NSUInteger)itemsPerPage
{
	return _itemsPerPage;
}

- (void)setItemsPerPage:(NSUInteger)itemsPerPage
{
	// Make sure "itemsPerPage" is in the range 0-100.
	if (itemsPerPage > 100) {
		[NSException raise:NSInvalidArgumentException format:@"itemsPerPage must be in the range (including) 0 and 100"];
		return;
	}
	
	_itemsPerPage = itemsPerPage;
}

+ (NSDictionary *)defaultNetworkClientHTTPHeaders
{
	static NSDictionary *defaultNetworkClientHTTPHeaders = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSString *userAgent = [NSString stringWithFormat:kCDOHUserAgentFormat, kCDOHLibraryVersion];
		defaultNetworkClientHTTPHeaders = [NSDictionary dictionaryWithObjectsAndKeys:
										   kCDOHGitHubMimeGenericJSON,	@"Accept",
										   userAgent,					@"User-Agent",
										   nil];
	});
	
	return defaultNetworkClientHTTPHeaders;
}


#pragma mark - Network Activity
- (void)setShowNetworkActivityStatusAutomatically:(BOOL)flag
{
	_showNetworkActivityStatusAutomatically = flag;
#if TARGET_OS_IPHONE
	if (flag == NO) {
		[[UIApplication sharedApplication] cdoh_resetNetworkActivity];
	}
#endif // TARGET_OS_IPHONE
}


#pragma mark - Controlling Requests
- (void)suspendAllRequests
{
	[self.networkClient suspend];
}

- (void)resumeAllRequests
{
	[self.networkClient resume];
}

- (void)cancelAllRequests
{
	[self.networkClient cancelAll];

}


#pragma mark - Generic Standard Reply Blocks
- (CDOHNetworkClientReplyBlock)standardReplyBlockForNoDataResponse:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	return ^(CDOHNetworkClientReply *reply) {
		if (reply.success == YES && successBlock) {
			successBlock(nil);
		} else if (reply.success == NO && failureBlock) {
			failureBlock(reply.error);
		}
	};
}

- (CDOHNetworkClientReplyBlock)standardReplyBlockWithResourceCreationBlock:(CDOHInternalResponseCreationBlock)resourceCreationBlock success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock selector:(SEL)selector arguments:(NSArray *)arguments
{
	__weak CDOHClient *blockSelf = self;
	return ^(CDOHNetworkClientReply *reply) {
		if (reply.success == YES && successBlock) {
			id responseObject = reply.response;
			
			if ([responseObject length] > 0) {
				id parsedResponseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&jsonDecodingError];
				id resource = resourceCreationBlock(parsedResponseObject);
				
				if (resource != nil) {
					CDOHResponse *response = [[CDOHResponse alloc] initWithResource:resource
																			 client:blockSelf
																		   selector:selector
																	   successBlock:successBlock
																	   failureBlock:failureBlock
																		HTTPHeaders:reply.HTTPHeaders
																		  arguments:arguments];
					successBlock(response);
				} else if (failureBlock) {
					CDOHError *error = [[CDOHError alloc] initWithHTTPHeaders:reply.HTTPHeaders HTTPStatus:kCDOHErrorCodeCouldNotCreateResource responseBody:responseObject];
					failureBlock(error);
				}
			} else if (failureBlock) {
				CDOHError *error = [[CDOHError alloc] initWithHTTPHeaders:reply.HTTPHeaders HTTPStatus:kCDOHErrorCodeResponseObjectEmpty responseBody:responseObject];
				failureBlock(error);
			}
		} else if (reply.success == NO && failureBlock) {
			failureBlock(reply.error);
		}
	};
}


#pragma mark - Concrete Standard Reply Blocks
- (CDOHNetworkClientReplyBlock)standardUserReplyBlock:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock selector:(SEL)selector arguments:(NSArray *)arguments
{
	__weak CDOHClient *blockSelf = self;
	CDOHInternalResponseCreationBlock block = ^id (id parsedResponseObject) {
		CDOHUser *user = nil;
		if ([parsedResponseObject isKindOfClass:[NSDictionary class]]) {
			user = [CDOHUser resourceWithJSONDictionary:parsedResponseObject inManagedObjectContex:blockSelf.managedObjectContext];
		}
		
		return user;
	};
	
	return [self standardReplyBlockWithResourceCreationBlock:block success:successBlock failure:failureBlock selector:selector arguments:arguments];
}

- (CDOHNetworkClientReplyBlock)standardUserArrayReplyBlock:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock selector:(SEL)selector arguments:(NSArray *)arguments
{
	__weak CDOHClient *blockSelf = self;
	CDOHInternalResponseCreationBlock block = ^id (id parsedResponseObject) {
		NSMutableArray *users = nil;
		if ([parsedResponseObject isKindOfClass:[NSArray class]]) {
			users = [[NSMutableArray alloc] initWithCapacity:[parsedResponseObject count]];
			
			for (id userDict in parsedResponseObject) {
				if ([userDict isKindOfClass:[NSDictionary class]]) {
					CDOHUser *user = [CDOHUser resourceWithJSONDictionary:userDict inManagedObjectContex:blockSelf.managedObjectContext];
					[users addObject:user];
				}
			}
		}
		
		return users;
	};
	
	return [self standardReplyBlockWithResourceCreationBlock:block success:successBlock failure:failureBlock selector:selector arguments:arguments];
}

- (CDOHNetworkClientReplyBlock)standardArrayReplyBlock:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock selector:(SEL)selector arguments:(NSArray *)arguments
{
	CDOHInternalResponseCreationBlock block = ^id (id parsedResponseObject) {
		if ([parsedResponseObject isKindOfClass:[NSArray class]]) {
			return [parsedResponseObject copy];
		}
		
		return nil;
	};
	
	return [self standardReplyBlockWithResourceCreationBlock:block success:successBlock failure:failureBlock selector:selector arguments:arguments];
}

- (CDOHNetworkClientReplyBlock)standardRepositoryReplyBlock:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock selector:(SEL)selector arguments:(NSArray *)arguments
{
	__weak CDOHClient *blockSelf = self;
	CDOHInternalResponseCreationBlock block = ^id (id parsedResponseObject) {
		CDOHRepository *repo = nil;
		if ([parsedResponseObject isKindOfClass:[NSDictionary class]]) {
			repo = [CDOHRepository resourceWithJSONDictionary:parsedResponseObject inManagedObjectContex:blockSelf.managedObjectContext];
		}
		
		return repo;
	};
	
	return [self standardReplyBlockWithResourceCreationBlock:block success:successBlock failure:failureBlock selector:selector arguments:arguments];
}

- (CDOHNetworkClientReplyBlock)standardRepositoryArrayReplyBlock:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock selector:(SEL)selector arguments:(NSArray *)arguments
{
	__weak CDOHClient *blockSelf = self;
	CDOHInternalResponseCreationBlock block = ^id (id parsedResponseObject) {
		NSMutableArray *reposArray = nil;
		if ([parsedResponseObject isKindOfClass:[NSArray class]]) {
			reposArray = [[NSMutableArray alloc] initWithCapacity:[parsedResponseObject count]];
			
			for (id repoDict in parsedResponseObject) {
				if ([repoDict isKindOfClass:[NSDictionary class]]) {
					CDOHRepository *repo = [CDOHRepository resourceWithJSONDictionary:repoDict inManagedObjectContex:blockSelf.managedObjectContext];
					[reposArray addObject:repo];
				}
			}
		}
		
		return reposArray;
	};
	
	return [self standardReplyBlockWithResourceCreationBlock:block success:successBlock failure:failureBlock selector:selector arguments:arguments];
}


#pragma mark - Standard Requests
- (void)repositoriesAtPath:(NSString *)path params:(NSDictionary *)params pages:(NSIndexSet *)pages success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	NSParameterAssert(path);
	if ([pages count] == 0) {
		pages = [NSIndexSet indexSetWithIndex:1];
	}
	
	__weak CDOHClient *blockSelf = self;
	[pages enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL __unused *stop) {
		NSMutableDictionary *paramDict = [self standardRequestParameterDictionaryForPage:idx];
		[paramDict addEntriesFromDictionary:params];
		
		[blockSelf.networkClient getPath:path
							  parameters:paramDict
								username:blockSelf.username
								password:blockSelf.password
						  withReplyBlock:[blockSelf standardRepositoryArrayReplyBlock:successBlock failure:failureBlock selector:_cmd arguments:CDOHArrayOfArguments(path, params)]];
	}];
}

- (void)usersAtPath:(NSString *)path params:(NSDictionary *)params pages:(NSIndexSet *)pages success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	NSParameterAssert(path);
	if ([pages count] == 0) {
		pages = [NSIndexSet indexSetWithIndex:1];
	}
	
	__weak CDOHClient *blockSelf = self;
	[pages enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL __unused *stop) {
		NSMutableDictionary *paramDict = [self standardRequestParameterDictionaryForPage:idx];
		[paramDict addEntriesFromDictionary:params];
		
		[blockSelf.networkClient getPath:path
							  parameters:paramDict
								username:blockSelf.username
								password:blockSelf.password
						  withReplyBlock:[blockSelf standardUserArrayReplyBlock:successBlock failure:failureBlock selector:_cmd arguments:CDOHArrayOfArguments(path, params)]];
	}];
}


#pragma mark - Request Helpers
- (NSMutableDictionary *)standardRequestParameterDictionaryForPage:(NSUInteger)page
{
	// Make room for page and perPage and some extra for custom stuff
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:4];
	
	if (page != 0) {
		NSNumber *pageIdx = [[NSNumber alloc] initWithUnsignedInteger:page];
		[dict setObject:pageIdx forKey:@"page"];
	}
	
	NSUInteger perPage = self.itemsPerPage;
	if (perPage != 0) {
		NSNumber *perPageIdx = [[NSNumber alloc] initWithUnsignedInteger:perPage];
		[dict setObject:perPageIdx forKey:@"per_page"];
	}
	
	return dict;
}

- (NSMutableDictionary *)requestParameterDictionaryForDictionary:(NSDictionary *)dictionary validKeys:(NSArray *)validKeys
{
	NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:[validKeys count]];
	
	for (id key in validKeys) {
		id obj = [dictionary objectForKey:key];
		
		// Whitelisted classes
		if ([obj isKindOfClass:[NSString class]] ||
			[obj isKindOfClass:[NSNumber class]] ||
			[obj isKindOfClass:[NSArray class]] ||
			[obj isKindOfClass:[NSDictionary class]] ||
			[obj isKindOfClass:[NSNull class]] ||
			[obj isKindOfClass:[NSString class]]) {
			
			[params setObject:obj forKey:key];
		}
		// Transformable classes
		else if ([obj isKindOfClass:[NSURL class]]) {
			NSString *objStr = [(NSURL *)obj absoluteString];
			[params setObject:objStr forKey:key];
		}
		// Unkown classes
		else {
#if DEBUG
			NSLog(@"+++ Invalid type of class '%@' for key '%@' skipping.", [obj class], [key class]);
#endif
		}
	}
	
	return params;
}

- (BOOL)verifyAuthenticatedUserIsSetOrFail:(CDOHFailureBlock)failureBlock
{
	BOOL hasAuthenticatedUser = (self.username != nil && self.password != nil);

	if (!hasAuthenticatedUser && failureBlock != NULL) {
		CDOHError *error = [[CDOHError alloc] initWithDomain:kCDOHErrorDomain code:kCDOHErrorCodeNoAuthenticatedUser userInfo:nil];
		failureBlock(error);
	} else if (!hasAuthenticatedUser) {
		[NSException raise:NSInternalInconsistencyException format:@"No authenticated user set."];
	}
	
	return hasAuthenticatedUser;
}


#pragma mark - Users
- (void)userWithLogin:(NSString *)login success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	NSParameterAssert(login);
	if (!successBlock && !failureBlock) { return; }

	NSDictionary *options = CDOHMakeDict(kCDOHResourceUsers,	kCDOHResourceKey,
										 login,					kCDOHIdentifierKey);
	NSString *path = CDOHRelativeAPIPath(kCDOHIdentifiedResourcePathFormat, options);
	[self.networkClient getPath:path
					 parameters:nil
					   username:self.username
					   password:self.password
				 withReplyBlock:[self standardUserReplyBlock:successBlock failure:failureBlock selector:_cmd arguments:CDOHArrayOfArguments(login)]];
}

- (void)user:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (!successBlock && !failureBlock) { return; }
	if (![self verifyAuthenticatedUserIsSetOrFail:failureBlock]) { return; }
	
	NSDictionary *options = CDOHMakeDict(kCDOHResourceAuthenticatedUser, kCDOHResourceKey);
	NSString *path = CDOHRelativeAPIPath(kCDOHResourcePathFormat, options);
	[self.networkClient getPath:path
					 parameters:nil
					   username:self.username
					   password:self.password
				 withReplyBlock:[self standardUserReplyBlock:successBlock failure:failureBlock selector:_cmd arguments:nil]];
}

- (void)updateUserWithDictionary:(NSDictionary *)dictionary success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (![self verifyAuthenticatedUserIsSetOrFail:failureBlock]) { return; }
	if (!dictionary || [dictionary count] == 0) { return; }
	
	NSMutableDictionary *params = nil;
	NSArray *keys = [[NSArray alloc] initWithObjects:
					 kCDOHUserNameKey,
					 kCDOHUserEmailKey,
					 kCDOHUserBlogKey,
					 kCDOHUserCompanyKey,
					 kCDOHUserLocationKey,
					 kCDOHUserHireableKey,
					 kCDOHUserBioKey,
					 nil];
	params = [self requestParameterDictionaryForDictionary:dictionary validKeys:keys];
	
	NSDictionary *options = CDOHMakeDict(kCDOHResourceAuthenticatedUser, kCDOHResourceKey);
	NSString *path = CDOHRelativeAPIPath(kCDOHResourcePathFormat, options);
	[self.networkClient patchPath:path
					   parameters:params
						 username:self.username
						 password:self.password
				   withReplyBlock:[self standardUserReplyBlock:successBlock failure:failureBlock selector:_cmd arguments:CDOHArrayOfArguments(dictionary)]];
}


#pragma mark - User Emails
- (void)userEmails:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (!successBlock && !failureBlock) { return; }
	if (![self verifyAuthenticatedUserIsSetOrFail:failureBlock]) { return; }
	
	NSDictionary *options = CDOHMakeDict(kCDOHResourceAuthenticatedUser,	kCDOHResourceKey,
										 kCDOHResourcePropertyEmails,		kCDOHPropertyKey);
	NSString *path = CDOHRelativeAPIPath(kCDOHResourcePropertyPathFormat, options);
	
	[self.networkClient getPath:path
					 parameters:nil
					   username:self.username
					   password:self.password
				 withReplyBlock:[self standardArrayReplyBlock:successBlock failure:failureBlock selector:_cmd arguments:nil]];
}

- (void)addUserEmails:(NSArray *)emails success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	NSParameterAssert(emails);
	if (![self verifyAuthenticatedUserIsSetOrFail:failureBlock]) { return; }
	
	NSDictionary *options = CDOHMakeDict(kCDOHResourceAuthenticatedUser,	kCDOHResourceKey,
										 kCDOHResourcePropertyEmails,		kCDOHPropertyKey);
	NSString *path = CDOHRelativeAPIPath(kCDOHResourcePropertyPathFormat, options);
	
	[self.networkClient postPath:path
					  parameters:emails
						username:self.username
						password:self.password
				  withReplyBlock:[self standardArrayReplyBlock:successBlock failure:failureBlock selector:_cmd arguments:CDOHArrayOfArguments(emails)]];
}

- (void)deleteUserEmails:(NSArray *)emails success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	NSParameterAssert(emails);
	if (![self verifyAuthenticatedUserIsSetOrFail:failureBlock]) { return; }
	
	NSDictionary *options = CDOHMakeDict(kCDOHResourceAuthenticatedUser,	kCDOHResourceKey,
										 kCDOHResourcePropertyEmails,		kCDOHPropertyKey);
	NSString *path = CDOHRelativeAPIPath(kCDOHResourcePropertyPathFormat, options);
	
	[self.networkClient deletePath:path
						parameters:emails
						  username:self.username
						  password:self.password
					withReplyBlock:[self standardReplyBlockForNoDataResponse:successBlock failure:failureBlock]];
}


#pragma mark - Repositories
- (void)repository:(NSString *)repo owner:(NSString *)owner success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	NSParameterAssert(repo);
	NSParameterAssert(owner);
	if (!successBlock && !failureBlock) { return; }
	
	NSString *path = CDOHRelativeAPIPath(kCDOHRepositoryPathFormat, CDOHDictionaryOfVariableBindings(repo, owner));
	
	[self.networkClient getPath:path
					 parameters:nil
					   username:self.username
					   password:self.password
				 withReplyBlock:[self standardRepositoryReplyBlock:successBlock failure:failureBlock selector:_cmd arguments:CDOHArrayOfArguments(repo, owner)]];
}

- (void)createRepository:(NSString *)name dictionary:(NSDictionary *)dictionary success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	NSParameterAssert(name);
	if (![self verifyAuthenticatedUserIsSetOrFail:failureBlock]) { return; }
	
	NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:[dictionary count] + 1];
	if ([dictionary count] > 0) {
		NSArray *keys = [[NSArray alloc] initWithObjects:
						 kCDOHRepositoryDescriptionKey,
						 kCDOHRepositoryHomepageKey,
						 kCDOHRepositoryPrivateKey,
						 kCDOHRepositoryHasIssuesKey,
						 kCDOHRepositoryHasWikiKey,
						 kCDOHRepositoryHasDownloadsKey,
						 nil];
		NSDictionary *optionalDictionary = [self requestParameterDictionaryForDictionary:dictionary validKeys:keys];
		[params addEntriesFromDictionary:optionalDictionary];
	}
	[params setObject:name forKey:kCDOHRepositoryNameKey];
	
	NSDictionary *options = CDOHMakeDict(kCDOHResourceAuthenticatedUser,	kCDOHResourceKey,
										 kCDOHResourcePropertyRepositories,	kCDOHPropertyKey);
	NSString *path = CDOHRelativeAPIPath(kCDOHResourcePropertyPathFormat, options);
	
	[self.networkClient postPath:path
					  parameters:params
						username:self.username
						password:self.password
				  withReplyBlock:[self standardRepositoryReplyBlock:successBlock failure:failureBlock selector:_cmd arguments:CDOHArrayOfArguments(name, dictionary)]];
}

- (void)createRepository:(NSString *)name inOrganization:(NSString *)organization dictionary:(NSDictionary *)dictionary success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	NSParameterAssert(name);
	NSParameterAssert(organization);
	if (![self verifyAuthenticatedUserIsSetOrFail:failureBlock]) { return; }
	
	NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:[dictionary count] + 1];
	if ([dictionary count] > 0) {
		NSArray *keys = [[NSArray alloc] initWithObjects:
						 kCDOHRepositoryDescriptionKey,
						 kCDOHRepositoryHomepageKey,
						 kCDOHRepositoryPrivateKey,
						 kCDOHRepositoryHasIssuesKey,
						 kCDOHRepositoryHasWikiKey,
						 kCDOHRepositoryHasDownloadsKey,
						 kCDOHRepositoryTeamIDKey,
						 nil];
		NSDictionary *optionalDictionary = [self requestParameterDictionaryForDictionary:dictionary validKeys:keys];
		[params addEntriesFromDictionary:optionalDictionary];
	}
	[params setObject:name forKey:kCDOHRepositoryNameKey];
	
	NSDictionary *options = CDOHMakeDict(kCDOHResourceOrganizations,		kCDOHResourceKey,
										 kCDOHResourcePropertyRepositories,	kCDOHPropertyKey,
										 organization,						kCDOHIdentifierKey);
	NSString *path = CDOHRelativeAPIPath(kCDOHIdentifiedResourcePropertyPathFormat, options);
	
	[self.networkClient postPath:path
					  parameters:params
						username:self.username
						password:self.password
				  withReplyBlock:[self standardRepositoryReplyBlock:successBlock failure:failureBlock selector:_cmd arguments:CDOHArrayOfArguments(name, organization)]];
}

- (void)updateRepository:(NSString *)repo owner:(NSString *)owner dictionary:(NSDictionary *)dictionary success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	NSParameterAssert(repo);
	NSParameterAssert(owner);
	if (![self verifyAuthenticatedUserIsSetOrFail:failureBlock]) { return; }
	if (!dictionary || [dictionary count] == 0) { return; }
	
	NSMutableDictionary *params = nil;
	NSArray *keys = [[NSArray alloc] initWithObjects:
					 kCDOHRepositoryNameKey,
					 kCDOHRepositoryDescriptionKey,
					 kCDOHRepositoryHomepageKey,
					 kCDOHRepositoryPrivateKey,
					 kCDOHRepositoryHasIssuesKey,
					 kCDOHRepositoryHasWikiKey,
					 kCDOHRepositoryHasDownloadsKey,
					 nil];
	params = [self requestParameterDictionaryForDictionary:dictionary validKeys:keys];
	
	if (![params objectForKey:kCDOHRepositoryNameKey]) {
		[params setObject:repo forKey:kCDOHRepositoryNameKey];
	}
	
	NSString *path = CDOHRelativeAPIPath(kCDOHRepositoryPathFormat, CDOHDictionaryOfVariableBindings(repo, owner));
	
	[self.networkClient postPath:path
					  parameters:params
						username:self.username
						password:self.password
				  withReplyBlock:[self standardRepositoryReplyBlock:successBlock failure:failureBlock selector:_cmd arguments:CDOHArrayOfArguments(repo, owner, dictionary)]];
}

- (void)repositories:(NSString *)type pages:(NSIndexSet *)pages success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	NSParameterAssert(type);
	if (!successBlock && !failureBlock) { return; }
	if (![self verifyAuthenticatedUserIsSetOrFail:failureBlock]) { return; }
	
	NSDictionary *params = CDOHParametersDictionary(type, kCDOHParameterRepositoriesTypeKey);
	
	NSDictionary *options = CDOHMakeDict(kCDOHResourceAuthenticatedUser,	kCDOHResourceKey,
										 kCDOHResourcePropertyRepositories,	kCDOHPropertyKey);
	NSString *path = CDOHRelativeAPIPath(kCDOHResourcePropertyPathFormat, options);
	
	[self repositoriesAtPath:path params:params pages:pages success:successBlock failure:failureBlock];
}

- (void)repositoriesForUser:(NSString *)login type:(NSString *)type pages:(NSIndexSet *)pages success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	NSParameterAssert(login);
	NSParameterAssert(type);
	if (!successBlock && !failureBlock) { return; }

	NSDictionary *params = CDOHParametersDictionary(type, kCDOHParameterRepositoriesTypeKey);
	
	NSDictionary *options = CDOHMakeDict(kCDOHResourceUsers,				kCDOHResourceKey,
										 kCDOHResourcePropertyRepositories,	kCDOHPropertyKey,
										 login,								kCDOHIdentifierKey);
	NSString *path = CDOHRelativeAPIPath(kCDOHIdentifiedResourcePropertyPathFormat, options);
	
	[self repositoriesAtPath:path params:params pages:pages success:successBlock failure:failureBlock];
}

- (void)repositoriesForOrganization:(NSString *)organization type:(NSString *)type pages:(NSIndexSet *)pages success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	NSParameterAssert(organization);
	NSParameterAssert(type);
	if (!successBlock && !failureBlock) { return; }

	NSDictionary *params = CDOHParametersDictionary(type, kCDOHParameterRepositoriesTypeKey);
	
	NSDictionary *options = CDOHMakeDict(kCDOHResourceOrganizations,		kCDOHResourceKey,
										 kCDOHResourcePropertyRepositories,	kCDOHPropertyKey,
										 organization,						kCDOHIdentifierKey);
	NSString *path = CDOHRelativeAPIPath(kCDOHIdentifiedResourcePropertyPathFormat, options);

	[self repositoriesAtPath:path params:params pages:pages success:successBlock failure:failureBlock];
}

- (void)repositoryContributors:(NSString *)repository owner:(NSString *)owner success:(CDOHSuccessBlock) successBlock failure:(CDOHFailureBlock) failureBlock
{
	[self repositoryContributors:repository owner:owner anonymous:NO success:successBlock failure:failureBlock];
}

// TODO: This should create an array of dictionaries instead of user-objects (#42)
- (void)repositoryContributors:(NSString *)repo owner:(NSString *)owner anonymous:(BOOL)anonymous success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	NSParameterAssert(repo);
	NSParameterAssert(owner);
	if (!successBlock && !failureBlock) { return; }

	NSDictionary *params = CDOHParametersDictionary([NSNumber numberWithBool:anonymous], @"anon");
	
	
	NSArray *pathFormats = CDOHMakeArray(kCDOHRepositoryPathFormat,
										 kCDOHResourcePathFormat);
	NSArray *optionDicts = CDOHMakeArray(CDOHMakeDict(repo,		kCDOHRepositoryKey,
													  owner,	kCDOHOwnerKey),
										 CDOHMakeDict(kCDOHResourceContributors, kCDOHResourceKey));
	NSString *path = CDOHConcatenatedRelativeAPIPaths(pathFormats, optionDicts);
	
	[self usersAtPath:path params:params pages:nil success:successBlock failure:failureBlock];
}

- (void)repositoryLanguages:(NSString *)repo owner:(NSString *)owner success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	NSParameterAssert(repo);
	NSParameterAssert(owner);
	if (!successBlock && !failureBlock) { return; }
	
	CDOHInternalResponseCreationBlock resourceCreationBlock = ^id (id parsedResponseObject) {
		NSDictionary *languagesDict = parsedResponseObject;
		
		NSMutableArray *languagesArray = nil;
		if ([languagesDict isKindOfClass:[NSDictionary class]]) {
			languagesArray = [[NSMutableArray alloc] initWithCapacity:[languagesDict count]];
			[languagesDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *__unused stop) {
				NSDictionary *lang = [[NSDictionary alloc] initWithObjectsAndKeys:
									  key, kCDOHRepositoryLanguageNameKey,
									  obj, kCDOHRepositoryLanguageCharactersKey,
									  nil];
				
				[languagesArray addObject:lang];
			}];
		}
		
		return languagesArray;
	};
	
	NSArray *pathFormats = CDOHMakeArray(kCDOHRepositoryPathFormat,
										 kCDOHResourcePathFormat);
	NSArray *optionDicts = CDOHMakeArray(CDOHMakeDict(repo,		kCDOHRepositoryKey,
													  owner,	kCDOHOwnerKey),
										 CDOHMakeDict(kCDOHResourceLanguages, kCDOHResourceKey));
	NSString *path = CDOHConcatenatedRelativeAPIPaths(pathFormats, optionDicts);
	
	[self.networkClient getPath:path
					 parameters:nil
					   username:self.username
					   password:self.password
				 withReplyBlock:[self standardReplyBlockWithResourceCreationBlock:resourceCreationBlock success:successBlock failure:failureBlock selector:_cmd arguments:CDOHArrayOfArguments(repo, owner)]];
}


#pragma mark - Watched and Watching Repositories
- (void)repositoryWatchers:(NSString *)repo owner:(NSString *)owner pages:(NSIndexSet *)pages success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	NSParameterAssert(repo);
	NSParameterAssert(owner);
	if (!successBlock && !failureBlock) { return; }
	
	NSArray *pathFormats = CDOHMakeArray(kCDOHRepositoryPathFormat,
										 kCDOHResourcePathFormat);
	NSArray *optionDicts = CDOHMakeArray(CDOHMakeDict(repo,		kCDOHRepositoryKey,
													  owner,	kCDOHOwnerKey),
										 CDOHMakeDict(kCDOHResourceWatchers, kCDOHResourceKey));
	NSString *path = CDOHConcatenatedRelativeAPIPaths(pathFormats, optionDicts);
	
	[self usersAtPath:path params:nil pages:pages success:successBlock failure:failureBlock];
}

- (void)repositoriesWatchedByUser:(NSString *)login pages:(NSIndexSet *)pages success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	NSParameterAssert(login);
	if (!successBlock && !failureBlock) { return; }
	
	NSDictionary *options = CDOHMakeDict(kCDOHResourceUsers,			kCDOHResourceKey,
										 kCDOHResourcePropertyWatched,	kCDOHPropertyKey,
										 login,							kCDOHIdentifierKey);
	NSString *path = CDOHRelativeAPIPath(kCDOHIdentifiedResourcePropertyPathFormat, options);
	
	[self repositoriesAtPath:path params:nil pages:pages success:successBlock failure:failureBlock];
}

- (void)repositoriesWatchedForPages:(NSIndexSet *)pages success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (!successBlock && !failureBlock) { return; }
	if (![self verifyAuthenticatedUserIsSetOrFail:failureBlock]) { return; }
	
	NSDictionary *options = CDOHMakeDict(kCDOHResourceAuthenticatedUser,	kCDOHResourceKey,
										 kCDOHResourcePropertyWatched,		kCDOHPropertyKey);
	NSString *path = CDOHRelativeAPIPath(kCDOHResourcePropertyPathFormat, options);
	
	[self repositoriesAtPath:path params:nil pages:pages success:successBlock failure:failureBlock];
}


- (void)isUserWatchingRepository:(NSString *)repo owner:(NSString *)owner success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	NSParameterAssert(repo);
	NSParameterAssert(owner);
	if (!successBlock && !failureBlock) { return; }
	if (![self verifyAuthenticatedUserIsSetOrFail:failureBlock]) { return; }
	
	NSDictionary *options = CDOHMakeDict(kCDOHResourceUsers,			kCDOHResourceKey,
										 kCDOHResourcePropertyWatched,	kCDOHPropertyKey,
										 repo,							kCDOHRepositoryKey,
										 owner,							kCDOHOwnerKey);
	NSString *path = CDOHRelativeAPIPath(kCDOHResourcePropertyRepositoryPathFormat, options);
	
	[self.networkClient getPath:path
					 parameters:nil
					   username:self.username
					   password:self.password
				 withReplyBlock:[self standardReplyBlockForNoDataResponse:successBlock failure:failureBlock]];
}

- (void)watchRepository:(NSString *)repo owner:(NSString *)owner success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	NSParameterAssert(repo);
	NSParameterAssert(owner);
	if (![self verifyAuthenticatedUserIsSetOrFail:failureBlock]) { return; }
	
	NSDictionary *options = CDOHMakeDict(kCDOHResourceUsers,			kCDOHResourceKey,
										 kCDOHResourcePropertyWatched,	kCDOHPropertyKey,
										 repo,							kCDOHRepositoryKey,
										 owner,							kCDOHOwnerKey);
	NSString *path = CDOHRelativeAPIPath(kCDOHResourcePropertyRepositoryPathFormat, options);
	
	[self.networkClient putPath:path
					 parameters:nil
					   username:self.username
					   password:self.password
				 withReplyBlock:[self standardReplyBlockForNoDataResponse:successBlock failure:failureBlock]];
}

- (void)stopWatchingRepository:(NSString *)repo owner:(NSString *)owner success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	NSParameterAssert(repo);
	NSParameterAssert(owner);
	if (![self verifyAuthenticatedUserIsSetOrFail:failureBlock]) { return; }
	
	NSDictionary *options = CDOHMakeDict(kCDOHResourceUsers,			kCDOHResourceKey,
										 kCDOHResourcePropertyWatched,	kCDOHPropertyKey,
										 repo,							kCDOHRepositoryKey,
										 owner,							kCDOHOwnerKey);
	NSString *path = CDOHRelativeAPIPath(kCDOHResourcePropertyRepositoryPathFormat, options);
	
	[self.networkClient deletePath:path
						parameters:nil
						  username:self.username
						  password:self.password
					withReplyBlock:[self standardReplyBlockForNoDataResponse:successBlock failure:failureBlock]];
}


#pragma mark - Repository Forks
- (void)repositoryForks:(NSString *)repo owner:(NSString *)owner pages:(NSIndexSet *)pages success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	NSParameterAssert(repo);
	NSParameterAssert(owner);
	if (!successBlock && !failureBlock) { return; }
	
	NSArray *pathFormats = CDOHMakeArray(kCDOHRepositoryPathFormat,
										 kCDOHResourcePathFormat);
	NSArray *optionDicts = CDOHMakeArray(CDOHMakeDict(repo,		kCDOHRepositoryKey,
													  owner,	kCDOHOwnerKey),
										 CDOHMakeDict(kCDOHResourceForks, kCDOHResourceKey));
	NSString *path = CDOHConcatenatedRelativeAPIPaths(pathFormats, optionDicts);
	
	[self repositoriesAtPath:path params:nil pages:pages success:successBlock failure:failureBlock];
}

- (void)forkRepository:(NSString *)repo owner:(NSString *)owner intoOrganization:(NSString *)intoOrganization success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	NSParameterAssert(repo);
	NSParameterAssert(owner);
	if (![self verifyAuthenticatedUserIsSetOrFail:failureBlock]) { return; }
	
	NSDictionary *params = nil;
	if ([intoOrganization length] > 0) {
		params = [[NSDictionary alloc] initWithObjectsAndKeys:
				  intoOrganization, @"org",
				  nil];
	}
	
	NSArray *pathFormats = CDOHMakeArray(kCDOHRepositoryPathFormat,
										 kCDOHResourcePathFormat);
	NSArray *optionDicts = CDOHMakeArray(CDOHMakeDict(repo,		kCDOHRepositoryKey,
													  owner,	kCDOHOwnerKey),
										 CDOHMakeDict(kCDOHResourceForks, kCDOHResourceKey));
	NSString *path = CDOHConcatenatedRelativeAPIPaths(pathFormats, optionDicts);
	
	[self.networkClient postPath:path
					  parameters:params
						username:self.username
						password:self.password
				  withReplyBlock:[self standardRepositoryReplyBlock:successBlock failure:failureBlock selector:_cmd arguments:CDOHArrayOfArguments(repo, owner, intoOrganization)]];
}


@end



// ---------------------------------------------------------------------------//
#pragma mark - Helper Functions
#pragma mark - Relative API Path
NSDictionary *_CDOHDictionaryOfVariableBindings(NSString *commaSeparatedKeysString, id firstValue, ...)
{
	NSDictionary *dictionary = nil;
	NSMutableArray *keys = nil;
	NSMutableArray *objects = nil;
	
	NSArray *tmpKeys = [commaSeparatedKeysString componentsSeparatedByString:@","];
	keys = [[NSMutableArray alloc] initWithCapacity:[tmpKeys count]];
	for (NSString *tmpKey in tmpKeys) {
		NSString *key = [tmpKey stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		[keys addObject:key];
	}
	
	objects = [[NSMutableArray alloc] initWithCapacity:[keys count]];
	id obj = firstValue;
	
	va_list args;
	va_start(args, firstValue);
	while (obj != nil) {
		[objects addObject:obj];
		obj = va_arg(args, id);
	}
	va_end(args);
	
	dictionary = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
	return dictionary;
}

NSString *CDOHRelativeAPIPath(NSString *pathFormat, NSDictionary *options)
{
	// No need to do anything if options is empty or even nil, the end result
	// would have been to return the pathFormat anyway.
	if ([options count] == 0) { return pathFormat; }
	
	NSMutableString *path = [[NSMutableString alloc] init];
	NSArray *pathComponents = [pathFormat pathComponents];
	
	for (NSString *component in pathComponents) {
		NSString *pathComponent = nil;
		if ([component isEqualToString:@"/"]) {
			continue;
		} else if ([[component substringToIndex:1] isEqualToString:@":"]) {
			NSString *key = [component substringFromIndex:1];
			pathComponent = [options objectForKey:key];
		}
		
		if (pathComponent == nil) {
			pathComponent = component;
#if DEBUG
			NSLog(@"=== %s: No option for '%@'", __PRETTY_FUNCTION__, component);
#endif
		}
		
		[path appendFormat:@"/%@", pathComponent];
	}
	
	return path;
}

NSString *CDOHConcatenatedRelativeAPIPaths(NSArray *pathFormats, NSArray *optionDicts)
{
	NSMutableString *path = [[NSMutableString alloc] init];
	
	[pathFormats enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL __unused *stop) {
		NSString *pathFormat = obj;
		
		NSDictionary *options = nil;
		if (idx < [optionDicts count]) {
			options = [optionDicts objectAtIndex:idx];
		}
		
		NSString *relativeApiPath = CDOHRelativeAPIPath(pathFormat, options);
		[path appendString:relativeApiPath];
	}];
	
	return path;
}

