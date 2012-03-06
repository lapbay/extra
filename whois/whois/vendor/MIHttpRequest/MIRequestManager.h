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
#import "SBJson.h"

/*@protocol MIRequestManagerDelegate <NSObject>

@required
- (void)connectionDidFinishLoading:(NSDictionary *) response;

@optional
- (void)connection:(NSURLConnection *) connection didFailWithError:(NSError *)error;
@end*/

@interface MIRequestManager : NSOperationQueue

+ (MIRequestManager *)requestManager;
+ (id)allocWithZone:(NSZone *)zone;
- (id)copyWithZone:(NSZone *)zone;
- (id) jsonToObject:(NSData *) json;
- (BOOL) checkCache:(NSString *)key;
- (void) cacheResponse:(NSString *)key withIndex:(NSNumber *)index isJson: (BOOL) jsJson;
- (void) imageLoader:(NSString *) imageURL withIndex: (NSString *)index withDelegate: (NSObject <MIRequestDelegate> *) delegate;
- (void) imageCacher:(NSString *) imageURL withIndex: (NSString *)index withDelegate: (NSObject <MIRequestDelegate> *) delegate;

//@property (strong, nonatomic) id <MIRequestDelegate> delegate;
@property (assign, nonatomic) BOOL useCache;


@property (assign, nonatomic) NSTimeInterval timeout;
@property (strong, nonatomic) NSMutableData *receivedData;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *method;
@property (strong, nonatomic) NSMutableData *postBody;
@property (strong, nonatomic) NSString *getURL;
@property (strong, nonatomic) NSMutableDictionary *getParams;
@property (strong, nonatomic) NSMutableDictionary *postStrings;
@property (strong, nonatomic) NSMutableDictionary *postDatas;
@property (strong, nonatomic) NSMutableDictionary *headers;
@property (strong, nonatomic) NSMutableURLRequest *_requester;
- (NSMutableURLRequest *) buildRequest;
- (void)addRequestHeader:(NSString *)header value:(NSString *)value;
- (NSString *) objectToString:(id) object;
- (NSString *) buildPostBody;
- (void) buildMultipartFormDataPostBody;
- (NSString *) urlEncode: (NSString *) string;

@end
