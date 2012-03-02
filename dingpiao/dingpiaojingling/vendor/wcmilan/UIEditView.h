//
//  UIEditView.h
//  milan
//
//  Created by Wu Chang on 11-11-16.
//  Copyright 2011年 Unique. All rights reserved.
//

typedef enum {
    UIEditViewStyleCustom = 0,           // no style
    UIEditViewStyleOne,          // one 
    
    UIEditViewStyleTwo,
    UIEditViewStyleThree,
} UIEditViewStyle;

#import <UIKit/UIKit.h>

@class UIEditView;

@protocol UIEditViewDelegate
- (void) UIEditViewSaveData:(NSDictionary *) data;
- (void) UIEditViewCancelData;
@optional
@end

@interface UIEditView: UIScrollView <UIGestureRecognizerDelegate>

@property (retain, nonatomic) IBOutlet id <UIEditViewDelegate> editDelegate;
@property (retain, nonatomic) UIButton *save;
@property (retain, nonatomic) UIButton *cancel;
@property (retain, nonatomic) UILabel *titleLabel;
@property (retain, nonatomic) NSDictionary *allData;
@property (retain, nonatomic) NSMutableDictionary *allTextFields;
@property (retain, nonatomic) UILabel *key1;
@property (retain, nonatomic) UITextField *value1;

- (id)initWithData:(NSDictionary *) data;
- (void)setTitle:(NSString *) text;
- (void)setKey:(NSString *) text atIndex:(int) index;
- (void)setButton;
- (void) saveData;
- (void) cancelData;
- (void) dismiss;
- (IBAction) panOnEdit: (UIPanGestureRecognizer *)gestureRecognizer;
- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;

@end
