//
//  FFTitleBarView.h
//  FFSelectViewProject
//
//  Created by ZhanyaaLi on 16/8/18.
//  Copyright © 2016年 FaceFace_Lilubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFTitleBarView : UIScrollView

@property (nonatomic, strong) NSMutableArray *titleButtons;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, copy) void (^titleButtonClicked)(NSInteger index);

- (instancetype)initWithFrame:(CGRect)frame andTitles:(NSArray *)titles;
- (void)updateCurrentBtnTitle:(NSString *)title level:(NSUInteger)level;

@end
