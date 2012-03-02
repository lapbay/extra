//
//  MIRequestManager+API.m
//  requester
//
//  Created by Wu Chang on 12-3-1.
//  Copyright (c) 2012年 Milan. All rights reserved.
//

#import "MIRequestManager+API.h"

@implementation MIRequestManager (baseAPI)

- (MIRequest *) buildAnAPI {
    MIRequest *request = [[MIRequest alloc] init];
    request.delegate = self;
    request.url = @"http://pasent.com/foo";
    request.getParams = [NSDictionary dictionaryWithObjectsAndKeys:@"true", @"text", @"中文", @"key", nil];
    request.postStrings = [NSDictionary dictionaryWithObjectsAndKeys:@"google.com", @"domain", @"baidu.com", @"name", nil];
    NSString* docPath = [NSHomeDirectory() stringByAppendingPathComponent: @"Documents"]; 
    NSString* path = [NSString stringWithFormat: @"%@/%@", docPath, @"360.png"];
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:@"data", @"key",@"360.png",@"fileName",@"image/png",@"contentType",path,@"data", nil];
    request.postDatas = [NSDictionary dictionaryWithObjectsAndKeys:info, @"data", nil];
    request.method = @"POST";
    return request;
    //[request asyncRequest];
}

- (void) sampleAPI {
    self.json = YES;
    MIRequest *request = self.buildAnAPI;
    [self addOperation:request];
}

@end

@implementation MIRequestManager (appAPI)

- (MIRequest *) buildAppAPI {
    MIRequest *request = [[MIRequest alloc] init];
    request.delegate = self;
    request.url = @"http://pasent.com/foo";
    request.getParams = [NSDictionary dictionaryWithObjectsAndKeys:@"true", @"text", @"中文", @"key", nil];
    request.postStrings = [NSDictionary dictionaryWithObjectsAndKeys:@"google.com", @"domain", @"baidu.com", @"name", nil];
    NSString* docPath = [NSHomeDirectory() stringByAppendingPathComponent: @"Documents"]; 
    NSString* path = [NSString stringWithFormat: @"%@/%@", docPath, @"360.png"];
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:@"data", @"key",@"360.png",@"fileName",@"image/png",@"contentType",path,@"data", nil];
    request.postDatas = [NSDictionary dictionaryWithObjectsAndKeys:info, @"data", nil];
    request.method = @"POST";
    return request;
    //[request asyncRequest];
}

- (void) testAPI {
    self.json = YES;
    MIRequest *request = self.buildAppAPI;
    [self addOperation:request];
}

- (MIRequest *) buildMyAPI: (NSString *)domain {
    MIRequest *request = [[MIRequest alloc] init];
    request.delegate = self;
    request.url = @"http://whois.zunmi.com/mobile.php";
    //request.url = @"http://pasent.com/foo";
    request.getParams = [NSDictionary dictionaryWithObjectsAndKeys:domain, @"d", nil];
    request.postStrings = [NSDictionary dictionaryWithObjectsAndKeys:domain, @"domain", nil];
    request.method = @"POST";
    return request;
    //[request asyncRequest];
}
- (void) whoisAPI: (NSString *)domain {
    self.json = NO;
    MIRequest *request = [self buildMyAPI:domain];
    [self addOperation:request];
}

@end
