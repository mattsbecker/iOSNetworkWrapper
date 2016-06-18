//
//  NetworkWrapper.h
//  NetworkWrapper
//
//  Created by Matt on 6/1/16.
//  Copyright © 2016 Matt S Becker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkWrapper : NSObject<NSURLSessionDelegate, NSURLSessionDataDelegate, NSURLSessionTaskDelegate>

//typedef void (^NetworkWrapperCompletionHandler)(NSData * resumeData, NSError * error) completionHandler;
typedef void (^NetworkWrapperCompletionHandler)(NSInteger statusCode, NSDictionary *responseHeaders, NSData *responseData, NSError *error);

@property (nonatomic, strong) NSString *baseURL;
@property (nonatomic, assign) NSInteger basePort;
@property (nonatomic, assign) NSString *scheme;
@property (nonatomic, strong) NSMutableArray *requests;

/**
 @brief initializes a new NetworkWrapper (dispatched once)
 **/
+ (NetworkWrapper *)sharedWrapper;


/**
 @brief creates and returns an NSURL for the desired path
 @return NSURL for the desired path
 **/
- (NSURL*)createWebRequestURLWithPath:(NSString *) path;

/**
 @brief Performs an HTTP request with the given parameters. Returns the response of the desired request as 
 part of the notification provided in responseNotification.
 @param path - An NSString containing the path of the desired HTTP request
 @param method - An NSString containing the method to be used for the HTTP request
 @param requestBody - An NSString containing the HTTP body to be provided in the HTTP request
 @param requestHeaders - An NSDictionary containing any desired, additional HTTP request headers
 @param responseNotification - An NSString containing the value of the Notification that should be called when the HTTP request completes. 
 @param context - An NSString identifying the origin of the HTTP request
 @return BOOL - indicating whether or not the request could be sent
 **/
- (BOOL)performHTTPRequestWithPath:(NSString *) path method:(NSString *) method requestBody:(NSString *) body requestHeaders:(NSDictionary *) headers responseNotification:(NSString *) notification context: (NSString *) context;


/**@brief Performs an HTTP request with the given parameters. Returns the response of the desired request to the provided block completionHandler.
@param path - An NSString containing the path of the desired HTTP request
@param method - An NSString containing the method to be used for the HTTP request
@param requestBody - An NSString containing the HTTP body to be provided in the HTTP request
@param requestHeaders - An NSDictionary containing any desired, additional HTTP request headers
@param completionHandler - A NetworkWrapperCompletionHandler block which should receive the response
@return void
**/
-(void)performHTTPRequestWithPath:(NSString *) path
                           method:(NSString *) method
                      requestBody:(NSString *) body
                   requestHeaders:(NSDictionary *) headers
                completionHandler:(NetworkWrapperCompletionHandler) handler;

/**
 @brief Resets all wrapper properties to their default/empty values
 **/
-(void)setDefaultWrapperProperties;
@end
