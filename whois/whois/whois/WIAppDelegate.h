//
//  WIAppDelegate.h
//  whois
//
//  Created by Wu Chang on 12-2-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dataSharer.h"
#import "MobClick.h"

@class WIMainViewController;

@interface WIAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) WIMainViewController *mainViewController;

@end
