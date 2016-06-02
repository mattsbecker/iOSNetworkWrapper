//
//  AppDelegate.m
//  NetworkWrapperExample
//
//  Created by Matt on 6/2/16.
//  Copyright © 2016 Matt S Becker. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@property (nonatomic, retain) NetworkWrapper *networkWrapper;
@end

@implementation AppDelegate

NSString *kTestNotification = @"TestNotification";


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleResponse:) name:kTestNotification object:nil];
    
    // Override point for customization after application launch.
    self.networkWrapper = [NetworkWrapper sharedWrapper];
    self.networkWrapper.baseURL = @"agilezen.com";
    self.networkWrapper.basePort = 443;
    self.networkWrapper.scheme = @"https";
    
    NSURL *url = [self.networkWrapper createWebRequestURLWithPath:@"api/v1/projects"];
    NSLog(@"Projects URL is: %@", url.absoluteString);
    
    NSDictionary *headers = [NSDictionary dictionaryWithObjectsAndKeys:@"099c9ba364cf48e69d7d61b5c063b5c2", @"X-Zen-ApiKey", nil];
    BOOL httpCallStatus = [self.networkWrapper performHTTPRequestWithPath:@"api/v1/projects" method:@"GET" requestBody:nil requestHeaders:headers context:kTestNotification];
    
    return YES;
}

- (void)handleResponse:(NSNotification *) notification {
    NSLog(@"Handling notification");
    NSLog(@"Notification data: %@", notification.object);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end