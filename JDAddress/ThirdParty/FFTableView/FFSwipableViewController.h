//
//  FFSwipableViewController.h
//  FFSelectViewProject
//
//  Created by ZhanyaaLi on 16/8/18.
//  Copyright © 2016年 FaceFace_Lilubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FFTitleBarView;
@class FFHorizonalTableViewController;

@interface FFSwipableViewController : UIViewController

@property (nonatomic, strong) FFTitleBarView *titleBar; //title视图
@property (nonatomic, strong) FFHorizonalTableViewController *viewPager; //下面的子视图
@property (nonatomic , copy) void (^selectDoneAddress)(NSDictionary *address);

- (instancetype)initWithTitle:(NSString *)title andSubTitles:(NSArray *)subTitles;
- (void)scrollToViewAtIndex:(NSInteger)index; //滚动到指定视图

- (void)show;
@end
