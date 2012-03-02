//
//  apiProtocol.h
//  milan
//
//  Created by Wu Chang on 11-10-5.
//  Copyright 2011年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIRequest.h"

@protocol apiProtocol

@required
-(void) requestFinished:(APIRequest *)request;

@optional
-(void) requestDone;
-(void) requestFailed;

@end
