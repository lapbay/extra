//
//  singleInstance.h
//  milan
//
//  Created by Wu Chang on 11-9-20.
//  Copyright 2011年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "storage.h"

@interface dataSharer : NSObject {
    Storage *storage;
    NSArray* viewControllers;
    NSDictionary *dict;
}

+(dataSharer*)sharedManager;
+ (id)allocWithZone:(NSZone *)zone;
- (id)copyWithZone:(NSZone *)zone;
- (id)retain;
- (NSUInteger)retainCount;
- (void)release;
- (id)autorelease;

@property (retain, nonatomic) Storage *storage;
@property (retain, nonatomic) NSArray *viewControllers;
@property (retain, nonatomic) NSDictionary *dict;

-(void)hello;
-(void) initialData;

@end