//
//  MIRequestManager+API.m
//  requester
//
//  Created by Wu Chang on 12-3-1.
//  Copyright (c) 2012年 Milan. All rights reserved.
//

#import "MIRequestManager+API.h"

@implementation MIRequestManager (sampleAPI)

- (void) sampleAPI:(NSString *) url withIndex: (NSString *)index withDelegate: (NSObject <MIRequestDelegate> *) delegate{
    NSString* docPath = [NSHomeDirectory() stringByAppendingPathComponent: @"Documents"]; 
    NSString* path = [NSString stringWithFormat: @"%@/%@", docPath, @"360.png"];
    NSDictionary *pic = [NSDictionary dictionaryWithObjectsAndKeys:@"data", @"key",@"sample.png",@"fileName",@"image/png",@"contentType",path,@"data", nil];
    
    self.url = @"http://pasent.com/foo";
    self.method = @"POST";
    self.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1.0", @"APIVersion", @"gzip,deflate", @"Accept-Encoding", nil];
    self.getParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"true", @"text", @"中文", @"key", nil];
    self.postStrings = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"google.com", @"domain", @"baidu.com", @"name", nil];
    self.postDatas = [NSMutableDictionary dictionaryWithObjectsAndKeys:pic, @"data", nil];
    self.timeout = 30.0;

    NSMutableURLRequest *request = [self buildRequest];
    [MIRequest sendAsynchronousRequest:request queue:self completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if ([data length] > 0 && error == nil){
             NSLog(@"in manager %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
             NSMutableDictionary *res = [NSMutableDictionary dictionaryWithObjectsAndKeys:data, @"data", index, @"NSIndex", nil];
             [delegate performSelectorOnMainThread:@selector(connectionDidFinishLoading:) withObject:res waitUntilDone:[NSThread isMainThread]];
         }else if ([data length] == 0 && error == nil){
             //[delegate emptyReply];
         }else if (error != nil && error.code == NSURLErrorTimedOut){
             //[delegate timedOut];
             NSLog(@"%@",@"timeout");
         }else if (error != nil){
             //[delegate downloadError:error];
         }
     }];
}

@end

@implementation MIRequestManager (appAPI)


- (void) whoisAPI:(NSString *) url withIndex: (NSString *)index withDelegate: (NSObject <MIRequestDelegate> *) delegate{
    self.url = @"http://whois.zunmi.com/mobile.php";
    self.method = @"GET";
    
    self.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1.0", @"APIVersion", @"gzip,deflate", @"Accept-Encoding", nil];
    self.getParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:index, @"d", nil];
    self.postStrings = [NSMutableDictionary dictionaryWithObjectsAndKeys:index, @"domain", nil];
    self.timeout = 20.0;

    NSMutableURLRequest *request = [self buildRequest];
    [MIRequest sendAsynchronousRequest:request queue:self completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSLog(@"%@",index);
         //NSMutableArray *res = [NSMutableArray arrayWithArray: [data JSONValue]];
         if ([data length] > 0 && error == nil){
             if ([delegate respondsToSelector:@selector(refreshView:)]) {
                 NSMutableDictionary *res = [NSMutableDictionary dictionaryWithObjectsAndKeys:data, @"data", index, @"NSIndex", nil];
                 [delegate performSelectorOnMainThread:@selector(connectionDidFinishLoading:) withObject:res waitUntilDone:[NSThread isMainThread]];
             }
         }else if ([data length] == 0 && error == nil){
             //[delegate emptyReply];
         }else if (error != nil && error.code == NSURLErrorTimedOut){
             //[delegate timedOut];
             NSLog(@"%@",@"timeout");
         }else if (error != nil){
             //[delegate downloadError:error];
         }
     }];
}

@end
