//
//  CDOHRepositoryTests.m
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

#import "CDOHRepositoryTests.h"
#import "CDOHRepository.h"

#define CDOHTestNumFromBool(x)	[NSNumber numberWithBool:(x)]


@implementation CDOHRepositoryTests

#pragma mark - Tested Class
+ (Class)testedClass
{
	return [CDOHRepository class];
}


#pragma mark - Test Dictionaries
+ (NSDictionary *)firstTestDictionary
{
	static NSDictionary *dictionary = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSDictionary *superDict = [super firstTestDictionary];
		// Generated from the JSON response for
		// https://api.github.com/repos/rastersize/developer.github.com on the
		// 14 Feb 2012
		NSDictionary *localDict = [NSDictionary dictionaryWithObjectsAndKeys:
								   @"developer.github.com",											@"name",
								   @"GitHub API documentation",										@"description",
								   @"Ruby",															@"language",
								   @"master",														@"master_branch",
								   
								   @"2012-02-13T21:49:12Z",											@"pushed_at",
								   @"2012-02-13T21:45:50Z",											@"created_at",
								   @"2012-02-13T21:49:12Z",											@"updated_at",
								   
								   @"https://api.github.com/repos/rastersize/developer.github.com",	@"url",
								   @"git://github.com/rastersize/developer.github.com.git",			@"git_url",
								   @"git@github.com:rastersize/developer.github.com.git",			@"ssh_url",
								   @"https://github.com/rastersize/developer.github.com.git",		@"clone_url",
								   @"https://github.com/rastersize/developer.github.com",			@"svn_url",
								   @"git://git.example.com/original/developer.github.com.git",		@"mirror_url",
								   @"https://github.com/rastersize/developer.github.com",			@"html_url",
								   @"http://developer.github.com",									@"homepage",
								   
								   [NSNumber numberWithInteger:0],									@"forks",
								   [NSNumber numberWithInteger:1],									@"watchers",
								   [NSNumber numberWithInteger:0],									@"open_issues",
								   [NSNumber numberWithInteger:132],								@"size",
								   [NSNumber numberWithInteger:3434443],							@"id",
								   
								   
								   [NSNumber numberWithBool:YES],									@"fork",
								   [NSNumber numberWithBool:YES],									@"has_wiki",
								   [NSNumber numberWithBool:YES],									@"has_downloads",
								   [NSNumber numberWithBool:NO],									@"has_issues",
								   [NSNumber numberWithBool:NO],									@"private",
								   
								   // Owner:
								   [NSDictionary dictionaryWithObjectsAndKeys:
									@"rastersize", @"login",
									[NSNumber numberWithInteger:23453], @"id",
									@"https://secure.gravatar.com/avatar/2f21aac393665a85428eab10c2bdbe79?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-140.png", @"avatar_url",
									@"https://api.github.com/users/rastersize", @"url",
									@"2f21aac393665a85428eab10c2bdbe79", @"gravatar_id",
									nil],															@"owner",
								   
								   // Organization:
								   [NSDictionary dictionaryWithObjectsAndKeys:
									@"github", @"login",
									[NSNumber numberWithInteger:9919], @"id",
									@"https://secure.gravatar.com/avatar/61024896f291303615bcd4f7a0dcfb74?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-orgs.png", @"avatar_url",
									@"https://api.github.com/orgs/github", @"url",
									@"61024896f291303615bcd4f7a0dcfb74", @"gravatar_id",
									nil], @"organization",
								   
								   // Source:
								   [NSDictionary dictionaryWithObjectsAndKeys:
									@"GitHub API documentation", @"description",
									@"2012-02-10T22:36:35Z", @"pushed_at",
									@"Ruby", @"language",
									[NSNumber numberWithBool:NO], @"fork",
									@"https://api.github.com/repos/github/developer.github.com", @"url",
									@"master", @"master_branch",
									[NSNumber numberWithInteger:26], @"open_issues",
									[NSNumber numberWithBool:YES], @"has_downloads",
									@"2012-02-13T21:45:50Z", @"updated_at",
									// Source owner:
									[NSDictionary dictionaryWithObjectsAndKeys:
									 @"github", @"login",
									 [NSNumber numberWithInteger:9919], @"id",
									 @"https://secure.gravatar.com/avatar/61024896f291303615bcd4f7a0dcfb74?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-orgs.png", @"avatar_url",
									 @"https://api.github.com/users/github", @"url",
									 @"61024896f291303615bcd4f7a0dcfb74", @"gravatar_id",
									 nil], @"owner",
									@"git://git.example.com/original/developer.github.com.git", @"mirror_url",
									[NSNumber numberWithBool:NO], @"private",
									@"git://github.com/github/developer.github.com.git", @"git_url",
									[NSNumber numberWithInteger:65], @"forks",
									@"developer.github.com", @"name",
									@"http://developer.github.com", @"homepage",
									@"https://github.com/github/developer.github.com", @"svn_url",
									[NSNumber numberWithInteger:160], @"size",
									[NSNumber numberWithInteger:162], @"watchers",
									[NSNumber numberWithInteger:1666784], @"id",
									[NSNumber numberWithBool:YES], @"has_wiki",
									@"git@github.com:github/developer.github.com.git", @"ssh_url",
									@"https://github.com/github/developer.github.com.git", @"clone_url",
									[NSNumber numberWithBool:YES], @"has_issues",
									@"2011-04-26T19:20:56Z", @"created_at",
									@"https://github.com/github/developer.github.com", @"html_url",
									nil],															@"source",
								   
								   // Parent:
								   [NSDictionary dictionaryWithObjectsAndKeys:
									@"GitHub API documentation", @"description",
									@"2012-02-10T22:36:35Z", @"pushed_at",
									@"Ruby", @"language",
									[NSNumber numberWithBool:NO], @"fork",
									@"https://api.github.com/repos/github/developer.github.com", @"url",
									@"master", @"master_branch",
									[NSNumber numberWithInteger:26], @"open_issues",
									[NSNumber numberWithBool:YES], @"has_downloads",
									@"2012-02-13T21:45:50Z", @"updated_at",
									// Parent owner:
									[NSDictionary dictionaryWithObjectsAndKeys:
									 @"github", @"login",
									 [NSNumber numberWithInteger:9919], @"id",
									 @"https://secure.gravatar.com/avatar/61024896f291303615bcd4f7a0dcfb74?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-orgs.png", @"avatar_url",
									 @"https://api.github.com/users/github", @"url",
									 @"61024896f291303615bcd4f7a0dcfb74", @"gravatar_id",
									 nil], @"owner",
									
									@"git://git.example.com/original/developer.github.com.git", @"mirror_url",
									[NSNumber numberWithBool:NO], @"private",
									@"git://github.com/github/developer.github.com.git", @"git_url",
									[NSNumber numberWithInteger:65], @"forks",
									@"developer.github.com", @"name",
									@"http://developer.github.com", @"homepage",
									@"https://github.com/github/developer.github.com", @"svn_url",
									[NSNumber numberWithInteger:160], @"size",
									[NSNumber numberWithInteger:162], @"watchers",
									[NSNumber numberWithInteger:1666784], @"id",
									[NSNumber numberWithBool:YES], @"has_wiki",
									@"git@github.com:github/developer.github.com.git", @"ssh_url",
									@"https://github.com/github/developer.github.com.git", @"clone_url",
									[NSNumber numberWithBool:YES], @"has_issues",
									@"2011-04-26T19:20:56Z", @"created_at",
									@"https://github.com/github/developer.github.com", @"html_url",
									nil],															@"parent",
								   nil];
		
		dictionary = [CDOHResource mergeSubclassDictionary:localDict withSuperclassDictionary:superDict];
	});
	
	return dictionary;
}

