//
//  MIRequestManager+API.h
//  requester
//
//  Created by Wu Chang on 12-3-1.
//  Copyright (c) 2012年 Milan. All rights reserved.
//

#import "MIRequestManager.h"
#import "SBJson.h"

@interface MIRequestManager (baseAPI)

- (void) sampleAPI;

@end

@interface MIRequestManager (appAPI)
- (void) testAPI;
- (MIRequest *) buildMyAPI: (NSString *)domain;
- (void) whoisAPI: (NSString *)domain;

@end