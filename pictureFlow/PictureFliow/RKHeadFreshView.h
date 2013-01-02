//
//  RKHeadFreshView.h
//  pictureFlow
//
//  Created by Robinkey on 12/28/12.
//  Copyright (c) 2012 Robinkey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
	HeadRefreshPulling = 0,
	HeadRefreshNormal,
	HeadRefreshLoading,
} HeadRefreshState;

@protocol RKHeadFreshViewDelegate;
@interface RKHeadFreshView : UIView
{
	
	id _delegate;
	HeadRefreshState _state;
    
	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
	
}

@property(nonatomic,assign) id <RKHeadFreshViewDelegate> delegate;

- (void)refreshLastUpdatedDate;
- (void)headFreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)headFreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)headFreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end


#pragma -- 上拉刷新协议
@protocol RKHeadFreshViewDelegate
- (void)headFreshViewDidTriggerRefresh:(RKHeadFreshView *)view;
- (BOOL)headFreshViewDataSourceIsLoading:(RKHeadFreshView *)view;
@optional
- (NSDate*)headFreshViewDataSourceLastUpdated:(RKHeadFreshView *)view;
@end