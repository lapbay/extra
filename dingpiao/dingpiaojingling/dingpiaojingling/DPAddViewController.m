//
//  DPAddViewController.m
//  dingpiaojingling
//
//  Created by Wu Chang on 11-12-11.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "DPAddViewController.h"

@implementation DPAddViewController
@synthesize _tableView, savedSettings, settingsOrder, editing, cities, arguments, minDate, maxDate, actionSheet, placePicker, datePicker, api;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        api = [[API alloc] init];
        [api setDelegate:self];

        self.title = NSLocalizedString(@"添加车票提醒", @"Add ticket");
        self.savedSettings = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                              @"始发站和终点站", @"选择站点",
                              [NSMutableDictionary dictionaryWithObjectsAndKeys:
                              @"最早出发时间", @"最早",
                              @"最晚出发时间", @"最晚", nil], @"选择时间",
                              nil];
        self.settingsOrder = [self.savedSettings allKeys];
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        NSString *token = [[[dataSharer sharedManager].storage _read] objectForKey:@"token"];
        self.arguments = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                        @"", @"start",
                        @"", @"end",
                        @"", @"departure",
                        @"", @"destination",
                        token, @"token",
                        nil];
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"cities" ofType:@"plist"]; 
        cities = [[NSDictionary dictionaryWithContentsOfFile:plistPath] objectForKey:@"cities"];

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    actionSheet = [[UIActionSheet alloc] initWithTitle:nil 
                                              delegate:nil
                                     cancelButtonTitle:nil
                                destructiveButtonTitle:nil
                                     otherButtonTitles:nil];
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
    
    placePicker = [[UIPickerView alloc] initWithFrame:pickerFrame];
    placePicker.showsSelectionIndicator = YES;
    placePicker.dataSource = self;
    placePicker.delegate = self;
    datePicker = [[UIDatePicker alloc] initWithFrame:pickerFrame];
    datePicker.timeZone = [NSTimeZone defaultTimeZone];  
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.minimumDate = [NSDate date];
    datePicker.maximumDate =  [NSDate dateWithTimeInterval:3600*24*365*2 sinceDate:[NSDate date]];
    //[datePicker addTarget: self action: @selector(valueChanged:) forControlEvents: UIControlEventValueChanged];
    
    UISegmentedControl *saveButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"保存"]];
    saveButton.momentary = YES; 
    saveButton.frame = CGRectMake(10.0f, 7.0f, 50.0f, 30.0f);
    saveButton.segmentedControlStyle = UISegmentedControlStyleBar;
    saveButton.tintColor = [UIColor blackColor];
    [saveButton addTarget:self action:@selector(dismissActionSheetWithSave:) forControlEvents:UIControlEventValueChanged];
    [actionSheet addSubview:saveButton];
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"不保存"]];
    closeButton.momentary = YES; 
    closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor blackColor];
    [closeButton addTarget:self action:@selector(dismissActionSheetWithCancel:) forControlEvents:UIControlEventValueChanged];
    [actionSheet addSubview:closeButton];
    
    CGRect scrollFrame = CGRectMake(0, 0,  320,  480 - 49 - 20);
    _tableView = [[UITableView alloc] initWithFrame:scrollFrame style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview: _tableView];
    
    UIBarButtonItem *NavButtonRight = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"保存", @"Save")
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(saveButtonPressed:)];
    self.navigationItem.rightBarButtonItem = NavButtonRight;

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return cities.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSDictionary *city = [cities objectAtIndex:row];
    return [city objectForKey:@"name"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"selected");
}

-(IBAction)segmentAction:(UISegmentedControl *) segmentController{
    if (segmentController.selectedSegmentIndex == 0) {
        [self.view addSubview:placePicker];
        [datePicker removeFromSuperview];

    } else if (segmentController.selectedSegmentIndex == 1) {
        [self.view addSubview:datePicker]; 
        [placePicker removeFromSuperview];
    } else {
        
    }
}

