//
//  MIRequest.h
//  requester
//
//  Created by Wu Chang on 12-2-27.
//  Copyright (c) 2012年 Milan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIURLConnection.h"
#import "SBJson.h"

@protocol MIRequestDelegate <NSObject>

@required
- (void)connectionDidFinishLoading:(NSMutableDictionary *) response;

@optional
- (void)connection:(NSURLConnection *) connection didFailWithError:(NSError *)error;

@end


@interface MIRequest : MIURLConnection <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (strong, nonatomic) id <MIRequestDelegate> delegate;

@property (strong, nonatomic) NSNumber *index;
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
- (void) asyncRequest;

- (void)addRequestHeader:(NSString *)header value:(NSString *)value;
- (NSString *) objectToString:(id) object;
- (NSString *) buildPostBody;
- (void) buildMultipartFormDataPostBody;
- (NSString *) urlEncode: (NSString *) string;
-(void)handleTimer:(NSTimer*)timer;

@end
