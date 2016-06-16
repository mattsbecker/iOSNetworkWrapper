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
        networkWrapper = [[self alloc] init];
    });
    return networkWrapper;
}

- (id)init {
    if (self == [super init]) {
        self.baseURL = nil; // no default. WE NEED THIS
        self.scheme = @"http"; // default to HTTP
        self.basePort = 0; // no default, WE NEED THIS
        self.requests = [NSMutableArray array];
    }
    return self;
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

- (NSURL*)createWebRequestURLWithURI:(NSString *) uri {
    NSURL *requestURL = nil;
    if (uri) {
        NSString *requestURI = uri;
        NSLog(@"Request URI: %@", requestURI);
        requestURL = [NSURL URLWithString:requestURI];
    }
    return requestURL;
}


- (NSMutableURLRequest *)createHTTPURLRequestWithPath:(NSString *) path
                              method:(NSString *) method
                         requestBody:(NSString *) body
                      requestHeaders:(NSDictionary *) headers
{
    NSURL *requestURL = [[NSURL alloc] init];
    
    // if there is no path, we cannot continue. Return false.
    if (!path) {
        return nil;
    } else {
        if (([path containsString:@"http://"] || [path containsString:@"https://"]) && (!self.baseURL)) {
            // user provided a path containing a full URL. We can deal with that!
            requestURL = [self createWebRequestURLWithURI:path];
        } else {
            requestURL = [self createWebRequestURLWithPath:path];
        }
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
    
    // we've gotten far enough to store the request; do so. This will eventually be our queue.
    [self.requests addObject:urlRequest];
    
    return urlRequest;
}

- (void)performHTTPRequestWithPath:(NSString *) path
                            method:(NSString *) method
                       requestBody:(NSString *) body
                    requestHeaders:(NSDictionary *) headers
                 completionHandler:(NetworkWrapperCompletionHandler) handler
{
    if (!path) {
        return;
    }
    NSMutableURLRequest *urlRequest = [self createHTTPURLRequestWithPath:path method:method requestBody:body requestHeaders:headers];
    
    // Use an NSURLSession for our HTTP Request
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // We can receive delegate responses if we'd like this way, which is nice.
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    // perform the actual request with the session and the request that was created.
    NSURLSessionDataTask *task = [urlSession dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                NSLog(@"%@", response);
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
                NSInteger statusCode = [httpResponse statusCode];
                NSDictionary *headers = httpResponse.allHeaderFields;
                
                // Important! Using NSString initWithBytes/ASCIIStringEncoding is 10000% more reliable than stringWithUTF8String. Because we're outputting to the log here, we're just printing ASCII.
                NSLog(@"Did receive data, handler::: %@", [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding: NSASCIIStringEncoding]);
                // post a notification that the request has been completed
                handler(statusCode, headers, data, error);
            }
        });
    }];
    [task resume];
}

- (BOOL)performHTTPRequestWithPath:(NSString *) path
                            method:(NSString *) method
                       requestBody:(NSString *) body
                    requestHeaders:(NSDictionary *) headers
              responseNotification:(NSString *) notification
                           context: (NSString *) context
{
    
    BOOL result = false;

    NSMutableURLRequest *urlRequest = [self createHTTPURLRequestWithPath:path method:method requestBody:body requestHeaders:headers];
    
    // Use an NSURLSession for our HTTP Request
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // We can receive delegate responses if we'd like this way, which is nice.
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    // perform the actual request with the session and the request that was created.
    NSURLSessionTask *task = [urlSession dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            // post a notification that the request has been completed
            if (context) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
                NSInteger statusCode = [httpResponse statusCode];
                NSDictionary *headers = httpResponse.allHeaderFields;

                NSDictionary *responseDict = [NSDictionary dictionaryWithObjectsAndKeys:@(statusCode), @"status-code", headers, @"response-headers", data, @"response-body", context, @"context", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:notification object:nil userInfo:responseDict];
            }
        } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:context object:error];
        }
    }];
    [task resume];
    result = true;
    return result;
}


-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
//    NSLog(@"Did receive data!!: %@", [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding: NSASCIIStringEncoding]);
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSLog(@"Did complete with error: %@", error.localizedDescription);
}

- (void)URLSession:(NSURLSession *)session
didBecomeInvalidWithError:(NSError *)error {
    NSLog(@"Hit invalidation delegate method");
}

#pragma mark --SETTERS--

- (void)setScheme:(NSString *)scheme {
    if (scheme != nil && _scheme != scheme && scheme.length > 0) {
        _scheme = scheme;
    }
}

@end