- (IBAction) goBack: (id) sender {
    NSLog(@"%@",@"go back");
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *key = [[self.savedSettings allKeys] objectAtIndex:section];
    return key;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.savedSettings.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 36.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    
    // Create label with section title
    UILabel *label = [[UILabel alloc] init];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 320, 30)];
    label.frame = CGRectMake(10, 0, 300, 30);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.font = [UIFont boldSystemFontOfSize:18];
    label.text = sectionTitle;
    
    // Create header view and add label as a subview
    [view addSubview:label];
    
    return view;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = [self.settingsOrder objectAtIndex:section];
    id obj = [self.savedSettings objectForKey:key];
    if ([obj isKindOfClass:[NSDictionary class]] == YES) {
        NSDictionary *result = obj;
        return result.count;
    }else if ([obj isKindOfClass:[NSArray class]] == YES) {
        NSArray *result = obj;
        return result.count;
    }else{
        return 1;
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell.
    NSString *key = [self.settingsOrder objectAtIndex:indexPath.section];
    id obj = [self.savedSettings objectForKey:key];
    if ([obj isKindOfClass:[NSDictionary class]] == YES) {
        NSDictionary *result = obj;
        NSString *skey = [[result allKeys] objectAtIndex:indexPath.row];
        cell.textLabel.text = skey;
        cell.detailTextLabel.text = [result objectForKey:skey];
    }else if ([obj isKindOfClass:[NSArray class]] == YES) {
        NSArray *result = obj;
        cell.textLabel.text = [result objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [result objectAtIndex:indexPath.row];
    }else if ([obj isKindOfClass:[NSNumber class]] == YES) {
        NSNumber *result = obj;
        cell.textLabel.text = key;
        cell.detailTextLabel.text = [result stringValue];
    }else{
        NSString *result = obj;
        cell.textLabel.text = key;
        cell.detailTextLabel.text = result;
    }
    cell.textLabel.backgroundColor = [UIColor clearColor];
	[self configureCell:cell atIndexPath:indexPath];
    return cell;
    //cell.contentView.backgroundColor = [UIColor whiteColor];
    /*UIView *backgrdView = [[UIView alloc] initWithFrame:cell.frame];
     backgrdView.backgroundColor = [UIColor whiteColor];
     cell.backgroundView = backgrdView;
     cell.layer.cornerRadius = 6;
     cell.layer.masksToBounds = YES; */
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	
    // Configure the cell to specified style
    if ([cell.textLabel.text isEqualToString: @"Debug"]) {
        cell.detailTextLabel.text = nil;
        UISwitch *aSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.accessoryView = aSwitch;
        [(UISwitch *)cell.accessoryView setOn:YES];
        [(UISwitch *)cell.accessoryView addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventValueChanged];
    }else if ([cell.textLabel.text isEqualToString: @"Author"] || [cell.textLabel.text isEqualToString: @"Version"]) {
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    //UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:indexPath.section];
    self.editing = indexPath;
    if ([sectionTitle isEqualToString:@"选择时间"]) {
        [self showDate];
    }else{
        [self showPlace];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *__strong)indexPath {
    NSLog(@"deselect");
}

- (void) showPlace {
    if (self.datePicker) {
        [self.datePicker removeFromSuperview];
    }
    [actionSheet addSubview:placePicker];
    [actionSheet showInView:self.view];
    [actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
}

- (void) showDate{
    if (self.placePicker) {
        [self.placePicker removeFromSuperview];
    }
    [actionSheet addSubview:datePicker];
    [actionSheet showInView:self.view];
    [actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
}

-(IBAction)dismissActionSheetWithSave:(id) sender{
    NSString *key = [self.settingsOrder objectAtIndex:self.editing.section];
    if ([key isEqualToString:@"选择站点"]) {
        NSDictionary *city1 = [self.cities objectAtIndex: [self.placePicker selectedRowInComponent:0]];
        NSDictionary *city2 = [self.cities objectAtIndex: [self.placePicker selectedRowInComponent:1]];
        [self.savedSettings setObject:[NSString stringWithFormat:@"%@至%@",[city1 objectForKey:@"name"],[city2 objectForKey:@"name"]] forKey:@"选择站点"];
        [self.arguments setObject:[city1 objectForKey:@"code"] forKey:@"departure"];
        [self.arguments setObject:[city2 objectForKey:@"code"] forKey:@"destination"];
    }else{
        NSMutableDictionary *subDict = [self.savedSettings objectForKey:key];
        NSString *subKey = [[subDict allKeys] objectAtIndex:self.editing.row];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy/MM/dd";
        NSString *timestamp = [formatter stringFromDate:self.datePicker.date];
        [subDict setObject:timestamp forKey:subKey];
        [self.savedSettings setObject:subDict forKey:key];
        if ([subKey isEqualToString:@"最早"]) {
            [self.arguments setObject:timestamp forKey:@"start"];
        }else{
            [self.arguments setObject:timestamp forKey:@"end"];
        }
    }
    [self._tableView reloadData];
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

-(IBAction)dismissActionSheetWithCancel:(id) sender {
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

-(IBAction)saveButtonPressed:(id) sender{
    if ([[arguments objectForKey:@"start"] isEqualToString:@""] || [[arguments objectForKey:@"end"] isEqualToString:@""] || [[arguments objectForKey:@"departure"] isEqualToString:@""] || [[arguments objectForKey:@"destination"] isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"不能保存"
                                                    message:@"必须设定所有条件"
                                                    delegate:nil
                                                    cancelButtonTitle:@"确定"
                                                    otherButtonTitles:nil];
        [alert show];
    }else{
        NSDictionary *result = [api createTicket:self.arguments];
        NSLog(@"%@",result);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


@end
