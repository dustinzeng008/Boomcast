//
//  YZSearchViewTableViewCell.m
//  BoomCast
//
//  Created by Yong Zeng on 1/8/17.
//  Copyright © 2017 Yong Zeng. All rights reserved.
//

#import "YZSearchViewTableViewCell.h"

@implementation YZSearchViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(15, 10, 44, 44);
    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.origin.x = CGRectGetMaxX(self.imageView.frame) + 10;
    self.textLabel.frame = textLabelFrame;
    
    CGRect detailTextLabelFrame = self.detailTextLabel.frame;
    detailTextLabelFrame.origin.x = CGRectGetMaxX(self.imageView.frame) + 10;
    self.detailTextLabel.frame = detailTextLabelFrame;
}

@end
