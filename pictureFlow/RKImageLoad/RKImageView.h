//
//  RKImageView.h
//  pictureFlow
//
//  Created by Robinkey on 12/28/12.
//  Copyright (c) 2012 Robinkey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface RKImageView : UIImageView<ASIHTTPRequestDelegate>
{
    
}
@property(nonatomic, retain) ASIHTTPRequest * request;
- (void) loadImage:(NSString*)imageURL;
- (void) loadImage:(NSString*)imageURL withPlaceholdImage:(UIImage*)image;
- (void) cancelDownload;
@end
