//
//  NetworkWrapperTests.m
//  NetworkWrapperTests
//
//  Created by Matt on 6/1/16.
//  Copyright © 2016 Matt S Becker. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NetworkWrapper.h"

@interface NetworkWrapperTests : XCTestCase
@property (nonatomic, retain) NetworkWrapper *networkWrapper;
@end

@implementation NetworkWrapperTests

- (void)setUp {
    [super setUp];
    self.networkWrapper = [NetworkWrapper sharedWrapper];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)testCreateNetworkWrapper {
    self.networkWrapper = [NetworkWrapper sharedWrapper];
    XCTAssertNotNil(self.networkWrapper);
}

- (void)testSetInvalidHostLength {
    self.networkWrapper.baseURL = @"";
    XCTAssertNil([NetworkWrapper sharedWrapper].baseURL);
}

- (void)testSetNilHost {
    self.networkWrapper.baseURL = nil;
    XCTAssertNil([NetworkWrapper sharedWrapper].baseURL);
}

- (void)testSetValidHost {
    self.networkWrapper.baseURL = @"mattsbecker.com";
    XCTAssertEqual(self.networkWrapper.baseURL, @"mattsbecker.com");
}

- (void)testSetNilPort {
    self.networkWrapper.basePort = nil;
    XCTAssertEqual(self.networkWrapper.basePort, 0);
}

- (void)testSetValidPort {
    self.networkWrapper.basePort = 80;
    XCTAssertEqual(self.networkWrapper.basePort, 80);
}

- (void)testSetInvalidSchemeLength {
    self.networkWrapper.scheme = @"";
    XCTAssertEqual(self.networkWrapper.scheme, @"http");
}

- (void)testSetNilScheme {
    self.networkWrapper.scheme = nil;
    XCTAssertEqual(self.networkWrapper.scheme, @"http");
}

- (void)testSetValidScheme {
    self.networkWrapper.baseURL = @"https";
    XCTAssertEqual(self.networkWrapper.baseURL, @"https");
}

- (void)testCreateRequestValidPath {
    self.networkWrapper.baseURL = @"mattsbecker.com";
    self.networkWrapper.basePort = 80;
    self.networkWrapper.scheme = @"https";
    NSString *requestString = [self.networkWrapper createWebRequestURLWithPath:@"testpath"].absoluteString;
    XCTAssertTrue([requestString isEqualToString:@"https://mattsbecker.com:80/testpath"]);
}


- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
