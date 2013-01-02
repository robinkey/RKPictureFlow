//
//  ViewController.h
//  pictureFlow
//
//  Created by Robinkey on 12/28/12.
//  Copyright (c) 2012 Robinkey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RKWaterflowView.h"

@interface ViewController : UIViewController<RKWaterflowViewDelegate,RKWaterflowViewDatasource,UIScrollViewDelegate>
{
    int count;
    //瀑布流成员变量
    RKWaterflowView *flowView;
}
@end
