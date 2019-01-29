//
//  FFCell.h
//  FFSelectViewProject
//
//  Created by ZhanyaaLi on 16/8/19.
//  Copyright © 2016年 FaceFace_Lilubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void)setSelectedStatus:(BOOL)status;

@end
