//
//  DPSettingsViewController.h
//  dingpiaojingling
//
//  Created by Wu Chang on 11-12-11.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "api.h"
#import "UIHudViewController.h"
#import "UIEditView.h"

@interface DPSettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIEditViewDelegate> {
    UITableView *_tableView;
}

@property (retain, nonatomic) IBOutlet UITableView *_tableView;
@property (retain, nonatomic) NSMutableDictionary *savedSettings;
@property (retain, nonatomic) NSArray *settingsOrder;
@property (retain, nonatomic) NSMutableDictionary *editing;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
