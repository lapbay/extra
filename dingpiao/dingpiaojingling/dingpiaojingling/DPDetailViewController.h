//
//  DPDetailViewController.h
//  dingpiaojingling
//
//  Created by Wu Chang on 11-12-11.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "api.h"
#import "UIHudViewController.h"

@protocol detailProtocol

@required
@property (strong, nonatomic) NSMutableDictionary *onTicket;
@optional
-(void) hello;
@end


@interface DPDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
}

@property (retain, nonatomic) id <detailProtocol> delegate;
@property (retain, nonatomic) IBOutlet UITableView *_tableView;
@property (retain, nonatomic) NSMutableDictionary *savedTickets;
@property (retain, nonatomic) NSArray *tickets;
@property (retain, nonatomic) NSMutableDictionary *editing;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

