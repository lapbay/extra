//
//  DPAddViewController.h
//  dingpiaojingling
//
//  Created by Wu Chang on 11-12-11.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "api.h"
#import "UIHudViewController.h"

@interface DPAddViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
}
@property (strong, nonatomic) IBOutlet UIActionSheet *actionSheet;
@property (strong, nonatomic) IBOutlet UIPickerView *placePicker;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (retain, nonatomic) IBOutlet UITableView *_tableView;
@property (retain, nonatomic) NSMutableDictionary *savedSettings;
@property (retain, nonatomic) NSArray *settingsOrder;
@property (retain, nonatomic) NSIndexPath *editing;
@property (retain, nonatomic) NSDate *minDate;
@property (retain, nonatomic) NSDate *maxDate;
@property (retain, nonatomic) NSArray *cities;
@property (retain, nonatomic) NSMutableDictionary *arguments;
@property (retain, nonatomic) API *api;

- (IBAction) goBack: (id)sender;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
-(IBAction)segmentAction:(UISegmentedControl *) segmentController;
-(IBAction)saveButtonPressed:(id) sender;
-(IBAction)dismissActionSheetWithSave:(id) sender;
-(IBAction)dismissActionSheetWithCancel:(id) sender;
- (void) showPlace;
- (void) showDate;

@end
