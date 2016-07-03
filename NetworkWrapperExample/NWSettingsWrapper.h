//
//  NWSettingsWrapper.h
//  NetworkWrapper
//
//  Created by Matt Becker on 7/3/16.
//  Copyright © 2016 Matt S Becker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NWSettingsWrapper : NSObject

+(void)setStringValue:(NSString*)value forKey:(NSString*) key;
+(NSString*)stringValueForKey:(NSString*)key;

@end

@interface NSUserDefaults (Testing)

+(NSUserDefaults*)temporaryDefaults;

@end
