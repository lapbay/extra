//
//  MIRequestManager+API.m
//  requester
//
//  Created by Wu Chang on 12-3-1.
//  Copyright (c) 2012年 Milan. All rights reserved.
//

#import "MIRequestManager+API.h"

@implementation MIRequestManager (sampleAPI)

- (MIRequest *) buildImageLoader:(NSString *)imageURL {    
    MIRequest *request = [[MIRequest alloc] init];
    request.delegate = self;
    request.useCache = YES;
    request.url = imageURL;
    request.method = @"GET";
    
    request.headers = [NSDictionary dictionaryWithObjectsAndKeys:@"1.0", @"APIVersion", @"gzip,deflate", @"Accept-Encoding", nil];
    request.getParams = [NSDictionary dictionaryWithObjectsAndKeys:@"true", @"test", nil];
    //[request asyncRequest];
    return request;
}

- (void) imageLoader:(NSString *) imageURL withIndex: (NSNumber *)index{
    MIRequest *request = [self buildImageLoader:imageURL];
    request.index = index;
    if ([self checkCache:request.url]) {
        [self cacheResponse:request.url withIndex:index];
    }else {
        [self addOperation:request];
    }
}

- (MIRequest *) buildSampleAPI {
    NSString* docPath = [NSHomeDirectory() stringByAppendingPathComponent: @"Documents"]; 
    NSString* path = [NSString stringWithFormat: @"%@/%@", docPath, @"360.png"];
    NSDictionary *pic = [NSDictionary dictionaryWithObjectsAndKeys:@"data", @"key",@"sample.png",@"fileName",@"image/png",@"contentType",path,@"data", nil];
    
    MIRequest *request = [[MIRequest alloc] init];
    request.delegate = self;
    request.useCache = self.useCache;
    request.url = @"http://pasent.com/foo";
    request.method = @"POST";
    
    request.headers = [NSDictionary dictionaryWithObjectsAndKeys:@"1.0", @"APIVersion", @"gzip,deflate", @"Accept-Encoding", nil];
    request.getParams = [NSDictionary dictionaryWithObjectsAndKeys:@"true", @"text", @"中文", @"key", nil];
    request.postStrings = [NSDictionary dictionaryWithObjectsAndKeys:@"google.com", @"domain", @"baidu.com", @"name", nil];
    request.postDatas = [NSDictionary dictionaryWithObjectsAndKeys:pic, @"data", nil];
    //[request asyncRequest];
    return request;
}

- (void) sampleAPI {
    MIRequest *request = [self buildSampleAPI];
    if (self.useCache && [self checkCache:request.url]) {
        [self cacheResponse:request.url  withIndex:[NSNumber numberWithInt:0]];
    }else {
        [self addOperation:request];
    }
}

@end

@implementation MIRequestManager (appAPI)

- (MIRequest *) buildMyAPI: (NSString *)domain {
    MIRequest *request = [[MIRequest alloc] init];
    request.delegate = self;
    request.useCache = self.useCache;
    request.url = @"http://whois.zunmi.com/mobile.php";
    request.headers = [NSDictionary dictionaryWithObjectsAndKeys:@"pasent.com", @"Referer", @"1.0", @"APIVersion", @"gzip,deflate", @"Accept-Encoding", nil];
    request.getParams = [NSDictionary dictionaryWithObjectsAndKeys:domain, @"d", nil];
    request.postStrings = [NSDictionary dictionaryWithObjectsAndKeys:domain, @"domain", nil];
    request.method = @"POST";
    return request;
    //[request asyncRequest];
}

- (void) whoisAPI: (NSString *)domain {
    self.json = NO;
    MIRequest *request = [self buildMyAPI:domain];
    if (self.useCache && [self checkCache:request.url]) {
        [self cacheResponse:request.url withIndex:[NSNumber numberWithInt:0]];
    }else {
        [self addOperation:request];
    }
}

@end
