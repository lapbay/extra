//
//  storage.h
//  milan
//
//  Created by Wu Chang on 11-9-21.
//  Copyright 2011年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Storage : NSObject{
    NSMutableDictionary *all;
    NSMutableDictionary *settings;
    NSMutableArray *storages;
}

@property (retain, nonatomic) NSMutableDictionary *all;
@property (retain, nonatomic) NSMutableDictionary *settings;
@property (retain, nonatomic) NSMutableArray *storages;

- (NSMutableDictionary *) _read;
- (void) _write: (NSDictionary *)data;

@end
