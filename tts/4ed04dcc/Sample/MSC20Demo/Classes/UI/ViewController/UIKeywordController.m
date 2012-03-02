    //
//  UIKeywordController.m
//  MSC20Demo
//
//  Created by yangchen on 11-3-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIKeywordController.h"

@interface UIKeywordController(Private)

- (void)disableButton;

- (void)enableButton;

@end

@implementation UIKeywordController

- (id)init
{
	if (self = [super init])
	{
		self.title = @"识别演示";
	}
	return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)disableButton
{
	_uploadButton.enabled = NO;
	_keywordButton.enabled = NO;
	_setupButton.enabled = NO;
	_textView.editable = NO;
	self.navigationController.navigationItem.leftBarButtonItem.enabled = NO;
}

- (void)enableButton
{
	_uploadButton.enabled = YES;
	_keywordButton.enabled = YES;
	_setupButton.enabled = YES;
	_textView.editable = YES;
	self.navigationController.navigationItem.leftBarButtonItem.enabled = YES;
}

#pragma mark 
#pragma mark 接口回调


//	识别结束回调
- (void)onRecognizeEnd:(IFlyRecognizeControl *)iFlyRecognizeControl theError:(SpeechError) error
{
	NSLog(@"识别结束回调finish.....");
	[self enableButton];
	//[self onButtonKeyword];
	NSLog(@"getUpflow:%d,getDownflow:%d",[iFlyRecognizeControl getUpflow],[iFlyRecognizeControl getDownflow]);
	
}
- (void)onUpdateTextView:(NSString *)sentence
{
	_textView.text = sentence;
}


- (void)onRecognizeResult:(NSArray *)array
{
	[self performSelectorOnMainThread:@selector(onUpdateTextView:) withObject:[array objectAtIndex:0] waitUntilDone:YES];
}

- (void)onKeywordResult:(NSArray*)array
{
	NSMutableString *sentence = [[[NSMutableString alloc] init] autorelease];
	
	for (int i = 0; i < [array count]; i++)
	{
		[sentence appendFormat:@"%@		置信度:%@\n",[[array objectAtIndex:i] objectForKey:@"NAME"],
		 [[array objectAtIndex:i] objectForKey:@"SCORE"]];
	}
	[self performSelectorOnMainThread:@selector(onUpdateTextView:) withObject:sentence waitUntilDone:YES];
	
	NSLog(@"keyword result : %@", sentence);
}

- (void)onResult:(IFlyRecognizeControl *)iFlyRecognizeControl theResult:(NSArray *)resultArray
{
	NSLog(@"- (void)onResult:(IFlyRecognizeControl *)iFlyRecognizeControl thParam:(id)params");
	if(_type == IsrKeyword)
	{
		[self onKeywordResult:resultArray];
	}
	else 
	{
		
		[_keywordID release];
		_keywordID = [[resultArray objectAtIndex:0] retain];
		NSLog(@"UIkeywordController onResult:%@",_keywordID);
	}
}


#pragma mark 
#pragma mark 内部调用

//获取应用程序的文档目录
- (NSString *)getDirectory
{
	NSArray *userPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDirectory = [userPaths objectAtIndex:0];
	
	documentDirectory = [documentDirectory stringByAppendingString:@"/keyword.txt"];
	
	return documentDirectory;	
}

- (NSString *)readKeywordString
{
	NSString *name = [self getDirectory];
	NSLog(@"directory name:%@",name);
	FILE *fp ;
	if((fp= fopen([name UTF8String], "r"))==NULL)
	{
		NSLog(@"can not open keyword file");
		return KEYWORD_UPLOAD;
	}
	
	fseek(fp, 0, SEEK_END);
	long fileSize = ftell(fp);
	fseek(fp, 0, SEEK_SET);
	
	char* fileBuf = (char*)malloc(fileSize * sizeof(char));
	fread(fileBuf, fileSize, fileSize, fp);

	NSString *str = [NSString stringWithUTF8String:fileBuf];
	fclose(fp);
	return(str);
}

