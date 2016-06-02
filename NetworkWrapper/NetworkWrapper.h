//
//  NetworkWrapper.h
//  NetworkWrapper
//
//  Created by Matt on 6/1/16.
//  Copyright © 2016 Matt S Becker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkWrapper : NSObject<NSURLSessionDelegate, NSURLSessionTaskDelegate>

@property (nonatomic, retain) NSString *baseURL;
@property (nonatomic, assign) NSInteger basePort;
@property (nonatomic, assign) NSString *scheme;

/**
 @brief initializes a new NetworkWrapper (dispatched once) 
 **/
+ (NetworkWrapper *)sharedWrapper;

- (NSURL*)createWebRequestURLWithPath:(NSString *) path;
- (BOOL)performHTTPRequestWithPath:(NSString *) path
                           method:(NSString *) method
                      requestBody:(NSString *) body
                   requestHeaders:(NSDictionary *) headers
                          context: (NSString *) context;


@end
