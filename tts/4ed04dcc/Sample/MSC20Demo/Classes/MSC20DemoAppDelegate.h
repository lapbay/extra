//
//  MSC20DemoAppDelegate.h
//  MSC20Demo
//
//  Created by yangchen on 11-3-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoiceViewController.h"
#import "RootViewController.h"
#import "VoiceViewController.h"

@interface MSC20DemoAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
	RootViewController *_rootViewController;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

