//
//  DPSettingsViewController.m
//  dingpiaojingling
//
//  Created by Wu Chang on 11-12-11.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "DPSettingsViewController.h"

@implementation DPSettingsViewController
@synthesize _tableView, savedSettings, settingsOrder, editing;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Settings", @"Settings");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
        self.savedSettings = [NSMutableDictionary dictionaryWithDictionary: [[[dataSharer sharedManager].storage _read] objectForKey:@"settings"]];
        self.settingsOrder = [NSArray arrayWithArray: [self.savedSettings objectForKey:@"Order"]];
        
        [self.savedSettings removeObjectForKey:@"Order"];
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.editing = [NSMutableDictionary dictionaryWithObjectsAndKeys: nil];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"Settings", @"Settings");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
        self.savedSettings = [NSMutableDictionary dictionaryWithDictionary: [[[dataSharer sharedManager].storage _read] objectForKey:@"settings"]];
        self.settingsOrder = [NSArray arrayWithArray: [self.savedSettings objectForKey:@"Order"]];
        
        [self.savedSettings removeObjectForKey:@"Order"];
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.editing = [NSMutableDictionary dictionaryWithObjectsAndKeys: nil];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(rand() % 255, rand() % 255, rand() % 255);
	// Do any additional setup after loading the view, typically from a nib.
    CGRect scrollFrame = CGRectMake(0, 0,  320,  480 - 49 - 20);
    _tableView = [[UITableView alloc] initWithFrame:scrollFrame style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;

    [self.view addSubview: _tableView];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
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
    UIHudViewController *hud = [[dataSharer sharedManager].viewControllers objectAtIndex:6];
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text isEqualToString:@"Author"]) {
        [hud show: @"Author: wuchang"];
    }else{
        //[hud show: @"Author: wuchang"];
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys: 
                              [NSDictionary dictionaryWithObjectsAndKeys:cell.detailTextLabel.text, cell.textLabel.text, nil], [NSString stringWithFormat:@"Edit %@",cell.textLabel.text],
                              nil];
        UIEditView *edit = [[UIEditView alloc] initWithData:data];
        edit.editDelegate = self;
        [self.view addSubview:edit];
        [self.editing setObject:indexPath forKey:cell.textLabel.text];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *__strong)indexPath {
    NSLog(@"deselect");
}

- (void) UIEditViewSaveData:(NSDictionary *)data {
    NSLog(@"saving, %d", [data count]);
    NSMutableDictionary *apiSetting = [NSMutableDictionary dictionaryWithDictionary: [self.savedSettings objectForKey:@"api"]];
    for (NSString *key in data) {
        [apiSetting setObject:[data objectForKey:key] forKey:key];
    }
    [self.savedSettings setObject:apiSetting forKey:@"api"];
    //[savedSettings setObject:data forKey:@"api"];
    Storage *settings = [dataSharer sharedManager].storage;
    [settings _write:savedSettings];
    [self._tableView reloadData];
    /*for (NSString *key in data) {
     NSIndexPath *indexPath = [self.editing objectForKey:key];
     NSLog(@"%@",indexPath);
     UITableViewCell *cell = [self tableView:self._tableView cellForRowAtIndexPath:indexPath];
     //cell.detailTextLabel.text = @"haha:";
     [self.editing removeObjectForKey:key];
     //[self._tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
     }*/
}

- (void) UIEditViewCancelData {
    [self._tableView reloadData];
}

@end
