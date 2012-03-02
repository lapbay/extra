//
//  DPAppDelegate.m
//  dingpiaojingling
//
//  Created by Wu Chang on 11-12-11.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "DPAppDelegate.h"

#import "DPMasterViewController.h"

@implementation DPAppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    dataSharer *sharer = [dataSharer sharedManager];
    [sharer initialData];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    DPMasterViewController *masterViewController = [[DPMasterViewController alloc] initWithNibName:@"DPMasterViewController" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    NSMutableDictionary *_storages = [[dataSharer sharedManager].storage _read];
    if (![_storages objectForKey:@"token"]) {
        NSLog(@"Registering for push notifications...");
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeAlert |
                                                                                UIRemoteNotificationTypeBadge |
                                                                                UIRemoteNotificationTypeSound)];
        application.applicationIconBadgeNumber = 0;
    }else{
        NSLog(@"%@",[_storages objectForKey:@"token"]);
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logAllNotify:) name:nil object:nil];
    return YES;
}
- (void)logAllNotify:(NSNotification *)n{
    //NSLog(@"%@ %@",NSStringFromSelector(_cmd), n);
}
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    NSMutableString *token = [NSMutableString stringWithFormat:@"%@",devToken];
    [token replaceOccurrencesOfString:@"<" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [token length])];    
    [token replaceOccurrencesOfString:@">" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [token length])];    
    [token replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [token length])];    
    NSMutableDictionary *_storages = [[dataSharer sharedManager].storage _read];
    [_storages setObject:token forKey:@"token"];
    [[dataSharer sharedManager].storage _write:_storages];
    
    //NSLog(@"%@",_storages);
    //self.registered = YES;
    //[self sendProviderDeviceToken:devTokenBytes]; // custom method
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"Error in registration. Error: %@", err);
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
