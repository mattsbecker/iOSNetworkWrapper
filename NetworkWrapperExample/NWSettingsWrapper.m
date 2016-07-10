//
//  NWSettingsWrapper.m
//  NetworkWrapper
//
//  Created by Matt Becker on 7/3/16.
//  Copyright © 2016 Matt S Becker. All rights reserved.
//

#import "NWSettingsWrapper.h"

NSString *kNWSettingsRecentRequentsKey = @"NWExampleSettingsRecentRequests";

@interface NWSettingsWrapper()
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@end

@implementation NWSettingsWrapper

-(id)init {
    if (self == [super init]) {
        // perform initialization
        if (self == nil) {
            return nil;
        }
        [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:kNWSettingsRecentRequentsKey, [NSMutableArray array],
        nil]];
    }
    return self;
}

#pragma mark Setters

+(void)setStringValue:(NSString*)value forKey:(NSString*) key {
    if (!value || !key) {
        NSLog(@"Failed to set string value for key with a nil object");
        return;
    }
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)setBooleanValue:(BOOL)value forKey:(NSString*) key {
    if (!key) {
        NSLog(@"Failed to set boolean value for key with a nil key");
    }
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)setArrayValue:(NSArray*)value forKey:(NSString *) key {
    if ((!value || !key) && value.class == [NSArray class]) {
        NSLog(@"Failed to set array value for key with a nil object");
    }
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)setMutableArrayValue:(NSMutableArray*)value forKey:(NSString *)key {
    if ((!value || !key) && value.class == [NSMutableArray class]) {
        NSLog(@"Failed to set array value for key with a nil object");
    }
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)addObject:(id)object toArrayWithKey:(NSString *)key {
    if (!object || !key) {
        NSLog(@"Failed to add value for array key");
    }
    // if the temporary array doesn't exist yet, create it
    NSMutableArray *tempArray = (NSMutableArray*)[NWSettingsWrapper mutableArrayValueForKey:key];
    if (!tempArray) {
        [NWSettingsWrapper setMutableArrayValue:[NSMutableArray array] forKey:kNWSettingsRecentRequentsKey];
        tempArray = (NSMutableArray*)[NWSettingsWrapper mutableArrayValueForKey:key];
    }
    [tempArray addObject:object];
    [NWSettingsWrapper setMutableArrayValue:tempArray forKey:key];
}

#pragma mark Getters

+(NSString*)stringValueForKey:(NSString*)key {
    return [[NSUserDefaults standardUserDefaults] stringForKey:key];
}

+(BOOL)booleanValueForKey:(NSString*)key {
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

+(NSArray*)arrayValueForKey:(NSString*)key {
    return [[NSUserDefaults standardUserDefaults] arrayForKey:key];
}

+(NSMutableArray*)mutableArrayValueForKey:(NSString*)key {
    return [[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:key];
}

@end

@implementation NSUserDefaults (Testing)

+(NSUserDefaults*)temporaryDefaults {
    return (id) [[NWSettingsWrapper alloc] init];
}


@end
