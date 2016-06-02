//
//  NetworkWrapper.m
//  NetworkWrapper
//
//  Created by Matt on 6/1/16.
//  Copyright © 2016 Matt S Becker. All rights reserved.
//

#import "NetworkWrapper.h"

@interface NetworkWrapper()
@end

@implementation NetworkWrapper

+ (NetworkWrapper *)sharedWrapper {
    static NetworkWrapper *networkWrapper = nil; // nil initially
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        networkWrapper = [[NetworkWrapper alloc] init];
    });
    if (!networkWrapper) return nil;
    networkWrapper.baseURL = nil; // no default. WE NEED THIS
    networkWrapper.scheme = @"http"; // default to HTTP
    networkWrapper.basePort = 0; // no default, WE NEED THIS
    return networkWrapper;
}

- (NSURL*)createWebRequestURLWithPath:(NSString *) path {
    NSURL *requestURL = nil;
    if (path) {
        NSString *requestURI = [NSString stringWithFormat:@"%@://%@:%ld/%@", self.scheme, self.baseURL, self.basePort, path];
        NSLog(@"Request URI: %@", requestURI);
        requestURL = [NSURL URLWithString:requestURI];
    }
    return requestURL;
}

- (BOOL)performHTTPRequestWithPath:(NSString *) path
                           method:(NSString *) method
                      requestBody:(NSString *) body
                   requestHeaders:(NSDictionary *) headers
                          context: (NSString *) context
{
    
    BOOL result = false;

    NSURL *requestURL = [[NSURL alloc] init];
    
    // if there is no path, we cannot continue. Return false.
    if (!path) {
        return result;
    } else {
        requestURL = [self createWebRequestURLWithPath:path];
    }
    
    // default to GET. Harmless.
    NSString *requestMethod = @"GET";
    if (method) {
        requestMethod = method;
    }
    
    // create a mutable urlRequest for this action from the requestURL constructed earlier
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:requestURL];
    [urlRequest setHTTPMethod:method];

    // if present, convert the body data to an NSData object used for populating the contents of the request
    if (body) {
        NSData *bodyData = [body dataUsingEncoding:NSUTF8StringEncoding];
        [urlRequest setHTTPBody:bodyData];
    }
    
    [urlRequest setHTTPShouldHandleCookies:YES];
    
    // if the request headers are left nil, then we'll use default headers
    if (headers) {
        [urlRequest setAllHTTPHeaderFields:headers];
    } else {
        // create headers for the request (content type is what really matters)
        NSDictionary *headerDict = [NSDictionary dictionaryWithObjectsAndKeys:@"text/html", @"Content-Type", nil];
        [urlRequest setAllHTTPHeaderFields:headerDict];
    }

    // Use an NSURLSession for our HTTP Request
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    //NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    NSURLSession *urlSession = [NSURLSession sharedSession];

    // perform the actual request with the session and the request that was created.
    NSURLSessionTask *task = [urlSession dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            // post a notification that the request has been completed
            char *responseData = (char*)data.bytes;
            NSString *responseBody = [NSString stringWithUTF8String:responseData];
            if (context) {
                [[NSNotificationCenter defaultCenter] postNotificationName:context object:responseBody];
            }
        } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:context object:error];
        }
    }];
    [task resume];
    result = true;
    return result;
}

- (void)URLSession:(NSURLSession *)session
didBecomeInvalidWithError:(NSError *)error {
    NSLog(@"Hit invalidation delegate method");
}

- (void)URLSession:(NSURLSession *)session
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition,
                             NSURLCredential *credential))completionHandler {
    NSLog(@"Hit invalidation delegate method");
}

#pragma mark --SETTERS--

- (void)setScheme:(NSString *)scheme {
    if (scheme != nil && _scheme != scheme && scheme.length > 0) {
        _scheme = scheme;
    }
}

@end
