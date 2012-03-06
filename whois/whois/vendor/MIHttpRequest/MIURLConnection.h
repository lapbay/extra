//
//  MIURLConnection.h
//  requester
//
//  Created by Wu Chang on 12-2-27.
//  Copyright (c) 2012年 Milan. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface MIURLConnection : NSURLConnection

+ (void)sendAsynchronousRequest:(NSURLRequest *)request queue:(NSOperationQueue *)queue completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler;

@end
