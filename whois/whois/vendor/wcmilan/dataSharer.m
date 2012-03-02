//
//  singleInstance.m
//  milan
//
//  Created by Wu Chang on 11-9-20.
//  Copyright 2011年 Unique. All rights reserved.
//

#import "dataSharer.h"

@implementation dataSharer
@synthesize storage,viewControllers,dict;

static dataSharer *sharedGizmoManager = nil;
+ (dataSharer*)sharedManager
{
    if (sharedGizmoManager == nil) {
        sharedGizmoManager = [[super allocWithZone:NULL] init];
    }
    return sharedGizmoManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedManager] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}

-(void)hello
{
    NSLog(@"Hello World");
}

-(void) initialData {
    Storage *store = [[Storage alloc] init];
    self.storage = store;
}

@end