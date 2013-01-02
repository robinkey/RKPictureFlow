//
//  ViewController.m
//  pictureFlow
//
//  Created by Robinkey on 12/28/12.
//  Copyright (c) 2012 Robinkey. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"
#import "RKImageView.h"
//列数宏定义
#define NUMBER_OF_COLUMNS 2

@interface ViewController ()
@property (nonatomic,retain) NSMutableArray *imageUrls;
@property (nonatomic,readwrite) int currentPage;
@end

@implementation ViewController
@synthesize imageUrls=_imageUrls;
@synthesize currentPage=_currentPage;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    flowView = [[RKWaterflowView alloc] initWithFrame:self.view.frame];
    //NSLog(@"%f,%f,%f,%f",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.height,self.view.frame.size.width);
    flowView.flowdatasource = self;
    flowView.flowdelegate = self;
    [self.view addSubview:flowView];
    
    self.currentPage = 1;
    
    self.imageUrls = [NSMutableArray array];
    self.imageUrls = [NSArray arrayWithObjects:
                      @"http://d2.freep.cn/3tb_13010112152361wt493254.png",
                      @"http://d2.freep.cn/3tb_130101121522fy5g493254.png",
                      @"http://d3.freep.cn/3tb_1301011215214ua7493254.png",
                      @"http://d2.freep.cn/3tb_130101121520rcjv493254.png",
                      @"http://d2.freep.cn/3tb_130101121519dy03493254.png",
                      @"http://d1.freep.cn/3tb_130101121518m6mr493254.png",
                      @"http://d1.freep.cn/3tb_130101121517okjo493254.png",
                      @"http://d3.freep.cn/3tb_130101121516sp7b493254.png",
                      @"http://d2.freep.cn/3tb_130101121515afe1493254.png",
                      @"http://d3.freep.cn/3tb_130101121513y0m6493254.png",
                      nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.imageUrls = nil;
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [flowView reloadData];  //safer to do it here, in case it may delay viewDidLoad
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}
#pragma mark-
#pragma mark- WaterflowDataSource

- (NSInteger)numberOfColumnsInFlowView:(RKWaterflowView *)flowView
{
    return NUMBER_OF_COLUMNS;
}

- (NSInteger)flowView:(RKWaterflowView *)flowView numberOfRowsInColumn:(NSInteger)column
{
    //每次刷新几行
    return 6;
}
//未调用
- (WaterFlowCell *)flowView:(RKWaterflowView *)flowView_ cellForRowAtIndex:(NSInteger)index
{
    static NSString *CellIdentifier = @"Cell";
	WaterFlowCell *cell = [flowView_ dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if(cell == nil)
	{
		cell  = [[[WaterFlowCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
		
		RKImageView *imageView = [[RKImageView alloc] initWithFrame:CGRectZero];
		[cell addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleToFill;
		imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
		imageView.layer.borderWidth = 1;
		[imageView release];
		imageView.tag = 1001;
	}
    
    float height = [self flowView:nil heightForCellAtIndex:index];
    
    RKImageView *imageView  = (RKImageView *)[cell viewWithTag:1001];
    NSLog(@"%f",self.view.frame.size.width);
    NSLog(@"%f",self.view.frame.size.width / NUMBER_OF_COLUMNS);
    //此处控制列宽（注意与上对应）
	imageView.frame = CGRectMake(0, 0, self.view.frame.size.width / NUMBER_OF_COLUMNS, height);
    int devNum = 1;
    if ([self.imageUrls count]) {
        devNum = [self.imageUrls count];
    }
    [imageView loadImage:[self.imageUrls objectAtIndex:index % devNum]];
	
	return cell;
    
}

- (WaterFlowCell*)flowView:(RKWaterflowView *)flowView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
	WaterFlowCell *cell = [flowView_ dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if(cell == nil)
	{
		cell  = [[[WaterFlowCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
		
		RKImageView *imageView = [[RKImageView alloc] initWithFrame:CGRectZero];
		[cell addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleToFill;
		imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
		imageView.layer.borderWidth = 1;
		[imageView release];
		imageView.tag = 1001;
	}
	
	float height = [self flowView:nil heightForRowAtIndexPath:indexPath];
	
	RKImageView *imageView  = (RKImageView *)[cell viewWithTag:1001];
    NSLog(@"%f",self.view.frame.size.width);
    NSLog(@"%f",self.view.frame.size.width / NUMBER_OF_COLUMNS);
	imageView.frame = CGRectMake(0, 0, self.view.frame.size.width / NUMBER_OF_COLUMNS - 10, height);
    int devNum = 1;
    if ([self.imageUrls count]) {
        devNum = [self.imageUrls count];
    }
    [imageView loadImage:[self.imageUrls objectAtIndex:(indexPath.row + indexPath.section) % devNum]];
	
	return cell;
    
}

#pragma mark-
#pragma mark- WaterflowDelegate
//返回瀑布流中图片高度的函数
- (CGFloat)flowView:(RKWaterflowView *)flowView heightForCellAtIndex:(NSInteger)index
{
    float height = 0;
	switch (index  % 5) {
		case 0:
			height = 167;
			break;
		case 1:
			height = 130;
			break;
		case 2:
			height = 187;
			break;
		case 3:
			height = 414;
			break;
		case 4:
			height = 460;
			break;
		case 5:
			height = 208;
			break;
		default:
			break;
	}
	
	return height;
}
//返回瀑布流中图片高度的函数
-(CGFloat)flowView:(RKWaterflowView *)flowView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	float height = 0;
	switch ((indexPath.row + indexPath.section )  % 5) {
		case 0:
			height = 167;
			break;
		case 1:
			height = 130;
			break;
		case 2:
			height = 187;
			break;
		case 3:
			height = 414;
			break;
		case 4:
			height = 460;
			break;
		case 5:
			height = 208;
			break;
		default:
			break;
	}
	
	height += indexPath.row + indexPath.section;
	
	return height;
    
}

//- (void)flowView:(WaterflowView *)flowView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"did select at %@",indexPath);
//}

//- (void)flowView:(WaterflowView *)flowView didSelectAtCell:(WaterFlowCell *)cell ForIndex:(int)index
//{
//
//}

- (void)flowView:(RKWaterflowView *)_flowView willLoadData:(int)page
{
    [flowView reloadData];
}

@end