// Two repositories are equal if their identifiers are equal (i.e. the value for
// the `id` key).
+ (NSDictionary *)firstTestDictionaryAlt
{
	static NSDictionary *dictionary = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSDictionary *firstTest = [self firstTestDictionary];
		NSNumber *repoId = [firstTest objectForKey:@"id"];
		
		NSDictionary *superDict = [self firstTestDictionaryAlt];
		NSDictionary *localDict = [NSDictionary dictionaryWithObjectsAndKeys:
								   // This ID must be equal to that of
								   // +firstTestDictionary.
								   repoId, @"id",
								   
								   @"https://github.com/laullon/gitx", @"html_url",
								   @"2012-02-12T19:35:37Z", @"pushed_at",
								   [NSDictionary dictionaryWithObjectsAndKeys:
									@"https://github.com/pieter/gitx", @"html_url",
									@"2011-09-26T17:01:37Z", @"pushed_at",
									@"Objective-C", @"language",
									[NSNumber numberWithBool:NO], @"fork",
									@"https://api.github.com/repos/pieter/gitx", @"url",
									@"master", @"master_branch",
									[NSNumber numberWithInteger:6], @"open_issues",
									[NSNumber numberWithBool:NO], @"has_downloads",
									@"2012-02-13T17:53:16Z", @"updated_at",
									[NSDictionary dictionaryWithObjectsAndKeys:
									 @"pieter", @"login",
									 [NSNumber numberWithInteger:2958], @"id",
									 @"https://secure.gravatar.com/avatar/0061469acb2e8e5720207b4a5eba3008?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-140.png", @"avatar_url",
									 @"https://api.github.com/users/pieter", @"url",
									 @"0061469acb2e8e5720207b4a5eba3008", @"gravatar_id",
									 nil], @"owner",
									@"git://git.example.com/original/developer.github.com.git", @"mirror_url",
									[NSNumber numberWithBool:NO], @"private",
									@"git://github.com/pieter/gitx.git", @"git_url",
									[NSNumber numberWithInteger:295], @"forks",
									@"gitx", @"name",
									@"http://gitx.frim.nl", @"homepage",
									@"https://github.com/pieter/gitx", @"svn_url",
									[NSNumber numberWithInteger:12288], @"size",
									[NSNumber numberWithInteger:1625], @"watchers",
									[NSNumber numberWithInteger:25306], @"id",
									[NSNumber numberWithBool:YES], @"has_wiki",
									@"git@github.com:pieter/gitx.git", @"ssh_url",
									@"https://github.com/pieter/gitx.git", @"clone_url",
									[NSNumber numberWithBool:NO], @"has_issues",
									@"2008-06-14T17:57:35Z", @"created_at",
									@"A gitk clone for OS X", @"description",
									nil], @"source",
								   @"Objective-C", @"language",
								   [NSNumber numberWithBool:YES], @"fork",
								   @"https://api.github.com/repos/laullon/gitx", @"url",
								   @"master", @"master_branch",
								   [NSNumber numberWithInteger:74], @"open_issues",
								   [NSNumber numberWithBool:YES], @"has_downloads",
								   @"2012-02-13T09:17:13Z", @"updated_at",
								   [NSDictionary dictionaryWithObjectsAndKeys:
									@"laullon", @"login",
									[NSNumber numberWithInteger:79835], @"id",
									@"https://secure.gravatar.com/avatar/e21be9a6faf4972ee0a7020c8572e655?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-140.png", @"avatar_url",
									@"https://api.github.com/users/laullon", @"url",
									@"e21be9a6faf4972ee0a7020c8572e655", @"gravatar_id",
									nil], @"owner",
								   @"git://git.example.com/original/developer.github.com.git", @"mirror_url",
								   [NSNumber numberWithBool:NO], @"private",
								   @"git://github.com/laullon/gitx.git", @"git_url",
								   [NSNumber numberWithInteger:65], @"forks",
								   @"gitx", @"name",
								   [NSDictionary dictionaryWithObjectsAndKeys:
									@"https://github.com/dgrijalva/gitx", @"html_url",
									@"2010-06-02T09:47:52Z", @"pushed_at",
									@"Objective-C", @"language",
									[NSNumber numberWithBool:YES], @"fork",
									@"https://api.github.com/repos/dgrijalva/gitx", @"url",
									@"master", @"master_branch",
									[NSNumber numberWithInteger:0], @"open_issues",
									[NSNumber numberWithBool:YES], @"has_downloads",
									@"2012-02-07T16:23:52Z", @"updated_at",
									[NSDictionary dictionaryWithObjectsAndKeys:
									 @"dgrijalva", @"login",
									 [NSNumber numberWithInteger:23713], @"id",
									 @"https://secure.gravatar.com/avatar/584559348afbc5cc06c46c3b5746313a?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-140.png", @"avatar_url",
									 @"https://api.github.com/users/dgrijalva", @"url",
									 @"584559348afbc5cc06c46c3b5746313a", @"gravatar_id",
									 nil], @"owner",
									@"git://git.example.com/original/developer.github.com.git", @"mirror_url",
									[NSNumber numberWithBool:NO], @"private",
									@"git://github.com/dgrijalva/gitx.git", @"git_url",
									[NSNumber numberWithInteger:3], @"forks",
									@"gitx", @"name",
									@"http://github.com/pieter/gitx/wikis", @"homepage",
									@"https://github.com/dgrijalva/gitx", @"svn_url",
									[NSNumber numberWithInteger:7708], @"size",
									[NSNumber numberWithInteger:9], @"watchers",
									[NSNumber numberWithInteger:55532], @"id",
									[NSNumber numberWithBool:YES], @"has_wiki",
									@"git@github.com:dgrijalva/gitx.git", @"ssh_url",
									@"https://github.com/dgrijalva/gitx.git", @"clone_url",
									[NSNumber numberWithBool:YES], @"has_issues",
									@"2008-09-23T10:01:33Z", @"created_at",
									@"A gitk clone for OS X", @"description",
									nil], @"parent",
								   @"https://github.com/laullon/gitx", @"svn_url",
								   @"http://gitx.laullon.com/", @"homepage",
								   [NSNumber numberWithInteger:727], @"watchers",
								   [NSNumber numberWithInteger:10031], @"size",
								   [NSNumber numberWithBool:YES], @"has_wiki",
								   @"git@github.com:laullon/gitx.git", @"ssh_url",
								   @"https://github.com/laullon/gitx.git", @"clone_url",
								   [NSNumber numberWithBool:YES], @"has_issues",
								   @"2010-06-09T03:08:06Z", @"created_at",
								   @"GitX (L) - A gitk clone for OS X", @"description",
								   nil];
		
		dictionary = [CDOHResource mergeSubclassDictionary:localDict withSuperclassDictionary:superDict];
	});
	
	return dictionary;
}

