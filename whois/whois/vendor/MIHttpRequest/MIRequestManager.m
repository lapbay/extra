//
//  MIRequestManager.m
//  requester
//
//  Created by Wu Chang on 12-2-29.
//  Copyright (c) 2012年 Milan. All rights reserved.
//

#import "MIRequestManager.h"

@implementation MIRequestManager
@synthesize delegate, json;

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

- (void)connectionDidFinishLoading:(NSMutableDictionary *) response {
    //[self performSelectorOnMainThread:@selector(refreshView:) withObject:[response objectForKey:@"data"] waitUntilDone:[NSThread isMainThread]];
    [self.delegate performSelector:@selector(connectionDidFinishLoading:) withObject:response];
}

- (void)connection:(NSURLConnection *) connection didFailWithError:(NSError *)error{
    NSLog(@"Connection failed! Error - %@ %@",[error localizedDescription],[[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    //[self performSelectorOnMainThread:@selector(refreshViewWithError:) withObject:error waitUntilDone:[NSThread isMainThread]];
    [self.delegate performSelector:@selector(connection:didFailWithError:) withObject:connection withObject:error];
}

- (MIRequest *) buildSampleAPI {
    MIRequest *request = [[MIRequest alloc] init];
    request.delegate = self;
    request.url = @"http://pasent.com/foo";
    //MIRequest *request = [self buildAPI];
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

- (void) asyncAPI {
    MIRequest *request = self.buildSampleAPI;
    //request.
    [self addOperation:request];
}

- (NSData *) syncAPI {
    MIRequest *request = self.buildSampleAPI;
    NSData *data = [request syncRequest];
    //NSLog(@"in manager %@", [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding]);
    return data;
}

@end
