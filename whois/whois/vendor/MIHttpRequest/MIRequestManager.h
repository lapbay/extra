//
//  MIRequestManager.h
//  requester
//
//  Created by Wu Chang on 12-2-29.
//  Copyright (c) 2012年 Milan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIRequest.h"

@protocol MIRequestManagerDelegate <NSObject>

@required
- (void)connectionDidFinishLoading:(NSMutableDictionary *) response;

@optional
- (void)connection:(NSURLConnection *) connection didFailWithError:(NSError *)error;
@end

@interface MIRequestManager : NSOperationQueue <MIRequestDelegate>

+ (MIRequestManager *)requestManager;
+ (id)allocWithZone:(NSZone *)zone;
- (id)copyWithZone:(NSZone *)zone;
- (id) jsonToObject:(NSData *) json;
- (MIRequest *) buildSampleAPI;
- (void) asyncAPI;
- (NSData *) syncAPI;

@property (assign, nonatomic) id <MIRequestManagerDelegate> delegate;
//@property (strong, nonatomic) id delegate;
@property (assign, nonatomic) BOOL json;

@end
