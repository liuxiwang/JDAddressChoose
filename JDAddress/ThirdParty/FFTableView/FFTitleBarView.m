//
//  FFTitleBarView.m
//  FFSelectViewProject
//
//  Created by ZhanyaaLi on 16/8/18.
//  Copyright © 2016年 FaceFace_Lilubin. All rights reserved.
//

#import "FFTitleBarView.h"

#define kHigher_iOS_8_4 (floor(NSFoundationVersionNumber) > (NSFoundationVersionNumber_iOS_8_4))
#define kFontPingFangMedium (kHigher_iOS_8_4 ? @"PingFangSC-Medium" : @"STHeitiSC-Medium")
#define kFontPingFangRegular (kHigher_iOS_8_4 ? @"PingFangSC-Regular" : @"STHeitiSC-Light")
#define kLearnCellDetailColor           [UIColor colorWithRed:(182.0 / 255.0) green:(182.0 / 255.0) blue:(182.0 / 255.0) alpha:1.0]
#define kAllPagesCustomeRedColor        [UIColor colorWithRed:(254.0 / 255.0) green:(56.0 / 255.0) blue:(36.0 / 255.0) alpha:1.0]      //所有界面的红色


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kBottomLineHeight 0.5
#define kSelLineWidth 40
#define kStartBtnTag 700

@interface FFTitleBarView ()
{
    UIView *_line;
}

@end

@implementation FFTitleBarView

- (instancetype)initWithFrame:(CGRect)frame andTitles:(NSArray *)titles
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _currentIndex = 0;
        _titleButtons = [NSMutableArray arrayWithCapacity:5];
        
        CGFloat btnWidth = frame.size.width * 1.0 / titles.count;
        CGFloat btnHeight = frame.size.height;
        
        [self setBackgroundColor:[UIColor whiteColor]];
        if (titles.count>5) {
            btnWidth = frame.size.width * 1.0 / 4.5;
        }
        
        [titles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.font = [UIFont fontWithName:kFontPingFangMedium size:15.0f];
            button.enabled = NO;
            button.hidden = YES;
            UIColor *bgColor = [UIColor whiteColor];
            [button setBackgroundColor:bgColor];
            [button setTitleColor:kLearnCellDetailColor forState:UIControlStateNormal];
            UIColor *selColor = kAllPagesCustomeRedColor;
            [button setTitleColor:selColor forState:UIControlStateSelected];
            [button setTitle:title forState:UIControlStateNormal];
            button.frame = CGRectMake(btnWidth * idx, 0, btnWidth, btnHeight);
            button.tag = idx + kStartBtnTag;
            [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
            if (idx == 0) {
                [button setTitleColor:selColor forState:UIControlStateNormal];
                button.enabled = YES;
                button.hidden = NO;
            }
            
            [_titleButtons addObject:button];
            [self addSubview:button];
            [self sendSubviewToBack:button]; //这个是做什么用的
        }];
        _currentIndex = 0;
        
        self.contentSize = CGSizeMake(frame.size.width, 25);
        self.showsHorizontalScrollIndicator = NO;
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - kBottomLineHeight, kScreenWidth, kBottomLineHeight)];
        [bottomLine setBackgroundColor:[UIColor colorWithRed:211.0 / 255.0 green:211.0 / 255.0 blue:211.0 / 255.0 alpha:1.0f]];
        [self addSubview:bottomLine];
        
        _line = [[UIView alloc] initWithFrame:CGRectMake(btnWidth / 2 - kSelLineWidth * 1.0 / 2, frame.size.height - kBottomLineHeight, kSelLineWidth, kBottomLineHeight)];
        [_line setBackgroundColor:kAllPagesCustomeRedColor];
        _line.tag = 1050;
        [self addSubview:_line];
        
        if (titles.count>5) {
            self.contentSize = CGSizeMake((frame.size.width/4.5)*6, 25);
            self.bounces=NO;
        }
    }
    return self;
}

- (void)onClick:(UIButton *)button
{
    if (_currentIndex != (button.tag - kStartBtnTag)) {
        UIButton *preTitle = _titleButtons[_currentIndex];
        [preTitle setTitleColor:kLearnCellDetailColor forState:UIControlStateNormal];
        [button setTitleColor:kAllPagesCustomeRedColor forState:UIControlStateNormal];
        _currentIndex = button.tag - kStartBtnTag;
        _titleButtonClicked(button.tag - kStartBtnTag);
    }
}

- (void)updateCurrentBtnTitle:(NSString *)title level:(NSUInteger)level {
    if (level >= _titleButtons.count) {
        return;
    }
    UIButton *btn = _titleButtons[level];
    [btn setTitle:title forState:UIControlStateNormal];
}

@end
