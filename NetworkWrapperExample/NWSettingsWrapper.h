//
//  NWSettingsWrapper.h
//  NetworkWrapper
//
//  Created by Matt Becker on 7/3/16.
//  Copyright © 2016 Matt S Becker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NWSettingsWrapper : NSObject

extern NSString *kNWSettingsRecentRequentsKey;

/** 
 @brief Sets a string value for a user default with a given key, performs synchronization automatically
 @param value - An NSString containing the value that should be persisted to user defaults
 @param key - An NSString containing the key for the value that should be persister to defaults
 @return nil
**/
+(void)setStringValue:(NSString*)value forKey:(NSString*) key;
+(NSString*)stringValueForKey:(NSString*)key;

+(void)setMutableArrayValue:(NSMutableArray*)value forKey:(NSString *)key;
+(NSMutableArray*)mutableArrayValueForKey:(NSString*)key;

+(void)addObject:(id)object toArrayWithKey:(NSString *)key;

@end

@interface NSUserDefaults (Testing)

+(NSUserDefaults*)temporaryDefaults;

@end
