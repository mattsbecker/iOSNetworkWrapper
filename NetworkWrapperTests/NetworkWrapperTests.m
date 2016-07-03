//
//  NetworkWrapperTests.m
//  NetworkWrapperTests
//
//  Created by Matt on 6/1/16.
//  Copyright © 2016 Matt S Becker. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NetworkWrapper.h"
#import "NWSettingsWrapper.h"

@interface NetworkWrapperTests : XCTestCase
@property (nonatomic, retain) NetworkWrapper *networkWrapper;
@end

@implementation NetworkWrapperTests

- (void)setUp {
    [super setUp];
    [[NetworkWrapper sharedWrapper] setDefaultWrapperProperties];
    self.networkWrapper = [NetworkWrapper sharedWrapper];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)testCreateNetworkWrapper {
    self.networkWrapper = [NetworkWrapper sharedWrapper];
    XCTAssertNotNil(self.networkWrapper);
}

- (void)testSetInvalidHostLength {
    self.networkWrapper.baseURL = @"";
    XCTAssertNil(self.networkWrapper.baseURL);
}

- (void)testSetNilHost {
    self.networkWrapper.baseURL = nil;
    XCTAssertNil(self.networkWrapper.baseURL);
}

- (void)testSetValidHost {
    self.networkWrapper.baseURL = @"mattsbecker.com";
    XCTAssertEqual(self.networkWrapper.baseURL, @"mattsbecker.com");
}

- (void)testSetValidPort {
    self.networkWrapper.basePort = 80;
    XCTAssertEqual(self.networkWrapper.basePort, 80);
}

- (void)testSetInvalidSchemeLength {
    self.networkWrapper.scheme = @"";
    XCTAssertEqual(self.networkWrapper.scheme, @"https");
}

- (void)testSetNilScheme {
    self.networkWrapper.scheme = nil;
    XCTAssertEqual(self.networkWrapper.scheme, @"https");
}

- (void)testSetValidScheme {
    self.networkWrapper.baseURL = @"https";
    XCTAssertEqual(self.networkWrapper.baseURL, @"https");
}

// we need a better way of ensuring request run after all of the getter/setter tests
- (void)testCreateRequestValidPath {
    self.networkWrapper.baseURL = @"mattsbecker.com";
    self.networkWrapper.basePort = 80;
    self.networkWrapper.scheme = @"https";
    NSString *requestString = [self.networkWrapper createWebRequestURLWithPath:@"testpath"].absoluteString;
    XCTAssertTrue([requestString isEqualToString:@"https://mattsbecker.com:80/testpath"]);
}

- (void)testPerformHTTPRequest {
    self.networkWrapper.baseURL = @"mattsbecker.com";
    self.networkWrapper.basePort = 80;
    self.networkWrapper.scheme = @"http";
    XCTAssertTrue([self.networkWrapper performHTTPRequestWithPath:@"/" method:@"GET" requestBody:nil requestHeaders:nil responseNotification:nil context:@""]);
}

- (void)testPerformHTTPRequestWithNilPath {
    self.networkWrapper.baseURL = nil;
    self.networkWrapper.basePort = 80;
    self.networkWrapper.scheme = @"http";
    XCTAssertFalse([self.networkWrapper performHTTPRequestWithPath:nil method:@"GET" requestBody:nil requestHeaders:nil responseNotification:nil context:@"TestCall"]);
}

-(void)testGetImageAtUrl {
    NSString *imageURL = @"http://static1.squarespace.com/static/5738f10f27d4bd28d98cf114/5738f4cad210b8ad84923ccf/5739eb24c6fc0814567150d8/1463413622693/Beck.jpg";

    XCTAssertTrue([self.networkWrapper getImageAtURL:imageURL
                                      requestHeaders:nil
                                   completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        // Make sure the data came back!
        NSData *fileData = [NSData dataWithContentsOfURL:location];
        UIImage *resultingImage = [[UIImage alloc] initWithData:fileData];
        
        // make sure the image isn't nil!
        XCTAssertNotNil(resultingImage);
    }]);
}

-(void)testSetPreferencesValidStringValue {
    NSString *validString = @"ValidString";
    NSString *key = @"TestKey";

    [NWSettingsWrapper setStringValue:validString forKey:key];
    
    XCTAssertTrue([[NWSettingsWrapper stringValueForKey:key] isEqualToString:validString]);
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
