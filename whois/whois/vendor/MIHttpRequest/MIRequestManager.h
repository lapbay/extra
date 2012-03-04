//
//  MIRequestManager.h
//  requester
//
//  Created by Wu Chang on 12-2-29.
//  Copyright (c) 2012年 Milan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIRequest.h"
#import "MICache.h"

@protocol MIRequestManagerDelegate <NSObject>

@required
- (void)connectionDidFinishLoading:(NSMutableDictionary *) response withIndex: (NSNumber *) index;

@optional
- (void)connection:(NSURLConnection *) connection didFailWithError:(NSError *)error;
@end

@interface MIRequestManager : NSOperationQueue <MIRequestDelegate>

+ (MIRequestManager *)requestManager;
+ (id)allocWithZone:(NSZone *)zone;
- (id)copyWithZone:(NSZone *)zone;
- (id) jsonToObject:(NSData *) json;
- (BOOL) checkCache:(NSString *)key;
- (BOOL) cacheResponse:(NSString *)key withIndex:(NSNumber *)index;
- (MIRequest *) miSampleAPI;
- (void) miAsyncAPI;
- (NSData *) miSyncAPI;

@property (strong, nonatomic) id <MIRequestManagerDelegate> delegate;
//@property (strong, nonatomic) id delegate;
@property (assign, nonatomic) BOOL json;
@property (assign, nonatomic) BOOL useCache;

@end
