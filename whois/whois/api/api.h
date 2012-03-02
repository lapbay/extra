//
//  api.h
//  milan
//
//  Created by Wu Chang on 11-10-5.
//  Copyright 2011年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "apiProtocol.h"
#import "dataSharer.h"
#import "binder.h"
#import "SBJson.h"
#import "cache.h"

@interface API : NSObject <apiProtocol> {
}

@property (atomic) int tag;
@property (retain, nonatomic) id delegate;
@property (retain, nonatomic) APIBinder *binder;
@property (retain, nonatomic) NSDictionary *APIArgs;

- (NSMutableDictionary *) searchDomain:(NSDictionary *)post;
- (void) searchDomainAsync:(NSDictionary *)post;
- (NSMutableDictionary *) listTicket;

- (UIImage *) getImage:(NSString *)URL;
- (void) imageQueue:(NSString *)URL;
- (id) postJsonAPI:(NSDictionary *)args;
- (id) syncJsonAPI: (NSDictionary *) args;
- (void) asyncJsonAPI: (NSDictionary *) args;
- (void) queueJsonAPI: (NSDictionary *) args;

@end