// 关键字上传
- (void)onButtonUpload
{	
	NSString *keywordString = [NSString stringWithFormat:@"%@",[self readKeywordString]];//上传的关键字之间用逗号隔开
	if([keywordString length] == 0)
	{
		return;
	}
	NSLog(@"keywordString:%@",keywordString);
	[_iFlyRecognizeControl setEngine:@"keywordupload" theEngineParam:keywordString theGrammarID:nil];
	
	if([_iFlyRecognizeControl start])
	{
		_type = IsrUploadKeyword;
		[self disableButton];
	}
}

// 识别
- (void)onButtonKeyword
{
	NSLog(@"UIkeywordController onButtonKeyword:%@",_keywordID);
	
	[_iFlyRecognizeControl setEngine:@"keyword" theEngineParam:nil theGrammarID:_keywordID];
	
	if([_iFlyRecognizeControl start])
	{
		[self disableButton];
		_type = IsrKeyword;
	}
}

// 设置
- (void)onButtonSetup
{
	[self.navigationController pushViewController:_keywordSetupController animated:YES];
}


- (void)viewDidLoad 
{
	NSString *initParam = [[NSString alloc] initWithFormat:
						   @"server_url=%@,appid=%@",ENGINE_URL,APPID];
	// 识别控件
	_iFlyRecognizeControl = [[IFlyRecognizeControl alloc]initWithOrigin:H_CONTROL_ORIGIN theInitParam:initParam];
	[_iFlyRecognizeControl setSampleRate:16000];
	_iFlyRecognizeControl.delegate = self;
	[self.view addSubview:_iFlyRecognizeControl];
	_keywordSetupController = [[UIKeywordSetupController alloc] initWithRecognize:_iFlyRecognizeControl];

	_keywordID = KEYWORD_ID;
	[initParam release];
	
	NSString *name = [self getDirectory];
	NSLog(@"directory name:%@",name);
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if(![fileManager fileExistsAtPath:name])
	{

		FILE *fp = fopen([name UTF8String], "w");
		if(!fp)
		{
			NSLog(@"不能生成文件");
			return;
		}
		NSString *str = [NSString stringWithFormat:@"%@",KEYWORD_UPLOAD];
		fputs([str UTF8String], fp);
		fclose(fp);
	}

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
		height = 160;
	}
	return height;
}

/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString* sectionTitle = nil;
	switch (section) 
	{
		case 0:
			sectionTitle = @"识别结果";
			break;
		case 1: 
			sectionTitle = @"用户操作";
			break;
	}
	return sectionTitle;
}
*/

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
		
		_textView = [[self addTextViewWithFrame:H_TEXTVIEW_FRAME theText:nil] retain];
		//_textView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"input.png"]];
		_textView.backgroundColor = [UIColor clearColor];
		[cell addSubview: _textView];
	}
	else
	{
		UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		button1.frame = CGRectMake(20, 10, 280, 40);
		[button1 setTitle:@"开始听写" forState:UIControlStateNormal];
		[button1 addTarget:self action:@selector(onButtonKeyword) forControlEvents:UIControlEventTouchDown];
		
		[cell addSubview:button1];
		
		UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		button2.frame = CGRectMake(20, 60, 280, 40);
		[button2 setTitle:@"上传" forState:UIControlStateNormal];
		[button2 addTarget:self action:@selector(onButtonUpload) forControlEvents:UIControlEventTouchDown];
		
		[cell addSubview:button2];
		
		UIButton *button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		button3.frame = CGRectMake(20, 110, 280, 40);
		[button3 setTitle:@"设置" forState:UIControlStateNormal];
		[button3 addTarget:self action:@selector(onButtonSetup) forControlEvents:UIControlEventTouchDown];
		
		[cell addSubview:button3];

	}
	
    return cell;
}

@end
