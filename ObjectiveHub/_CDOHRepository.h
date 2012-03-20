// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CDOHRepository.h instead.

#import <CoreData/CoreData.h>
#import "CDOHResource.h"

extern const struct CDOHRepositoryAttributes {
	__unsafe_unretained NSString *createdAt;
	__unsafe_unretained NSString *defaultBranch;
	__unsafe_unretained NSString *fork;
	__unsafe_unretained NSString *forksCount;
	__unsafe_unretained NSString *hasDownloads;
	__unsafe_unretained NSString *hasIssues;
	__unsafe_unretained NSString *hasWiki;
	__unsafe_unretained NSString *identifier;
	__unsafe_unretained NSString *language;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *openIssuesCount;
	__unsafe_unretained NSString *p_cloneURL;
	__unsafe_unretained NSString *p_gitURL;
	__unsafe_unretained NSString *p_homepageURL;
	__unsafe_unretained NSString *p_mirrorURL;
	__unsafe_unretained NSString *p_repositoryHTMLURL;
	__unsafe_unretained NSString *p_sshURL;
	__unsafe_unretained NSString *p_svnURL;
	__unsafe_unretained NSString *private;
	__unsafe_unretained NSString *pushedAt;
	__unsafe_unretained NSString *repositoryDescription;
	__unsafe_unretained NSString *size;
	__unsafe_unretained NSString *updatedAt;
	__unsafe_unretained NSString *watchersCount;
} CDOHRepositoryAttributes;

extern const struct CDOHRepositoryRelationships {
	__unsafe_unretained NSString *forks;
	__unsafe_unretained NSString *organization;
	__unsafe_unretained NSString *owner;
	__unsafe_unretained NSString *parent;
	__unsafe_unretained NSString *source;
	__unsafe_unretained NSString *watchers;
} CDOHRepositoryRelationships;

extern const struct CDOHRepositoryFetchedProperties {
} CDOHRepositoryFetchedProperties;

@class CDOHRepository;
@class CDOHOrganization;
@class CDOHAbstractUser;
@class CDOHRepository;
@class CDOHRepository;
@class CDOHUser;












@class NSObject;
@class NSObject;
@class NSObject;
@class NSObject;
@class NSObject;
@class NSObject;
@class NSObject;







@interface CDOHRepositoryID : NSManagedObjectID {}
@end

@interface _CDOHRepository : CDOHResource {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CDOHRepositoryID*)objectID;




@property (nonatomic, strong) NSDate * createdAt;


//- (BOOL)validateCreatedAt:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString * defaultBranch;


//- (BOOL)validateDefaultBranch:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber * fork;


@property BOOL forkValue;
- (BOOL)forkValue;
- (void)setForkValue:(BOOL)value_;

//- (BOOL)validateFork:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber * forksCount;


@property int32_t forksCountValue;
- (int32_t)forksCountValue;
- (void)setForksCountValue:(int32_t)value_;

//- (BOOL)validateForksCount:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber * hasDownloads;


@property BOOL hasDownloadsValue;
- (BOOL)hasDownloadsValue;
- (void)setHasDownloadsValue:(BOOL)value_;

//- (BOOL)validateHasDownloads:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber * hasIssues;


@property BOOL hasIssuesValue;
- (BOOL)hasIssuesValue;
- (void)setHasIssuesValue:(BOOL)value_;

//- (BOOL)validateHasIssues:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber * hasWiki;


@property BOOL hasWikiValue;
- (BOOL)hasWikiValue;
- (void)setHasWikiValue:(BOOL)value_;

//- (BOOL)validateHasWiki:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber * identifier;


@property int64_t identifierValue;
- (int64_t)identifierValue;
- (void)setIdentifierValue:(int64_t)value_;

//- (BOOL)validateIdentifier:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString * language;


//- (BOOL)validateLanguage:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString * name;


//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber * openIssuesCount;


@property int32_t openIssuesCountValue;
- (int32_t)openIssuesCountValue;
- (void)setOpenIssuesCountValue:(int32_t)value_;

//- (BOOL)validateOpenIssuesCount:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) id p_cloneURL;


//- (BOOL)validateP_cloneURL:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) id p_gitURL;


//- (BOOL)validateP_gitURL:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) id p_homepageURL;


//- (BOOL)validateP_homepageURL:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) id p_mirrorURL;


//- (BOOL)validateP_mirrorURL:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) id p_repositoryHTMLURL;


//- (BOOL)validateP_repositoryHTMLURL:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) id p_sshURL;


//- (BOOL)validateP_sshURL:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) id p_svnURL;


//- (BOOL)validateP_svnURL:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber * private;


@property BOOL privateValue;
- (BOOL)privateValue;
- (void)setPrivateValue:(BOOL)value_;

//- (BOOL)validatePrivate:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSDate * pushedAt;


//- (BOOL)validatePushedAt:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString * repositoryDescription;


//- (BOOL)validateRepositoryDescription:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber * size;


@property int64_t sizeValue;
- (int64_t)sizeValue;
- (void)setSizeValue:(int64_t)value_;

//- (BOOL)validateSize:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSDate * updatedAt;


//- (BOOL)validateUpdatedAt:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber * watchersCount;


@property int32_t watchersCountValue;
- (int32_t)watchersCountValue;
- (void)setWatchersCountValue:(int32_t)value_;

//- (BOOL)validateWatchersCount:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet* forks;

- (NSMutableSet*)forksSet;




@property (nonatomic, strong) CDOHOrganization* organization;

