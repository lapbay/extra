//
//  binder.h
//  milan
//
//  Created by Wu Chang on 11-9-15.
//  Copyright 2011年 Unique. All rights reserved.
//

#import "APIRequest.h"
#import "ASIFormDataRequest.h"
#import "ASIDownloadCache.h"
#import "dataSharer.h"

@interface APIBinder : NSObject {
}

@property (atomic) int tag;
@property (retain, nonatomic) NSOperationQueue *queue;
@property (retain, nonatomic) id delegate;
@property (retain, nonatomic) id realDelegate;

- (ASIFormDataRequest *) postRequest: (NSDictionary *) args;
- (APIRequest *) syncRequest: (NSDictionary *) args;

- (void) asyncRequest:(NSDictionary *)args;
- (void) requestFinished: (APIRequest *)request;

- (void) queueRequest:(NSDictionary *)args;
- (void) requestDone: (APIRequest *)request;
- (void) requestFailed: (APIRequest *)request;

@end
