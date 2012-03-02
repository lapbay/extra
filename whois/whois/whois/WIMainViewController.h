//
//  WIMainViewController.h
//  whois
//
//  Created by Wu Chang on 12-2-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MBProgressHUD.h"
#import "api.h"
#import "MobClick.h"

@interface WIMainViewController : UIViewController <UISearchBarDelegate, MBProgressHUDDelegate, apiProtocol,UIAlertViewDelegate>

//@property (retain, nonatomic) UIImageView *imageView;
@property (retain, nonatomic) API *api;
@property (retain, nonatomic) UISearchBar *searchBar;
@property (retain, nonatomic) UITextView *resultView;
@property (retain, nonatomic) UIWebView *webView;
@property (retain, nonatomic) UIImageView *imageView;
@property (retain, nonatomic) UIButton *infoButton;
@property (retain, nonatomic) MBProgressHUD *hud;
@property (assign, nonatomic) BOOL pureText;

- (IBAction) taped:(UIGestureRecognizer *) sender;
- (IBAction)showInfo:(id)sender;
- (void)doSearch;
- (void)requestFinished:(id)body;
- (void)requestFailed:(NSString *)errorMsg;

@end
