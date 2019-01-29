//
//  FFHorizonalTableViewController.h
//  FFSelectViewProject
//
//  Created by ZhanyaaLi on 16/8/18.
//  Copyright © 2016年 FaceFace_Lilubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFHorizonalTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *controllers;
@property (nonatomic, copy) void (^changeIndex)(NSUInteger index);
@property (nonatomic, copy) void (^scrollView)(CGFloat offsetRation, NSUInteger foucsIndex, NSUInteger animationIndex);
@property (nonatomic, copy) void (^scrollViewNew)(BOOL hidden, NSUInteger foucsIndex, NSUInteger animationIndex);
@property (nonatomic, copy) void (^viewDidAppear)(NSUInteger index);

- (instancetype)initWithViewControllers:(NSArray *)controllers;

- (void)scrollToViewAtIndex:(NSUInteger)index;

- (void)scrollToViewAtIndex:(NSUInteger)index hidBtn:(BOOL)hidden;


@end
