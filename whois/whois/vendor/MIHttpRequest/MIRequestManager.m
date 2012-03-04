//
//  MIRequestManager.m
//  requester
//
//  Created by Wu Chang on 12-2-29.
//  Copyright (c) 2012年 Milan. All rights reserved.
//

#import "MIRequestManager.h"

@implementation MIRequestManager
@synthesize delegate, json, useCache;

static MIRequestManager *sharedRequestManager = nil;

+ (MIRequestManager *) requestManager
{
    if (sharedRequestManager == nil) {
        sharedRequestManager = [[super allocWithZone:NULL] init];
    }
    return sharedRequestManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self requestManager];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id) jsonToObject:(NSData *) jsonData{
    NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return [string JSONValue];
}

- (BOOL) checkCache:(NSString *)key {
    MICache *cache = [MICache currentCache];
    NSString *hash = [NSString stringWithFormat: @"%i",[key hash]];
    if ([cache hasCacheForKey:hash]) {
        return YES;
    }else {
        return NO;
    }
}

- (BOOL) cacheResponse:(NSString *)key withIndex:(NSNumber *)index{
    MICache *cache = [MICache currentCache];
    NSString *hash = [NSString stringWithFormat: @"%i",[key hash]];
    if ([cache hasCacheForKey:hash]) {
        NSData *data = [NSMutableData dataWithData: [cache dataForKey:hash]];
        NSMutableDictionary *response;
        if (self.json) {
            response = [NSMutableDictionary dictionaryWithDictionary: [data JSONValue]];
        }else {
            response = [NSMutableDictionary dictionaryWithObjectsAndKeys:data, @"data", nil];
        }
        [self connectionDidFinishLoading:response withIndex:index];
        NSLog(@"%@",@"micached");
        return YES;
    }else {
        return NO;
    }
}

- (void)connectionDidFinishLoading:(NSMutableDictionary *) response withIndex: (NSNumber *) index{
    NSLog(@"%@",index);
    //[self performSelectorOnMainThread:@selector(refreshView:) withObject:[response objectForKey:@"data"] waitUntilDone:[NSThread isMainThread]];
    [self.delegate performSelector:@selector(connectionDidFinishLoading:withIndex:) withObject:response withObject:index];
}

- (void)connection:(NSURLConnection *) connection didFailWithError:(NSError *)error{
    NSLog(@"Connection failed! Error - %@ %@",[error localizedDescription],[[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    //[self performSelectorOnMainThread:@selector(refreshViewWithError:) withObject:error waitUntilDone:[NSThread isMainThread]];
    [self.delegate performSelector:@selector(connection:didFailWithError:) withObject:connection withObject:error];
}

- (MIRequest *) miSampleAPI {
    NSString* docPath = [NSHomeDirectory() stringByAppendingPathComponent: @"Documents"]; 
    NSString* path = [NSString stringWithFormat: @"%@/%@", docPath, @"360.png"];
    NSDictionary *pic = [NSDictionary dictionaryWithObjectsAndKeys:@"data", @"key",@"360.png",@"fileName",@"image/png",@"contentType",path,@"data", nil];

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

- (void) miAsyncAPI {
    MIRequest *request = self.miSampleAPI;
    if (self.useCache && [self checkCache:request.url]) {
        [self cacheResponse:request.url withIndex:[NSNumber numberWithInt:0]];
    }else {
        [self addOperation:request];
    };
}

- (NSData *) miSyncAPI {
    MIRequest *request = self.miSampleAPI;
    MICache *cache = [MICache currentCache];
    NSString *hash = [NSString stringWithFormat: @"%i",[request.url hash]];
    NSData *data;
    if (self.useCache && [cache hasCacheForKey:hash]) {
        data = [cache dataForKey:hash];
    }else {
        data = [request syncRequest];
    };
    //NSLog(@"in manager %@", [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding]);
    return data;
}

@end
