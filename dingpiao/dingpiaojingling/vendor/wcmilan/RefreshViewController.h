//
//  RefreshViewController.h
//  milan
//
//  Created by Wu Chang on 11-9-15.
//  Copyright 2011年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefreshViewController : UIViewController <UIScrollViewDelegate>{
    UIScrollView *_scrollView;
    UIView *refreshHeaderView;
    UIView *refreshFooterView;
    UILabel *refreshLabel;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    UILabel *refreshFooterLabel;
    UIImageView *refreshFooterArrow;
    UIActivityIndicatorView *refreshFooterSpinner;
    BOOL isDragging;
    BOOL isLoading;
    BOOL isUpdating;
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;
    NSString *textPullFooter;
    NSString *textReleaseFooter;
    NSString *textLoadingFooter;
}

@property (nonatomic, retain) UIScrollView *_scrollView;
@property (nonatomic, retain) UIView *refreshHeaderView;
@property (nonatomic, retain) UIView *refreshFooterView;
@property (nonatomic, retain) UILabel *refreshLabel;
@property (nonatomic, retain) UIImageView *refreshArrow;
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, retain) UILabel *refreshFooterLabel;
@property (nonatomic, retain) UIImageView *refreshFooterArrow;
@property (nonatomic, retain) UIActivityIndicatorView *refreshFooterSpinner;
@property (nonatomic, copy) NSString *textPull;
@property (nonatomic, copy) NSString *textRelease;
@property (nonatomic, copy) NSString *textLoading;
@property (nonatomic, copy) NSString *textPullFooter;
@property (nonatomic, copy) NSString *textReleaseFooter;
@property (nonatomic, copy) NSString *textLoadingFooter;

- (void)_viewInit;
- (void)setupStrings;
- (void)relocateFooter;
- (void)addPullToRefreshHeader;
- (void)startUpdating;
- (void)startLoading;
- (void)stopUpdating;
- (void)stopLoading;
- (void)updateMore;
- (void)loadMore;

@end
