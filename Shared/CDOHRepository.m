//
//  CDOHRepository.m
//  ObjectiveHub
//
//  Copyright 2011 Aron Cedercrantz. All rights reserved.
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

#import "CDOHRepository.h"


@implementation CDOHRepository

@synthesize HTMLURL = _htmlUrl;
@synthesize cloneURL = _cloneUrl;
@synthesize gitURL = _gitUrl;
@synthesize SSHURL = _sshUrl;
@synthesize svnURL = _svnUrl;
@synthesize owner = _owner;
@synthesize name = _name;
@synthesize description = _description;
@synthesize homepage = _homepage;
@synthesize languages = _languages;
@synthesize private = _private;
@synthesize watchers = _watchers;
@synthesize size = _size;
@synthesize defaultBranch = _defaultBranch;
@synthesize openIssues = _openIssues;
@synthesize hasIssues = _hasIssues;
@synthesize pushedAt = _pushedAt;
@synthesize createdAt = _createdAt;
@synthesize organization = _organization;
@synthesize fork = _fork;
@synthesize forks = _forks;
@synthesize parentRepository = _parentRepository;
@synthesize sourceRepository = _sourceRepository;
@synthesize hasWiki = _hasWiki;
@synthesize hasDownloads = _hasDownloads;


#pragma mark - Initial
- (id)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super initWithDictionary:dictionary];
	if (self) {
		
	}
	
	return self;
}

@end
