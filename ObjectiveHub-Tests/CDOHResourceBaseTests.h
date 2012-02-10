//
//  CDOHResourceTestsBase.h
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

#import <SenTestingKit/SenTestingKit.h>
#import <Foundation/Foundation.h>


#define CDOHTestNumFromUInteger(x) [NSNumber numberWithUnsignedInteger:((NSUInteger)x)]


@class CDOHResource;


// Resource base test case class.
@interface CDOHResourceBaseTests : SenTestCase

#pragma mark - Tested Class
// The resource class which is being tested.
//
// This method MUST be overriden by the subclass and the returned class MUST be
// a subclass of the `CDOHResource` class.
+ (Class)testedClass;


#pragma mark - Test Dictionaries
// The methods `firstTestDictionary` and `secondTestDictionary` must return
// different (as defined by the resource’s `isEqual:` method) but two calls to
// the same method should yeild the same dictionary.
//
// These methods MUST be overriden by the subclass but it is recommended that
// their result is merged with the dictionary returned by the super-class to
// fully test the resource.
+ (NSDictionary *)firstTestDictionary;
+ (NSDictionary *)secondTestDictionary;

// The dictionary returned by `firstTestDictionaryAlt` MUST create an identical
// resource (as defined by the resource’s `isEqual:` method) but in every other
// respect be different.
//
// This methods MUST be overriden by the subclass but it is recommended that
// their result is merged with the dictionary returned by the super-class to
// fully test the resource.
+ (NSDictionary *)firstTestDictionaryAlt;

// Merges two dictionaries.
// No need to override this, just a nice helper :)
+ (NSDictionary *)mergeOwnTestDictionary:(NSDictionary *)dictionary withSuperDictionary:(NSDictionary *)superDictionary;


#pragma mark - Shared Test Resources
// Use these methods to get a resource initialized using the coresponding test
// dictionary.
// Resource initialized using the firstTestDictionary
- (CDOHResource *)firstTestResource;
- (CDOHResource *)firstTestResourceAlt;
- (CDOHResource *)secondTestResource;



#pragma mark - Test Cases:
// -------------------------------------------------------------------------- //
// The methods below this line MAY be overriden if needed. It is strongly     //
// recommended to call the super-implementation if you override any one of    //
// the methods, unless you know exactly what you are doing.                   //
// -------------------------------------------------------------------------- //

#pragma mark - Test Resource Equality and Hash
// Test the equality of the resource.
- (void)testResourceEquality;
// Test to make sure different resources are not reported as equal.
- (void)testResourceInequality;
// Test the hash method for equal instances of the resource.
- (void)testResourceHashEqual;
// Test to make sure different resources (of the same type) do not have the
// same hash.
- (void)testResourceHashInequal;


#pragma mark - Test Dictionary Encoding and Decoding
// Test to make sure we create new resources using a dictionary.
- (void)testResourceDecodeFromDictionary;
// Test to make sure we can encoed the resource as a dictionary.
- (void)testResourceEncodeAsDictionary;


#pragma mark - Test NSCoding Encoding and Decoding
// Test that the resource conforms to the `NSCoding` protocol.
- (void)testResourceConformsToNSCoding;
// Test that the resource can be encoded and then decoded using a
// `NSKeyedArchiver` respectively a `NSKeyedUnarchiver`.
- (void)testResourceNSCodingRoundTrip;


#pragma mark - Test NSCopying Conformans
// Test that the resource conforms to the `NSCopying` protocol.
- (void)testResourceConformsToNSCopying;
// All resources should be immutable and as such they should only retain
// themselves when "copied".
- (void)testResourceImmutableCopy;


@end
