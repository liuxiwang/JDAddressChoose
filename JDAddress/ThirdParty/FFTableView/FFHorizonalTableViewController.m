//
//  FFHorizonalTableViewController.m
//  FFSelectViewProject
//
//  Created by ZhanyaaLi on 16/8/18.
//  Copyright © 2016年 FaceFace_Lilubin. All rights reserved.
//

#import "FFHorizonalTableViewController.h"

@interface FFHorizonalTableViewController ()

@property (nonatomic, assign) BOOL btnHidden;

@end


static NSString *kHorizonalCellID = @"HorizonlCell";

@implementation FFHorizonalTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化self.tableView
    self.tableView = [UITableView new];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    self.tableView.scrollsToTop = NO;
    self.tableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.pagingEnabled = YES;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.bounces = NO;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kHorizonalCellID];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithViewControllers:(NSArray *)controllers
{
    self = [super init];
    if (self) {
        _controllers = controllers;
        for(UIViewController *controller in controllers)
        {
            [self addChildViewController:controller];
        }
    }
    return self;
}

- (void)scrollToViewAtIndex:(NSUInteger)index
{
    CGFloat horizonalOffset = self.tableView.contentOffset.y;
    CGFloat screenWidth = self.tableView.frame.size.width;
    CGFloat offsetRadio = (NSUInteger)horizonalOffset % (NSUInteger)screenWidth / screenWidth;
    NSUInteger focusIndex = (horizonalOffset + screenWidth / 2) / screenWidth;
    
    
    _scrollView(offsetRadio, focusIndex, index);
    
    //    DebugLog(@">>horizonalOffset:%f, focusIndex:%li, animateIndex:%li, offsetRadio:%f, ", horizonalOffset, focusIndex, index, offsetRadio);
    /*
     if (horizonalOffset != focusIndex * screenWidth || (int)offsetRadio == 0) {
     NSUInteger animationIndex = horizonalOffset >= focusIndex *screenWidth ? focusIndex + 1: focusIndex - 1;
     if (focusIndex > animationIndex) {
     offsetRadio = 1 - offsetRadio;
     }
     }
     */
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
    
    //这个block好像从来没有调用过，不知道是干什么用的
    if (_viewDidAppear) {
        _viewDidAppear(index);
    }
}

- (void)scrollToViewAtIndex:(NSUInteger)index hidBtn:(BOOL)hidden {
    CGFloat horizonalOffset = self.tableView.contentOffset.y;
    CGFloat screenWidth = self.tableView.frame.size.width;
    //    CGFloat offsetRadio = (NSUInteger)horizonalOffset % (NSUInteger)screenWidth / screenWidth;
    
    NSUInteger focusIndex = (horizonalOffset + screenWidth / 2) / screenWidth;
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    
    _scrollViewNew(hidden, focusIndex, index);
    
    //    _scrollView(0.5, focusIndex, index);
    //    DebugLog(@">>horizonalOffset:%f, focusIndex:%li, animateIndex:%li, offsetRadio:%f, ", horizonalOffset, focusIndex, index, offsetRadio);
    /*
     if (horizonalOffset != focusIndex * screenWidth || (int)offsetRadio == 0) {
     NSUInteger animationIndex = horizonalOffset >= focusIndex *screenWidth ? focusIndex + 1: focusIndex - 1;
     if (focusIndex > animationIndex) {
     offsetRadio = 1 - offsetRadio;
     }
     }
     */
    
    //    _changeIndex(index);
    
    if (_viewDidAppear) {
        _viewDidAppear(index);
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _controllers.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.frame.size.width;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kHorizonalCellID forIndexPath:indexPath];
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI_2);
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIViewController *controller = _controllers[indexPath.row];
    controller.view.frame = cell.contentView.bounds;
    [cell.contentView addSubview:controller.view];
    
    
    return cell;
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollStop:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self scrollStop:NO];
}


- (void)scrollStop:(BOOL)didScrollStop
{
    CGFloat horizonalOffset = self.tableView.contentOffset.y;
    CGFloat screenWidth = self.tableView.frame.size.width;
    CGFloat offsetRadio = (NSUInteger)horizonalOffset % (NSUInteger)screenWidth / screenWidth;
    NSUInteger focusIndex = (horizonalOffset + screenWidth / 2) / screenWidth;
    
    
    if (horizonalOffset != focusIndex * screenWidth || (int)offsetRadio == 0) {
        NSUInteger animationIndex = horizonalOffset >= focusIndex *screenWidth ? focusIndex + 1: focusIndex - 1;
        //        DebugLog(@">>horizonalOffset:%f, focusIndex:%li, animateIndex:%li, offsetRadio:%f, ", horizonalOffset, focusIndex, animationIndex, offsetRadio);
        if (focusIndex > animationIndex) {
            offsetRadio = 1 - offsetRadio;
        }
        /*
         *offsetRadio:偏移比例
         *focusIndex:当前页面
         *animationIndex:目标页面
         */
        //        _scrollView(offsetRadio, focusIndex, animationIndex);
    }
    
    if (didScrollStop) {
        //        _changeIndex(focusIndex);
    }
}

@end
