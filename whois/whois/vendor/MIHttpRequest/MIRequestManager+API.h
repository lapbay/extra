//
//  MIRequestManager+API.h
//  requester
//
//  Created by Wu Chang on 12-3-1.
//  Copyright (c) 2012年 Milan. All rights reserved.
//

#import "MIRequestManager.h"
#import "SBJson.h"

@interface MIRequestManager (sampleAPI)

- (void) sampleAPI:(NSString *) url withIndex: (NSString *)index withDelegate: (NSObject <MIRequestDelegate> *) delegate;

@end

@interface MIRequestManager (appAPI)
- (void) whoisAPI:(NSString *) url withIndex: (NSString *)index withDelegate: (NSObject <MIRequestDelegate> *) delegate;

@end