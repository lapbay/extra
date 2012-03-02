//
//  storage.m
//  milan
//
//  Created by Wu Chang on 11-9-21.
//  Copyright 2011年 Unique. All rights reserved.
//

#import "storage.h"

@implementation Storage
@synthesize all, settings, storages;

- (id)init
{
    self = [super init];
    if (self) {
        self.all = [self _read];
        self.settings = [NSMutableDictionary dictionaryWithDictionary: [self.all objectForKey:@"settings"]];
        self.storages = [NSMutableArray arrayWithArray: [self.all objectForKey:@"storages"]];
    }
    return self;
}

- (NSMutableDictionary *)_read{
    //get the plist file from bundle
    NSUserDefaults *_storage = [NSUserDefaults standardUserDefaults];
    if ([_storage objectForKey:@"defaults"]) {
        self.all = [NSMutableDictionary dictionaryWithDictionary: [_storage objectForKey:@"defaults"]];
    }else{
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"defaults" ofType:@"plist"]; 
        NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
        [_storage registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:dict, @"defaults", nil]];
        self.all = [NSMutableDictionary dictionaryWithDictionary: [_storage objectForKey:@"defaults"]];
    }
    return self.all;
}

- (void) _write: (NSDictionary *)userDefaults{
    NSUserDefaults *_defaults = [NSUserDefaults standardUserDefaults];
    [_defaults setObject:userDefaults forKey:@"defaults"];
    [_defaults synchronize];
    self.all = [self _read];
    self.settings = [NSMutableDictionary dictionaryWithDictionary: [self.all objectForKey:@"settings"]];
    self.storages = [NSMutableArray arrayWithArray: [self.all objectForKey:@"storages"]];
}

@end
