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

- (NSMutableDictionary *) createTicket:(NSDictionary *)post {
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",
                     [APIArgs objectForKey: @"host"],
                     [APIArgs objectForKey: @"ticket"],
                     [APIArgs objectForKey: @"create"]];
    NSMutableDictionary *iParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    url, @"url",
                                    post, @"post",
                                    nil];
    NSMutableDictionary *ticket = [self postJsonAPI:iParams];
    return ticket;
}

- (NSMutableDictionary *) destroyTicket:(NSDictionary *)post {
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",
                     [APIArgs objectForKey: @"host"],
                     [APIArgs objectForKey: @"ticket"],
                     [APIArgs objectForKey: @"destroy"]];
    NSMutableDictionary *iParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    url, @"url",
                                    post, @"post",
                                    nil];
    NSMutableDictionary *ticket = [self postJsonAPI:iParams];
    return ticket;
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
    NSString *body = [request responseString];
    NSArray *json = [body JSONValue];
    if (request.realDelegate) {
        [request.realDelegate performSelector:@selector(requestFinished:) withObject:json];
    }else{
        NSLog(@"%@",@"finished in api");
    }
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
    /*if ([request.realDelegate responseToSelector:@selector(requestFailed:)]) {
        [request.realDelegate performSelector:@selector(requestFailed:) withObject:[UIImage imageNamed:@"error.png"]];
    }else{
        NSLog(@"%@",@"failed in api");
    }*/
    NSLog(@"%@",request.error);
}


@end