+ (NSDictionary *)secondTestDictionary
{
	static NSDictionary *dictionary = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSDictionary *superDict = [super firstTestDictionary];
		NSDictionary *localDict = [NSDictionary dictionaryWithObjectsAndKeys:
								   @"https://github.com/mirrors/linux", @"html_url",
								   @"2012-02-12T02:26:37Z", @"pushed_at",
								   @"C", @"language",
								   [NSNumber numberWithBool:NO], @"fork",
								   @"https://api.github.com/repos/mirrors/linux", @"url",
								   @"master", @"master_branch",
								   [NSNumber numberWithInteger:0], @"open_issues",
								   [NSNumber numberWithBool:YES], @"has_downloads",
								   @"2012-02-13T20:00:03Z", @"updated_at",
								   [NSDictionary dictionaryWithObjectsAndKeys:
									@"mirrors", @"login",
									[NSNumber numberWithInteger:28013], @"id",
									@"https://secure.gravatar.com/avatar/556b6ba33c28d2866a9e621a112eed72?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-140.png", @"avatar_url",
									@"https://api.github.com/users/mirrors", @"url",
									@"556b6ba33c28d2866a9e621a112eed72", @"gravatar_id",
									nil], @"owner",
								   @"git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git", @"mirror_url",
								   [NSNumber numberWithBool:NO], @"private",
								   @"git://github.com/mirrors/linux.git", @"git_url",
								   [NSNumber numberWithInteger:62], @"forks",
								   @"linux", @"name",
								   @"http://kernel.org/", @"homepage",
								   [NSNumber numberWithInteger:13412], @"size",
								   @"https://github.com/mirrors/linux", @"svn_url",
								   [NSNumber numberWithInteger:188], @"watchers",
								   [NSNumber numberWithInteger:2104682], @"id",
								   [NSNumber numberWithBool:YES], @"has_wiki",
								   @"git@github.com:mirrors/linux.git", @"ssh_url",
								   @"https://github.com/mirrors/linux.git", @"clone_url",
								   [NSNumber numberWithBool:YES], @"has_issues",
								   @"2011-07-26T02:32:55Z", @"created_at",
								   @"Mirror of Linus Torvald's Kernel Tree", @"description",
								   nil];

		
		dictionary = [CDOHResource mergeSubclassDictionary:localDict withSuperclassDictionary:superDict];
	});
	
	return dictionary;
}



@end
