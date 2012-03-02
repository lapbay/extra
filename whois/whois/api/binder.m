//
//  binder.m
//  milan
//
//  Created by Wu Chang on 11-9-15.
//  Copyright 2011年 Unique. All rights reserved.
//

#import "binder.h"

@implementation APIBinder
@synthesize delegate, realDelegate = _delegate, queue, tag;

- (id)init
{
    self = [super init];
    if (self) {
    }

    return self;
}

- (ASIFormDataRequest *) postRequest:(NSDictionary *)args{
    NSURL *url = [NSURL URLWithString: [args objectForKey:@"url"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.timeOutSeconds = 20.0;
    [request addRequestHeader:@"Referer" value:@"http://tapray.com/"];
    if ([args objectForKey:@"post"]) {
        [request setPostValue:@"sdf" forKey:@"test"];
        NSDictionary *post = [args objectForKey:@"post"];
        for (NSString *key in post) {
            [request setPostValue:[post objectForKey:key] forKey:key];
        }
    }
    [request startSynchronous];
    if ([request error]) {
        ALog (@"%@,%@",url,[request error]);
    }else{
        //NSString *response = [request responseString];
        //NSLog(@"synchronous");
    }
    return request;
}

- (APIRequest *) syncRequest:(NSDictionary *)args{
    NSURL *url = [NSURL URLWithString: [args objectForKey:@"url"]];
    APIRequest *request = [APIRequest requestWithURL:url];
    request.timeOutSeconds = 20.0;
    [request addRequestHeader:@"Referer" value:@"http://tapray.com/"];
    [request startSynchronous];
    if ([request error]) {
        ALog (@"%@,%@",url,[request error]);
    }else{
        //NSString *response = [request responseString];
        //NSLog(@"synchronous");
    }
    return request;
}

- (void) asyncRequest:(NSDictionary *)args{
    NSURL *url = [NSURL URLWithString: [args objectForKey:@"url"]];
    APIRequest *request = [APIRequest requestWithURL:url];
    request.timeOutSeconds = 20.0;
    [request addRequestHeader:@"Referer" value:@"http://tapray.com/"];
    if (self.realDelegate) {
        request.realDelegate = self.realDelegate;
    }
    request.delegate = self.delegate;
    [request setDidFinishSelector:@selector(requestFinished:)];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setResponseEncoding:NSUTF8StringEncoding];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/json; charset=UTF-8;"];
    [request startAsynchronous];
}

- (void)requestFinished:(APIRequest *)request{
    if (request.error) {
        NSLog (@"asynchronous request error in binder");
    }else{
        NSLog (@"asynchronous request finished in binder");
    }
}

- (void) queueRequest:(NSDictionary *) args{
    if (!self.queue) {
        self.queue = [[NSOperationQueue alloc] init];
    }
    NSString *url = [args objectForKey:@"url"];
    APIRequest *request = [APIRequest requestWithURL:[NSURL URLWithString:url]];
    [request addRequestHeader:@"Referer" value:@"http://tapray.com/"];
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    [request setCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    if (self.realDelegate) {
        request.realDelegate = self.realDelegate;
    }
    if (self.tag != 123456789) {
        request.tag = self.tag;
    }
    request.delegate = self.delegate;
    [request setDidFinishSelector:@selector(requestDone:)];
    [request setDidFailSelector:@selector(requestFailed:)];
    [[self queue] addOperation:request]; //queue is an NSOperationQueue
}

- (void)requestDone:(APIRequest *)request
{
    NSLog (@"queue request finished in binder");
}

- (void)requestFailed:(APIRequest *)request
{
    NSLog (@"queue request failed in binder");
}

@end
