//
//  UIHudViewController.m
//  milan
//
//  Created by Wu Chang on 11-11-15.
//  Copyright 2011年 Unique. All rights reserved.
//

#import "UIHudViewController.h"

@implementation UIHudViewController
@synthesize text,label;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (id) initWithText:(NSString *) tex{
    self = [super init];
    if (self) {
        text = [tex copy];
    }
	return self;
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{	
	label = [[UILabel alloc] init];
	
	UIButton *v = [UIButton buttonWithType:UIButtonTypeCustom];
    v.userInteractionEnabled = NO;
    v.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
	v.layer.cornerRadius = 5;
    [v addSubview:label];

    self.view = v;
    
}

- (void) textSet:(NSString *) _text {

    UIFont *font = [UIFont systemFontOfSize:16];
    CGSize textSize = [_text sizeWithFont:font constrainedToSize:CGSizeMake(280, 300)];
    
    self.view.frame = CGRectMake( (310 - textSize.width) / 2 , 100, textSize.width + 10, textSize.height + 10);
    
    label.frame = CGRectMake(0, 0, textSize.width + 5, textSize.height + 5);
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor whiteColor];
	label.font = font;
    label.text = _text;
	label.numberOfLines = 0;
    label.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
}
/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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

- (void) show: (NSString *) _text {
    if (_text) {
        self.text = _text;
    }else{
        _text = self.text;
    }

    [self textSet:_text];
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    [window addSubview:self.view];
    NSLog(@"show");
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:3.0];
    //[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
}

- (void) dismiss {
    [self.view removeFromSuperview];
}

@end
