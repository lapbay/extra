//
//  DPMasterViewController.h
//  dingpiaojingling
//
//  Created by Wu Chang on 11-12-11.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPDetailViewController.h"
#import "DPAddViewController.h"
#import "DPSettingsViewController.h"
#import "api.h"

@class DPDetailViewController;

@interface DPMasterViewController : UITableViewController <detailProtocol>{
    NSMutableDictionary *itemList;
    NSMutableArray *itemOrder;
}

@property (strong, nonatomic) NSMutableArray *tickets;
//@property (strong, nonatomic) NSMutableDictionary *onTicket;
@property (strong, nonatomic) DPDetailViewController *detailViewController;
@property (strong, nonatomic) DPAddViewController *addViewController;
@property (strong, nonatomic) DPSettingsViewController *settingsViewController;
@property (retain, nonatomic) NSArray *cities;
@property (retain, nonatomic) API *api;

- (void) initData;
- (void) refreshData;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void) AddButtonPressed;
- (void) SettingsButtonPressed;
-(void)longPressOnTable:(UILongPressGestureRecognizer *) gesture;

@end
