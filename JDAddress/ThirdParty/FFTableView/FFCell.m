//
//  FFCell.m
//  FFSelectViewProject
//
//  Created by ZhanyaaLi on 16/8/19.
//  Copyright © 2016年 FaceFace_Lilubin. All rights reserved.
//

#import "FFCell.h"

@interface FFCell ()

@property (weak, nonatomic) IBOutlet UIButton *selBtn;


@end

@implementation FFCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSelectedStatus:(BOOL)status {
    [_selBtn setSelected:status];
    [_titleLabel setTextColor:status ? [UIColor colorWithRed:(254.0 / 255.0) green:(56.0 / 255.0) blue:(36.0 / 255.0) alpha:1.0] : [UIColor colorWithRed:(182.0 / 255.0) green:(182.0 / 255.0) blue:(182.0 / 255.0) alpha:1.0]];
}

@end
