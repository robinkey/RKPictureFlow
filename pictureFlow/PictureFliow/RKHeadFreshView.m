//
//  RKHeadFreshView.m
//  pictureFlow
//
//  Created by Robinkey on 12/28/12.
//  Copyright (c) 2012 Robinkey. All rights reserved.
//

#import "RKHeadFreshView.h"

#define TEXT_COLOR [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f

@interface RKHeadFreshView (Private)
- (void)setState:(HeadRefreshState)aState;
@end

@implementation RKHeadFreshView
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:12.0f];
		label.textColor = textColor;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_lastUpdatedLabel=label;
		[label release];
        
		label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:13.0f];
		label.textColor = textColor;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		[label release];
        
		CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(25.0f, frame.size.height - 65.0f, 30.0f, 55.0f);
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:arrow].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
        
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
        
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
		[view release];
        
        
		[self setState:HeadRefreshNormal];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame  {
    return [self initWithFrame:frame arrowImageName:@"blueArrow.png" textColor:TEXT_COLOR];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


#pragma mark -
#pragma mark Setters
//得到上次更新时间
- (void)refreshLastUpdatedDate {
    
	if ([_delegate respondsToSelector:@selector(headFreshViewDataSourceLastUpdated:)]) {
        
		NSDate *date = [_delegate headFreshViewDataSourceLastUpdated:self];
        
		[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        
		_lastUpdatedLabel.text = [NSString stringWithFormat:@"Last Updated: %@", [dateFormatter stringFromDate:date]];
		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
        
	} else {
        
		_lastUpdatedLabel.text = nil;
        
	}
    
}
//设置控件状态
- (void)setState:(HeadRefreshState)aState{
    
	switch (aState) {
		case HeadRefreshPulling:
            
			_statusLabel.text = NSLocalizedString(@"松开刷新...", @"松开更新状态");
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
            
			break;
		case HeadRefreshNormal:
            
			if (_state == HeadRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
            
			_statusLabel.text = NSLocalizedString(@"下拉刷新...", @"下拉更新状态");
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
            
			[self refreshLastUpdatedDate];
            
			break;
		case HeadRefreshLoading:
            
			_statusLabel.text = NSLocalizedString(@"正在加载...", @"正在加载状态");
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = YES;
			[CATransaction commit];
            
			break;
		default:
			break;
	}
    
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods
//开始滚动时的监听方法
- (void)headFreshScrollViewDidScroll:(UIScrollView *)scrollView {
    
	if (_state == HeadRefreshLoading) {
        
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 60);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
        
	} else if (scrollView.isDragging) {
        
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(headFreshViewDataSourceIsLoading:)]) {
			_loading = [_delegate headFreshViewDataSourceIsLoading:self];
		}
        
		if (_state == HeadRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_loading) {
			[self setState:HeadRefreshNormal];
		} else if (_state == HeadRefreshNormal && scrollView.contentOffset.y < -65.0f && !_loading) {
			[self setState:HeadRefreshPulling];
		}
        
		if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
        
	}
    
}
//拖拽结束时的监听方法
- (void)headFreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
    
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(headFreshViewDataSourceIsLoading:)]) {
		_loading = [_delegate headFreshViewDataSourceIsLoading:self];
	}
    //y轴偏移量小于-65则开始加载
	if (scrollView.contentOffset.y <= - 65.0f && !_loading) {
        
		if ([_delegate respondsToSelector:@selector(headFreshViewDidTriggerRefresh:)]) {
			[_delegate headFreshViewDidTriggerRefresh:self];
		}
        
		[self setState:HeadRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
        
	}
    
}

- (void)headFreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
    
	[self setState:HeadRefreshNormal];
    
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
    
	_delegate=nil;
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
    [super dealloc];
}



@end
