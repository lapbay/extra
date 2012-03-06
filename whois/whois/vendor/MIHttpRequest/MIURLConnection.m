#import <objc/runtime.h>

#import "MIURLConnection.h"

typedef void (^MICallbackBlock)(NSURLResponse*, NSData*, NSError*);

@interface MIURLConnectionHandler : NSObject <NSURLConnectionDelegate>

@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) MICallbackBlock handler;
@property (strong, nonatomic) NSOperationQueue *queue;
@property (strong, nonatomic) NSMutableData *data;
@property (strong, nonatomic) NSURLResponse *response;

@end
//
//  MIURLConnection.m
//  requester
//
//  Created by Wu Chang on 12-2-27.
//  Copyright (c) 2012年 Milan. All rights reserved.
//

@implementation MIURLConnectionHandler
@synthesize connection, handler = _handler, queue = _queue, data = _data, response = _response;

- (void)performRequest:(NSURLRequest *)request queue:(NSOperationQueue *)queue completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler {
    self.handler = handler;
    
    if (!queue) queue = [NSOperationQueue mainQueue];
    self.queue = queue;
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    MICallbackBlock handler = self.handler;
    self.handler = nil;
    
    NSURLResponse *response = self.response;
    [self.queue addOperationWithBlock:^{
        handler(response, nil, error);
    }];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if (response.expectedContentLength > 0) {
        self.data = [NSMutableData dataWithCapacity:response.expectedContentLength];
    } else {
        self.data = [NSMutableData data];
    }
    
    self.response = response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    MICallbackBlock handler = self.handler;
    self.handler = nil;
    
    NSURLResponse *response = self.response;
    NSData *data = [self.data copy];
    
    [self.queue addOperationWithBlock:^{
        handler(response, data, nil);
    }];
}


- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    NSCachedURLResponse *newCachedResponse = cachedResponse;
    if ([[[[cachedResponse response] URL] scheme] isEqual:@"https"]) {
        newCachedResponse = nil;
    } else {
        NSDictionary *newUserInfo;
        newUserInfo = [NSDictionary dictionaryWithObject:[[NSDate date] addTimeInterval:86400] forKey:@"Cached Date"];
        newCachedResponse = [[NSCachedURLResponse alloc]
                             initWithResponse:[cachedResponse response]
                             data:[cachedResponse data]
                             userInfo:newUserInfo
                             storagePolicy:[cachedResponse storagePolicy]];
    }
    return newCachedResponse;
}

@end

@implementation MIURLConnection

+ (void)sendAsynchronousRequest:(NSURLRequest *)request queue:(NSOperationQueue *)queue completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler {
    if (class_getClassMethod([NSURLConnection class], @selector(sendAsynchronousRequest:queue:completionHandler:)) != NULL) {
        [super sendAsynchronousRequest:request queue:queue completionHandler:handler];
    } else {
        MIURLConnectionHandler *connectionHandler = [[MIURLConnectionHandler alloc] init];
        [connectionHandler performRequest:request queue:queue completionHandler:handler];
    }
}

@end
