    //
//  UISynthesizerController.m
//  MSC20Demo
//
//  Created by yangchen on 11-3-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UISynthesizerController.h"

@interface UISynthesizerController(Private)

- (void)disableButton;

- (void)enableButton;

@end

@implementation UISynthesizerController

- (id)init
{
	if (self = [super init])
	{
		self.title = TITLE;

	}
	return self;
}

- (void)dealloc
{
    [super dealloc];
}

#pragma mark 
#pragma mark 接口回调
- (void) setDefaultText:(NSString *)_text {
    defaultText = _text;
}
//	合成结束回调
- (void)onSynthesizerEnd:(IFlySynthesizerControl *)iFlySynthesizerControl theError:(SpeechError) error
{
	NSLog(@"finish.....");
	[self enableButton];
	NSLog(@"upFlow:%d,downFlow:%d",[iFlySynthesizerControl getUpflow],[iFlySynthesizerControl getDownflow]);
}

#pragma mark
#pragma mark 内部调用

- (void)disableButton
{
	_synthesizerButton.enabled = NO;
	_setupButton.enabled = NO;
	_textView.editable = NO;
	self.navigationController.navigationItem.leftBarButtonItem.enabled  = NO;
}

- (void)enableButton
{
	_synthesizerButton.enabled = YES;
	_setupButton.enabled = YES;
	_textView.editable = YES;
	self.navigationController.navigationItem.leftBarButtonItem.enabled = YES;
}

// 合成
- (void)onButtonSynthesizer
{
	[_iFlySynthesizerControl setText:_textView.text theParams:nil];
	if([_iFlySynthesizerControl start])
	{
		[self disableButton];
	}
}

// 设置
- (void)onButtonSetup
{
	[self.navigationController pushViewController:_synthesizerSetupController animated:YES];
}

- (void)viewDidLoad 
{
	NSString *initParam = [[NSString alloc] initWithFormat:
						   @"server_url=%@,appid=%@",ENGINE_URL,APPID];
	
	// 合成控件
	_iFlySynthesizerControl = [[IFlySynthesizerControl alloc] initWithOrigin:H_CONTROL_ORIGIN theInitParam:initParam];
	_iFlySynthesizerControl.delegate = self;
	[self.view addSubview:_iFlySynthesizerControl];
	[initParam release];
	_synthesizerSetupController = [[UISynthesizerSetupController alloc] initWithSynthesizer:_iFlySynthesizerControl];
	[super viewDidLoad];	
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[_textView resignFirstResponder];
}

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat height = 0;
	if (indexPath.section == 0) 
	{
		height = 185;
	}
	else 
	{
		height = 110;
	}
	return height;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil] autorelease];
    }
	
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	
	// Configure the cell.
	
	if (indexPath.section == 0)
	{
		UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"input.png"]];
		imageView.frame = H_BACK_TEXTVIEW_FRAME;
		[cell addSubview:imageView];
		[imageView release];
        NSLog(@"%@",defaultText);

        if (defaultText) {
            _textView = [[self addTextViewWithFrame:H_TEXTVIEW_FRAME theText:defaultText] retain];
        }else{
            _textView = [[self addTextViewWithFrame:H_TEXTVIEW_FRAME theText:TEXT_SHOW] retain];
        }
		//_textView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"input.png"]];
		_textView.backgroundColor = [UIColor clearColor];

		[cell addSubview: _textView];
	}
	else
	{
		UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		button1.frame = CGRectMake(20, 10, 280, 40);
		[button1 setTitle:BUTTON_TITLE1 forState:UIControlStateNormal];
		[button1 addTarget:self action:@selector(onButtonSynthesizer) forControlEvents:UIControlEventTouchDown];
		
		[cell addSubview:button1];
		
		UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		button2.frame = CGRectMake(20, 60, 280, 40);
		[button2 setTitle:BUTTON_TITLE2 forState:UIControlStateNormal];
		[button2 addTarget:self action:@selector(onButtonSetup) forControlEvents:UIControlEventTouchDown];
		
		[cell addSubview:button2];
	}
	
    return cell;
}

@end