//- (BOOL)validateOrganization:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) CDOHAbstractUser* owner;

//- (BOOL)validateOwner:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) CDOHRepository* parent;

//- (BOOL)validateParent:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) CDOHRepository* source;

//- (BOOL)validateSource:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet* watchers;

- (NSMutableSet*)watchersSet;





@end

@interface _CDOHRepository (CoreDataGeneratedAccessors)

- (void)addForks:(NSSet*)value_;
- (void)removeForks:(NSSet*)value_;
- (void)addForksObject:(CDOHRepository*)value_;
- (void)removeForksObject:(CDOHRepository*)value_;

- (void)addWatchers:(NSSet*)value_;
- (void)removeWatchers:(NSSet*)value_;
- (void)addWatchersObject:(CDOHUser*)value_;
- (void)removeWatchersObject:(CDOHUser*)value_;

@end

@interface _CDOHRepository (CoreDataGeneratedPrimitiveAccessors)


- (NSDate *)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSDate *)value;




- (NSString *)primitiveDefaultBranch;
- (void)setPrimitiveDefaultBranch:(NSString *)value;




- (NSNumber *)primitiveFork;
- (void)setPrimitiveFork:(NSNumber *)value;

- (BOOL)primitiveForkValue;
- (void)setPrimitiveForkValue:(BOOL)value_;




- (NSNumber *)primitiveForksCount;
- (void)setPrimitiveForksCount:(NSNumber *)value;

- (int32_t)primitiveForksCountValue;
- (void)setPrimitiveForksCountValue:(int32_t)value_;




- (NSNumber *)primitiveHasDownloads;
- (void)setPrimitiveHasDownloads:(NSNumber *)value;

- (BOOL)primitiveHasDownloadsValue;
- (void)setPrimitiveHasDownloadsValue:(BOOL)value_;




- (NSNumber *)primitiveHasIssues;
- (void)setPrimitiveHasIssues:(NSNumber *)value;

- (BOOL)primitiveHasIssuesValue;
- (void)setPrimitiveHasIssuesValue:(BOOL)value_;




- (NSNumber *)primitiveHasWiki;
- (void)setPrimitiveHasWiki:(NSNumber *)value;

- (BOOL)primitiveHasWikiValue;
- (void)setPrimitiveHasWikiValue:(BOOL)value_;




- (NSNumber *)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSNumber *)value;

- (int64_t)primitiveIdentifierValue;
- (void)setPrimitiveIdentifierValue:(int64_t)value_;




- (NSString *)primitiveLanguage;
- (void)setPrimitiveLanguage:(NSString *)value;




- (NSString *)primitiveName;
- (void)setPrimitiveName:(NSString *)value;




- (NSNumber *)primitiveOpenIssuesCount;
- (void)setPrimitiveOpenIssuesCount:(NSNumber *)value;

- (int32_t)primitiveOpenIssuesCountValue;
- (void)setPrimitiveOpenIssuesCountValue:(int32_t)value_;




- (id)primitiveP_cloneURL;
- (void)setPrimitiveP_cloneURL:(id)value;




- (id)primitiveP_gitURL;
- (void)setPrimitiveP_gitURL:(id)value;




- (id)primitiveP_homepageURL;
- (void)setPrimitiveP_homepageURL:(id)value;




- (id)primitiveP_mirrorURL;
- (void)setPrimitiveP_mirrorURL:(id)value;




- (id)primitiveP_repositoryHTMLURL;
- (void)setPrimitiveP_repositoryHTMLURL:(id)value;




- (id)primitiveP_sshURL;
- (void)setPrimitiveP_sshURL:(id)value;




- (id)primitiveP_svnURL;
- (void)setPrimitiveP_svnURL:(id)value;




- (NSNumber *)primitivePrivate;
- (void)setPrimitivePrivate:(NSNumber *)value;

- (BOOL)primitivePrivateValue;
- (void)setPrimitivePrivateValue:(BOOL)value_;




- (NSDate *)primitivePushedAt;
- (void)setPrimitivePushedAt:(NSDate *)value;




- (NSString *)primitiveRepositoryDescription;
- (void)setPrimitiveRepositoryDescription:(NSString *)value;




- (NSNumber *)primitiveSize;
- (void)setPrimitiveSize:(NSNumber *)value;

- (int64_t)primitiveSizeValue;
- (void)setPrimitiveSizeValue:(int64_t)value_;




- (NSDate *)primitiveUpdatedAt;
- (void)setPrimitiveUpdatedAt:(NSDate *)value;




- (NSNumber *)primitiveWatchersCount;
- (void)setPrimitiveWatchersCount:(NSNumber *)value;

- (int32_t)primitiveWatchersCountValue;
- (void)setPrimitiveWatchersCountValue:(int32_t)value_;





- (NSMutableSet*)primitiveForks;
- (void)setPrimitiveForks:(NSMutableSet*)value;



- (CDOHOrganization*)primitiveOrganization;
- (void)setPrimitiveOrganization:(CDOHOrganization*)value;



- (CDOHAbstractUser*)primitiveOwner;
- (void)setPrimitiveOwner:(CDOHAbstractUser*)value;



- (CDOHRepository*)primitiveParent;
- (void)setPrimitiveParent:(CDOHRepository*)value;



- (CDOHRepository*)primitiveSource;
- (void)setPrimitiveSource:(CDOHRepository*)value;



- (NSMutableSet*)primitiveWatchers;
- (void)setPrimitiveWatchers:(NSMutableSet*)value;


@end
