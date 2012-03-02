//
//  UIHudViewController.h
//  milan
//
//  Created by Wu Chang on 11-11-15.
//  Copyright 2011年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIHudViewController : UIViewController {
    NSString *text;
    IBOutlet UILabel *label;
}

@property (retain, nonatomic) NSString *text;
@property (retain, nonatomic) IBOutlet UILabel *label;

- (void) textSet:(NSString *) _text;
- (void) show: (NSString *) _text;
- (void) dismiss;

@end
