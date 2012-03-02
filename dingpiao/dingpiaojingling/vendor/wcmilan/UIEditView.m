//
//  UIEditView.m
//  milan
//
//  Created by Wu Chang on 11-11-16.
//  Copyright 2011年 Unique. All rights reserved.
//

#import "UIEditView.h"

@implementation UIEditView
@synthesize editDelegate, titleLabel, allData, allTextFields, key1,value1,save,cancel;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)initWithData:(NSDictionary *)data{
    self = [super init];
    if (self) {
        self.allData = data;
        self.allTextFields = [NSMutableDictionary dictionaryWithObjectsAndKeys: nil];
        self.frame = CGRectMake(10, 100, 300, 100);
        self.backgroundColor = [UIColor underPageBackgroundColor];
        CALayer *layer  = self.layer;
        layer.cornerRadius = 5;
        layer.borderColor = [UIColor whiteColor].CGColor;
        layer.borderWidth = 1.0f;
        layer.shadowColor = [UIColor blackColor].CGColor;
        layer.shadowOffset = CGSizeMake(0, 2);
        layer.shadowOpacity = 0.7;
        layer.shadowRadius = 3.0f;
        layer.masksToBounds = NO;
        layer.shouldRasterize = YES;
        layer.rasterizationScale = [[UIScreen mainScreen]scale];

        NSString *title = [[data allKeys] objectAtIndex:0];
        NSDictionary *keyValuePairs = [data objectForKey:title];
        for (int i = 0; i < keyValuePairs.count; i++) {
            [self setKey:title atIndex:i];
        }
        [self setTitle:title];
        [self setButton];
    }
    
    return self;
}

- (void)setTitle:(NSString *) text {
    if (!self.titleLabel) {
        self.titleLabel = [[UILabel alloc] init];
    }
    self.titleLabel.frame = CGRectMake(60, 10, 180, 30);
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.shadowColor = [UIColor whiteColor];
    self.titleLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.titleLabel.textAlignment = UITextAlignmentCenter;
    self.titleLabel.text = text;
    [self addSubview:self.titleLabel];
}

- (void)setKey:(NSString *) text atIndex:(int) index {
    NSDictionary *keyValue = [self.allData objectForKey:text];
    key1 = [[UILabel alloc] init];
    value1 = [[UITextField alloc] init];
    NSString *keyText = [[keyValue allKeys] objectAtIndex:index];
    NSString *valueText = [keyValue objectForKey:keyText];
    key1.backgroundColor = [UIColor clearColor];
    key1.textColor = [UIColor blackColor];
    key1.font = [UIFont boldSystemFontOfSize:15];
    key1.textAlignment = UITextAlignmentLeft;
    key1.text = keyText;
    value1.backgroundColor = [UIColor whiteColor];
    value1.layer.cornerRadius = 5;
    value1.text = valueText;
    key1.frame = CGRectMake(0, 35 + 15 + (25 + 10) * index , 75, 25);
    value1.frame = CGRectMake(85, 35 + 15 + (25 + 10) * index, 200, 25);
    self.frame = CGRectMake(10, 100, 300, 35 + 15 + (25 + 10) * index + 25 + 20);
    //self.contentSize = CGSizeMake(300, 35 + 15 + (25 + 10) * index + 25 + 20);
    [self addSubview:key1];
    [self addSubview:value1];
    [self.allTextFields setObject:value1 forKey:keyText];
}

- (void)setButton{
    save = [UIButton buttonWithType:UIButtonTypeCustom];
    save.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    save.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    save.titleLabel.textAlignment = UITextAlignmentCenter;
    save.layer.cornerRadius = 5;
    save.layer.masksToBounds = YES;
    save.frame = CGRectMake(5, 10, 60, 30);
    [save setTitle:@"save" forState:UIControlStateNormal];
    [save addTarget:self action:@selector(saveData) forControlEvents:UIControlEventTouchUpInside];
    cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    cancel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    cancel.titleLabel.textAlignment = UITextAlignmentCenter;
    cancel.layer.cornerRadius = 5;
    cancel.layer.masksToBounds = YES;
    cancel.frame = CGRectMake(235, 10, 60, 30);
    [cancel setTitle:@"cancel" forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancelData) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:save];
    [self addSubview:cancel];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panOnEdit:)];
    [self addGestureRecognizer:pan];
}

- (void) saveData{
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObjectsAndKeys: nil];
    for (NSString *key in [self.allTextFields allKeys]) {
        [data setObject:[[self.allTextFields objectForKey:key] text] forKey:key];
    }
    [self.editDelegate UIEditViewSaveData:[NSDictionary dictionaryWithDictionary:data]];
    [self dismiss];
}

- (void) cancelData{
    [self.editDelegate UIEditViewCancelData];
    [self dismiss];
}

- (void) dismiss{
    [self removeFromSuperview];
}

- (IBAction) panOnEdit: (UIPanGestureRecognizer *)gestureRecognizer {    
    UIView *piece = [gestureRecognizer view];
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gestureRecognizer translationInView:[piece superview]];
        
        [piece setCenter:CGPointMake([piece center].x + translation.x, [piece center].y + translation.y)];
        [gestureRecognizer setTranslation:CGPointZero inView:[piece superview]];
    }
}

- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *piece = gestureRecognizer.view;
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
        
        piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
        piece.center = locationInSuperview;
    }
}

@end
