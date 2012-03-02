//
//  api.m
//  milan
//
//  Created by Wu Chang on 11-10-5.
//  Copyright 2011年 Unique. All rights reserved.
//

#import "api.h"

@implementation API : NSObject

@synthesize delegate = _delegate, binder, APIArgs, tag;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        binder = [[APIBinder alloc] init];
        APIArgs = [[[[dataSharer sharedManager].storage _read] objectForKey: @"settings"] objectForKey: @"api"];
        tag = 123456789;
    }
    return self;
}

- (NSMutableDictionary *) searchDomain:(NSDictionary *)post {
    NSString *url;
    if ([[APIArgs objectForKey:@"text"] boolValue]) {
        url = [NSString stringWithFormat:@"%@/%@",
                         [APIArgs objectForKey: @"host"],
                         [APIArgs objectForKey: @"whois_text"]
                         ];
        NSMutableDictionary *iParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        url, @"url",
                                        post, @"post",
                                        nil];
        //NSMutableDictionary *ticket = [self postJsonAPI:iParams];
        ASIFormDataRequest *request = [binder postRequest:iParams];
        NSString *body = [request responseString];
        return [NSMutableDictionary dictionaryWithObjectsAndKeys:body, @"body", nil];
    }else {
        url = [NSString stringWithFormat:@"%@/%@",
                         [APIArgs objectForKey: @"host"],
                         [APIArgs objectForKey: @"whois"]
                         ];
        NSMutableDictionary *iParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        url, @"url",
                                        post, @"post",
                                        nil];
        ASIFormDataRequest *request = [binder postRequest:iParams];
        NSData *body = [request responseData];
        return [NSMutableDictionary dictionaryWithObjectsAndKeys:body, @"body", nil];
    }
}

- (void) searchDomainAsync:(NSDictionary *)post {
    NSString *url;
    if ([[APIArgs objectForKey:@"text"] boolValue]) {
        url = [NSString stringWithFormat:@"%@/%@&d=%@",
               [APIArgs objectForKey: @"host"],
               [APIArgs objectForKey: @"whois_text"],
               [post objectForKey:@"domain"]
               ];
        NSMutableDictionary *iParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        url, @"url",
                                        post, @"post",
                                        nil];
        //NSMutableDictionary *ticket = [self postJsonAPI:iParams];
        [self asyncJsonAPI:iParams];
    }else {
        url = [NSString stringWithFormat:@"%@/%@?d=%@",
               [APIArgs objectForKey: @"host"],
               [APIArgs objectForKey: @"whois"],
               [post objectForKey:@"domain"]
               ];
        NSMutableDictionary *iParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        url, @"url",
                                        post, @"post",
                                        nil];
        [self asyncJsonAPI:iParams];
    }
}

- (NSMutableDictionary *) listTicket{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",
                     [APIArgs objectForKey: @"host"],
                     [APIArgs objectForKey: @"ticket"],
                     [APIArgs objectForKey: @"list"]];
    NSMutableDictionary *iParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
     url, @"url",nil];
    NSMutableDictionary *list = [self syncJsonAPI:iParams];
    return list;
}

- (UIImage *) getImage:(NSString *)URL{
    //NSString *url = [NSString stringWithFormat:@"%@",URL];
    NSDictionary *iParams = [NSDictionary dictionaryWithObjectsAndKeys:
                             URL, @"url",nil];
    APIRequest *request = [binder syncRequest:iParams];
    if ([request error]) {
        return [UIImage imageNamed:@"error.png"];
    }else{
        UIImage *theImage = [UIImage imageWithData:[request responseData]];  
        return theImage;
    }
}
- (void) imageQueue:(NSString *)URL{
    NSDictionary *iParams = [NSDictionary dictionaryWithObjectsAndKeys:
                             URL, @"url",nil];
    [self queueJsonAPI:iParams];
}

- (id) postJsonAPI:(NSDictionary *)args{
    ASIFormDataRequest *request = [binder postRequest:args];
    if ([request error]) {
        /*NSDictionary *res = [NSDictionary dictionaryWithObjectsAndKeys:
         [request error], @"errorMessage", [NSNumber numberWithInt:500], @"errorCode",
         nil]*/;
        NSArray *res = [NSArray arrayWithObjects:@"error",nil];
        return res;
    }else{
        NSString *body = [request responseString];
        @try {
            //NSMutableArray *json = [NSMutableArray arrayWithArray:[body JSONValue]];
            NSMutableDictionary *json = [NSMutableDictionary dictionaryWithDictionary:[body JSONValue]];
            return json;
        }
        @catch (NSException *exception) {
            NSMutableString *json = [NSMutableString stringWithString:body];
            return json;
        }
    }
}

- (id) syncJsonAPI:(NSDictionary *)args{
    APIRequest *request = [binder syncRequest:args];
    if ([request error]) {
        /*NSDictionary *res = [NSDictionary dictionaryWithObjectsAndKeys:
                [request error], @"errorMessage", [NSNumber numberWithInt:500], @"errorCode",
                nil]*/;
        NSArray *res = [NSArray arrayWithObjects:@"error",nil];
        return res;
    }else{
        NSString *body = [request responseString];
        @try {
            //NSMutableArray *json = [NSMutableArray arrayWithArray:[body JSONValue]];
            NSMutableDictionary *json = [NSMutableDictionary dictionaryWithDictionary:[body JSONValue]];
            return json;
        }
        @catch (NSException *exception) {
            NSMutableString *json = [NSMutableString stringWithString:body];
            return json;
        }
    }
}

- (void) asyncJsonAPI:(NSDictionary *)args{
    if (self.delegate) {
        binder.realDelegate = self.delegate;
    }
    binder.delegate = self;
    [binder asyncRequest:args];
}

- (void) queueJsonAPI:(NSDictionary *)args{
    if (self.delegate) {
        binder.realDelegate = self.delegate;
    }
    binder.tag =self.tag;
    binder.delegate = self;
    [binder queueRequest:args];
}

-(void) requestFinished:(APIRequest *)request{
    if ([[APIArgs objectForKey:@"text"] boolValue]) {
        NSString *body = [request responseString];
        if (request.realDelegate) {
            [request.realDelegate performSelector:@selector(requestFinished:) withObject:body];
        }else{
            NSLog(@"%@",@"finished in api");
        }
    }else {
        NSData *body = [request responseData];
        if (request.realDelegate) {
            [request.realDelegate performSelector:@selector(requestFinished:) withObject:body];
        }else{
            NSLog(@"%@",@"finished in api");
        }
    }
    //NSArray *json = [body JSONValue];
}

- (void)requestDone:(APIRequest *)request
{
    UIImage *theImage = [UIImage imageWithData:[request responseData]];
    if (request.realDelegate) {
        [request.realDelegate performSelector:@selector(requestDone:atViewTag:) withObject:theImage withObject:[NSNumber numberWithInt: request.tag]];
    }else{
        NSLog(@"%@",@"done in api");
    }
}

- (void)requestFailed:(APIRequest *)request
{
    if (request.realDelegate) {
        [request.realDelegate performSelector:@selector(requestFailed:) withObject:request.error.localizedDescription];
    }else{
        NSLog(@"%@",@"finished in api");
    }
}


@end
