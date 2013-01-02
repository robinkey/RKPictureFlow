//
//  RKWaterFlowView.h
//  pictureFlow
//
//  Created by Robinkey on 12/28/12.
//  Copyright (c) 2012 Robinkey. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RKWaterflowView;

////TableCell for WaterFlow
@interface WaterFlowCell:UIView
{
    NSIndexPath *_indexPath;
    //
    NSString *_reuseIdentifier;
}

@property (nonatomic, retain) NSIndexPath *indexPath;
@property (nonatomic, retain) NSString *reuseIdentifier;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end

////DataSource and Delegate
@protocol RKWaterflowViewDatasource <NSObject>
@required
//return column number
- (NSInteger)numberOfColumnsInFlowView:(RKWaterflowView*)flowView;
//return the Row number in every column
- (NSInteger)flowView:(RKWaterflowView *)flowView numberOfRowsInColumn:(NSInteger)column;
//return the cell for row
- (WaterFlowCell *)flowView:(RKWaterflowView *)flowView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@protocol RKWaterflowViewDelegate <NSObject>
@required
//return the height for a row
- (CGFloat)flowView:(RKWaterflowView *)flowView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
@optional
- (void)flowView:(RKWaterflowView *)flowView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end

////Waterflow View
@interface RKWaterflowView : UIScrollView<UIScrollViewDelegate>
{
    //列数
    NSInteger numberOfColumns;
    NSInteger currentPage;
	
	NSMutableArray *_cellHeight;
	NSMutableArray *_visibleCells;
	NSMutableDictionary *_reusedCells;
	
	id <RKWaterflowViewDelegate> _flowdelegate;
    id <RKWaterflowViewDatasource> _flowdatasource;
}

- (void)reloadData;

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;

@property (nonatomic, retain) NSMutableArray *cellHeight; //array of cells height arrays, count = numberofcolumns, and elements in each single child array represents is a total height from this cell to the top
@property (nonatomic, retain) NSMutableArray *visibleCells;  //array of visible cell arrays, count = numberofcolumns
@property (nonatomic, retain) NSMutableDictionary *reusableCells;  //key- identifier, value- array of cells
@property (nonatomic, assign) id <RKWaterflowViewDelegate> flowdelegate;
@property (nonatomic, assign) id <RKWaterflowViewDatasource> flowdatasource;

@end
