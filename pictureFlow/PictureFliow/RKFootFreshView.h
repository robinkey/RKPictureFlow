//
//  RKFootFreshView.h
//  pictureFlow
//
//  Created by Robinkey on 12/28/12.
//  Copyright (c) 2012 Robinkey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RKFootFreshView : UIView
@property(nonatomic, readwrite) BOOL showActivityIndicator;
@property(nonatomic, readwrite, getter = isRefreshing) BOOL refreshing;
@property(nonatomic, readwrite) BOOL enabled;   // in case that no more items to load
@property(nonatomic, readwrite) UITextAlignment textAlignment;

@end
