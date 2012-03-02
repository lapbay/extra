//
//  DPMasterViewController.m
//  dingpiaojingling
//
//  Created by Wu Chang on 11-12-11.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "DPMasterViewController.h"

@implementation DPMasterViewController

@synthesize detailViewController = _detailViewController, addViewController = _addViewController, settingsViewController = _settingsViewController, tickets, onTicket, api, cities;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"订票精灵", @"Ticket Assistant");
        [self initData];
    }
    return self;
}
							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void) initData{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"cities" ofType:@"plist"]; 
    cities = [[NSDictionary dictionaryWithContentsOfFile:plistPath] objectForKey:@"cities"];
    api = [[API alloc] init];
    [api setDelegate:self];
    //NSMutableArray *cities = [api hot];
    /*NSArray *cities = [body componentsSeparatedByString:@"\n"];
    NSMutableArray *theCities = [NSMutableArray arrayWithObjects: nil];
    for (int i=0;i<cities.count;i++) {
        if (i%2==0) {
            NSString *code = [cities objectAtIndex:i];
            if ([code isEqualToString:@""]){
                continue;
            }
            NSString *name = [cities objectAtIndex:i+1];
            NSDictionary *theCity = [NSDictionary dictionaryWithObjectsAndKeys:
                                     code,@"code",
                                     name,@"name",
                                     nil];
            [theCities addObject:theCity];
        }
    }
    NSLog(@"%@",theCities);
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:theCities, @"cities",nil];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [NSString stringWithFormat:@"%@/%@",documentsDirectory,@"cities.plist"];
    [dict writeToFile:path atomically:YES];
    return theCities;*/
}

- (void) refreshData{
    return;
    tickets = [NSMutableArray arrayWithArray: [[api listTicket] objectForKey:@"data"]];
    for (int i=0; i<tickets.count; i++) {
        NSMutableDictionary *ticket = [tickets objectAtIndex:i];
        NSString *dep = [ticket objectForKey:@"departure"];
        NSString *des = [ticket objectForKey:@"destination"];
        for (NSDictionary *city in cities) {
            NSString *code = [city objectForKey:@"code"];
            if ([code isEqualToString:dep]) {
                dep = [city objectForKey:@"name"];
            }
            if ([code isEqualToString:des]) {
                des = [city objectForKey:@"name"];
            }
        }
        [ticket setObject:dep forKey:@"departure"];
        [ticket setObject:des forKey:@"destination"];
        [tickets replaceObjectAtIndex:i withObject:ticket];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    UIBarButtonItem *NavButtonLeft = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"添加", @"Add")
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(AddButtonPressed)];
    UIBarButtonItem *NavButtonRight = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"设置", @"Settings")
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(SettingsButtonPressed)];
    self.navigationItem.leftBarButtonItem = NavButtonLeft;
    self.navigationItem.rightBarButtonItem = NavButtonRight;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressOnTable:)];
    [self.tableView addGestureRecognizer:longPress];

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
    [self refreshData];
    [self.tableView reloadData];
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

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tickets.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    // Configure the cell.
    NSDictionary *ticket = [self.tickets objectAtIndex:indexPath.row];
    //NSString *value = [self.tickets objectForKey:key];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ 至 %@", [ticket objectForKey:@"departure"],[ticket objectForKey:@"destination"]];
    
    if ([ticket objectForKey:@"msg"]) {
        cell.detailTextLabel.text = [ticket objectForKey:@"msg"];
    }else{
        cell.detailTextLabel.text = @"没有信息";
    }
    cell.textLabel.backgroundColor = [UIColor clearColor];
	[self configureCell:cell atIndexPath:indexPath];
    return cell;
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.onTicket = [self.tickets objectAtIndex:indexPath.row];
    if (!self.detailViewController) {
        self.detailViewController = [[DPDetailViewController alloc] initWithNibName:@"DPDetailViewController" bundle:nil];
        [self.detailViewController setDelegate:self];
    }
    [self.navigationController pushViewController:self.detailViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        /*UIActionSheet *registerActionSheet = [[UIActionSheet alloc] initWithTitle:@"Sure You Want To Delete?"delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Yes", nil];
        registerActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [registerActionSheet showInView:self.view];*/
        // modelForSection is a custom model object that holds items for this section.
        [tableView beginUpdates];
        NSDictionary *ticket = [self.tickets objectAtIndex:indexPath.row];
        NSString *ticketid = [ticket objectForKey:@"id"];
        NSDictionary *result = [api destroyTicket:[NSDictionary dictionaryWithObjectsAndKeys:ticketid, @"id", nil]];
        NSLog(@"%@",result);
        [self.tickets removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
    }
}

- (void) AddButtonPressed {
    if (!self.addViewController) {
        self.addViewController = [[DPAddViewController alloc] initWithNibName:@"DPAddViewController" bundle:nil];
    }
    [self.navigationController pushViewController:self.addViewController animated:YES];
}

- (void) SettingsButtonPressed {
    if (!self.settingsViewController) {
        self.settingsViewController = [[DPSettingsViewController alloc] initWithNibName:@"DPSettingsViewController" bundle:nil];
    }
    [self.navigationController pushViewController:self.settingsViewController animated:YES];
}

-(void)longPressOnTable:(UILongPressGestureRecognizer *) gesture{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (self.tableView.editing == YES) {
            [self.tableView setEditing: NO animated:YES];
        }else{
            [self.tableView setEditing: YES animated: YES];
        }
    }
}

@end
