//
//  YZProfileCell.m
//  BoomCast
//
//  Created by Yong Zeng on 11/28/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import "YZProfileCell.h"

@implementation YZProfileCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.detailTextLabel.font = [UIFont systemFontOfSize:12];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.detailTextLabel.x  = CGRectGetMaxX(self.textLabel.frame) + 5;
}

@end
