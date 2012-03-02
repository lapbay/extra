//
//  DPDetailViewController.m
//  dingpiaojingling
//
//  Created by Wu Chang on 11-12-11.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "DPDetailViewController.h"

@implementation DPDetailViewController
@synthesize delegate = _delegate, _tableView, savedTickets, tickets, editing;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"车票详情", @"Detail");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
        self.savedTickets = [NSMutableDictionary dictionaryWithDictionary: [[[[dataSharer sharedManager].storage _read] objectForKey:@"storages"] objectAtIndex:0]];
        self.tickets = [NSMutableArray arrayWithArray: [self.savedTickets objectForKey:@"tickets"]];
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.editing = [NSMutableDictionary dictionaryWithObjectsAndKeys: nil];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"车票详情", @"Detail");
        self.savedTickets = [NSMutableDictionary dictionaryWithDictionary: [[[[dataSharer sharedManager].storage _read] objectForKey:@"storages"] objectAtIndex:0]];
        self.tickets = [NSMutableArray arrayWithArray: [self.savedTickets objectForKey:@"tickets"]]; 
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
    NSMutableDictionary *dict = self.delegate.onTicket;
    NSLog(@"%@",dict);
    [_tableView reloadData];
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
    NSString *key = [NSString stringWithFormat:@"%@ 至 %@", [self.delegate.onTicket objectForKey:@"departure"], [self.delegate.onTicket objectForKey:@"destination"]];
    return key;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
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
    return tickets.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell.
    NSDictionary *obj = [self.tickets objectAtIndex:indexPath.row];
    cell.textLabel.text = [obj objectForKey:@"number"];
    cell.detailTextLabel.text = [obj objectForKey:@"seats"];
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
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *__strong)indexPath {
    NSLog(@"deselect");
}
							
@end
