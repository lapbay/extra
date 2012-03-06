//
//  WIMainViewController.m
//  whois
//
//  Created by Wu Chang on 12-2-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WIMainViewController.h"

@interface WIMainViewController ()

@end

@implementation WIMainViewController
@synthesize imageView, searchBar, resultView, webView, infoButton, hud, pureText;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.frame = CGRectMake(35, 160, 250, 78);
    [self.view addSubview:self.imageView];
    NSDictionary *APIArgs = [[[[dataSharer sharedManager].storage _read] objectForKey: @"settings"] objectForKey: @"api"];
    self.pureText = [[APIArgs objectForKey:@"text"] boolValue];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton = YES;
    self.searchBar.barStyle = UIBarStyleDefault;
    self.searchBar.keyboardType = UIKeyboardTypeURL;
    self.searchBar.placeholder = @"输入域名查询Whois信息";
    [self.view addSubview:self.searchBar];
    for(id cc in [self.searchBar subviews]){
        if([cc isKindOfClass:[UIButton class]]){
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"Search"  forState:UIControlStateNormal];
        }
    }
    if (self.pureText) {
        self.resultView = [[UITextView alloc] initWithFrame:CGRectMake(0, 44, 320, 416)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taped:)];
        [self.resultView addGestureRecognizer:tap];
        self.resultView.editable = NO;
        self.resultView.backgroundColor = [UIColor lightTextColor];
        [self.view addSubview:self.resultView];
    }else {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, 416)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taped:)];
        [self.webView addGestureRecognizer:tap];
        self.webView.alpha = 0;
        self.webView.backgroundColor = [UIColor whiteColor];
        //self.webView.opaque = NO;
        /*NSString *html = @"<html><head><body><img src=\"Default.png\"><body></head></html>";
        NSString *path = [[NSBundle mainBundle] resourcePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        [self.webView loadHTMLString:html baseURL:baseURL];*/
        //[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://zunmi.com/wap.php"]]];
        [self.view addSubview:self.webView];
    }
    self.infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    self.infoButton.frame = CGRectMake(290, 55, self.infoButton.frame.size.width, self.infoButton.frame.size.height);
    [self.infoButton addTarget:self action:@selector(showInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.infoButton];
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:self.hud];
    self.hud.delegate = self;
    self.hud.labelText = @"正在查询...";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
        self.imageView.frame = CGRectMake(35, 160, 250, 78);
        self.searchBar.frame = CGRectMake(0, 0, 320, 44);
        self.webView.frame = CGRectMake(0, 44, 320, 416);
        self.infoButton.frame = CGRectMake(290, 55, self.infoButton.frame.size.width, self.infoButton.frame.size.height);
        //self.webView.autoresizingMask = UIViewAutoresizingNone;
    }else {
        NSLog(@"%@",@"UIInterfaceOrientationLandscapeLeft");
        self.imageView.frame = CGRectMake(115, 80, 250, 78);
        self.searchBar.frame = CGRectMake(0, 0, 480, 44);
        self.webView.frame = CGRectMake(0, 44, 480, 256);
        self.infoButton.frame = CGRectMake(450, 55, self.infoButton.frame.size.width, self.infoButton.frame.size.height);
        //self.webView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    }
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Flipside View
- (IBAction) taped:(UIGestureRecognizer *) sender{
    //NSLog(@"%@",sender.view);
    [self.searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
    [self doSearch];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [self.searchBar resignFirstResponder];
    [self doSearch];
}

- (IBAction)showInfo:(id)sender
{    
    //self.hud.labelText = @"正在打开尊米网Wap版...";
    //[self.hud show:YES];
    [self.searchBar resignFirstResponder];
    self.webView.alpha = 1;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://zunmi.com/wap.php"]]];
}

- (IBAction)doSearch:(id)sender{
    [self doSearch];
}

- (void)doSearch{
    self.hud.labelText = @"正在查询...";
    [self.hud show:YES];
    if (![self.searchBar.text isEqualToString:@""]) {
        MIRequestManager *requestManager = [MIRequestManager requestManager];
        //NSString *imageURL = @"http://local.pasent.com/images/milan/5f3b7dbf3ebfc364a8dd5d6092639622.jpg";
        //[requestManager imageLoader:imageURL withIndex:[NSNumber numberWithInt:1234]];
        [requestManager whoisAPI:@"http://whois.zunmi.com/mobile.php" withIndex:self.searchBar.text withDelegate:self];
        [MobClick event:@"domain" label:[self.searchBar.text lowercaseString]];
    }
    /*NSMutableDictionary *result = [api searchDomain:toSearch];
    if (self.pureText) {
        self.resultView.text = [result objectForKey:@"body"];
    }else {
        //NSString *html = [result objectForKey:@"body"];
        NSString *path = [[NSBundle mainBundle] resourcePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        [self.webView loadData:[result objectForKey:@"body"] MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:baseURL];
    }*/
    //self.resultView.text = @"body";
}

- (void)refreshView:(NSData *)body {
    self.webView.alpha = 0.6;
    if (self.pureText) {
        self.resultView.text = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
    }else {
        //NSString *html = [result objectForKey:@"body"];
        NSString *path = [[NSBundle mainBundle] resourcePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        [self.webView loadData:(NSData *)body MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:baseURL];
        //[self.webView loadData:(NSData *)body MIMEType:@"image/jpg" textEncodingName:@"UTF-8" baseURL:baseURL];
    }
    [self.hud hide:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self doSearch];
    }
}

- (void)connection:(NSURLConnection *) connection didFailWithError:(NSError *)error{
    NSLog(@"Connection failed! Error - %@ %@",[error localizedDescription],[[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    [self performSelectorOnMainThread:@selector(refreshViewWithError:) withObject:error waitUntilDone:[NSThread isMainThread]];
}

- (void)refreshViewWithError:(NSError *)error {
    NSString *msg;
    UIAlertView *alert;
    NSLog(@"%@",[error localizedDescription]);
    if ([[error localizedDescription] isEqualToString:@"The Internet connection appears to be offline."]) {
        msg = @"网络连接错误，请检查网络设置是否正确";
        alert = [[UIAlertView alloc]initWithTitle:@"网络错误"
                                          message:msg
                                         delegate:self
                                cancelButtonTitle:@"确定"
                                otherButtonTitles:nil,nil];
    }else if ([[error localizedDescription] isEqualToString:@"Could not connect to the server."]) {
        msg = @"无法连接到服务器";
        alert = [[UIAlertView alloc]initWithTitle:@"网络错误"
                                          message:msg
                                         delegate:self
                                cancelButtonTitle:@"取消"
                                otherButtonTitles:@"重试",nil];
    }else {
        msg = @"网络连接超时";
        alert = [[UIAlertView alloc]initWithTitle:@"网络错误"
                                          message:msg
                                         delegate:self
                                cancelButtonTitle:@"取消"
                                otherButtonTitles:@"重试",nil];
    }
    [alert show];
    [self.hud hide:YES];
}

- (void)connectionDidFinishLoading:(NSMutableDictionary *) response{
    [self performSelectorOnMainThread:@selector(refreshView:) withObject:[response objectForKey:@"data"] waitUntilDone:[NSThread isMainThread]];
}

@end
