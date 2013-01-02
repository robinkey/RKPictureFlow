//
//  RKImageView.m
//  pictureFlow
//
//  Created by Robinkey on 12/28/12.
//  Copyright (c) 2012 Robinkey. All rights reserved.
//

#import "RKImageView.h"
#import "RKWebDataLoad.h"

@interface RKImageView()
- (void) downloadImage:(NSString*)imageURL;
@end

@implementation RKImageView
@synthesize request = _request;

- (void) dealloc {
	self.request.delegate = nil;
    [self cancelDownload];
    [super dealloc];
}

- (void) loadImage:(NSString*)imageURL {
    [self loadImage:imageURL withPlaceholdImage:nil];
}

- (void) loadImage:(NSString*)imageURL withPlaceholdImage:(UIImage *)placeholdImage {
    self.image = placeholdImage;
    
    /*
     UIImage *image = [[FullyLoaded sharedFullyLoaded] imageForURL:imageURL];
     if (image)
     self.image = image;
     else
     [self downloadImage:imageURL];
     */
 /*
    GCD里就有三种queue
    1. Main queue：
    顾名思义,运行在主线程,由dispatch_get_main_queue获得.和ui相关的就要使用Main Queue.
    2.Serial quque(private dispatch queue)
    　　每次运行一个任务,可以添加多个,执行次序FIFO. 通常是指程序员生成的
    3.Concurrent queue(global dispatch queue):
    可以同时运行多个任务,每个任务的启动时间是按照加入queue的顺序,结束的顺序依赖各自的任务.使用dispatch_get_global_queue获得
    -->使用GCD的大致框架
    dispatch_async(getDataQueue,^{
        //获取数据,获得一组后,刷新UI.
        dispatch_aysnc (mainQueue, ^{
        //UI的更新需在主线程中进行
    };})
    */
    //获得数据队列queue
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    //dispatch_async表示异步，除了async,还有sync,delay
    //dispatch_async会向queue队列中添加新的任务去执行
    dispatch_async(queue, ^{
        //从单例的缓存数组中判断是否有此次图片的缓存，有的话返回nil，无的话返回image
        UIImage *image = [[RKWebDataLoad sharedRKWebDataLoad] imageForURL:imageURL];
        dispatch_sync(dispatch_get_main_queue(), ^{
            //每次下载完一张图片之后，在主线程中更新UI
            if (image)
                self.image = image;
            else
                [self downloadImage:imageURL];
        });
    });
    
}

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

- (void) cancelDownload {
    [self.request cancel];
    self.request = nil;
}

#pragma mark -
#pragma mark private downloads

- (void) downloadImage:(NSString *)imageURL {
    [self cancelDownload];
    //对中文转码
	NSString * newImageURL = [imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:newImageURL]];
    //setDownloadDestinationPath:设置下载路径
    [self.request setDownloadDestinationPath:[[RKWebDataLoad sharedRKWebDataLoad] pathForImageURL:imageURL]];
    [self.request setDelegate:self];
    //用block方法写的下载失败时候的回调函数
    [self.request setFailedBlock:^(void){
        [self.request cancel];
        self.request.delegate = nil;
        self.request = nil;
        
        NSLog(@"async image download failed");
    }];
    [self.request startAsynchronous];
    //	NSLog(@"download Image %@", imageURL);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

/*
 - (void) requestFinished:(ASIHTTPRequest *)request
 {
 self.request.delegate = nil;
 self.request = nil;
 
 NSLog(@"async image download done");
 
 NSString * imageURL = [[request.originalURL absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
 
 dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
 dispatch_async(queue, ^{
 UIImage *image = [[FullyLoaded sharedFullyLoaded] imageForURL:imageURL];
 dispatch_sync(dispatch_get_main_queue(), ^{
 self.image = image;
 });
 });
 
 
 //    NSString * imageURL = [[request.originalURL absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
 //    UIImage * image = [[FullyLoaded sharedFullyLoaded] imageForURL:imageURL];
 //    [self performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
 
 }
 
 
 - (void) requestFailed:(ASIHTTPRequest *)request
 {
 [self.request cancel];
 self.request.delegate = nil;
 self.request = nil;
 
 NSLog(@"async image download failed");
 }
 */


@end
