//
//  YZBaseSettingCell.m
//  BoomCast
//
//  Created by Yong Zeng on 11/27/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import "YZBaseSettingCell.h"
#import "YZBaseSettingItem.h"
#import "YZBaseSetting.h"

@interface YZBaseSettingCell()
@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UIImageView *checkView;
@property (nonatomic, strong) UISwitch *switchView;
//@property (nonatomic, strong) UIImageView *badgeView;
@property (nonatomic, strong) UILabel *labelView;
@end

@implementation YZBaseSettingCell

- (UIImageView *)arrowView{
    if (_arrowView == nil) {
        UIImageView *arrowView = [[UIImageView alloc]
                                  initWithImage:[UIImage renderImage:@"arrow_right"]];
        arrowView.tintColor = [UIColor colorFromHexCode:@"#E0E0E0"];
        _arrowView = arrowView;
    }
    return _arrowView;
}

- (UIImageView *)checkView{
    if (_checkView == nil) {
        UIImageView *checkView = [[UIImageView alloc]
                                  initWithImage:[UIImage imageNamed:@"check"]];
        _checkView = checkView;
    }
    return _checkView;
}

- (UISwitch *)switchView{
    if (_switchView == nil) {
        UISwitch *switchView = [[UISwitch alloc] init];
        _switchView = switchView;
    }
    return _switchView;
}

- (UILabel *)labelView{
    if (_labelView == nil) {
        _labelView = [[UILabel alloc] init];
        _labelView.textAlignment = NSTextAlignmentCenter;
        _labelView.textColor = [UIColor redColor];
    }
    return _labelView;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *reuseId = @"cell";
    YZBaseSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseId];
    }
    return cell;
}

- (void)setItem:(YZBaseSettingItem *)item{
    _item = item;
    [self setUpContent];
    [self setUpRightView];
    
    if ([_item isKindOfClass:[YZBaseSettingLabelItem class]]) {
        YZBaseSettingLabelItem *labelItem = (YZBaseSettingLabelItem *)_item;
        self.labelView.text = labelItem.text;
        [self addSubview:self.labelView];
    } else {
        [_labelView removeFromSuperview];
    }
}

- (void)setUpContent{
    self.textLabel.text = _item.title;
    self.detailTextLabel.text = _item.subTitle;
    self.imageView.image = _item.image;
}

- (void)setUpRightView{
    if ([_item isKindOfClass:[YZBaseSettingArrowItem class]]) {
        self.accessoryView = self.arrowView;
    } else if ([_item isKindOfClass:[YZBaseSettingSwitchItem class]]) {
        self.accessoryView = self.switchView;
    } else if ([_item isKindOfClass:[YZBaseSettingCheckItem class]]) {
        YZBaseSettingCheckItem *checkItem = (YZBaseSettingCheckItem *)_checkView;
        self.accessoryView = checkItem.check ? self.checkView:nil;
    } else if ([_item isKindOfClass:[YZBaseSettingBadgeItem class]]) {
        //YZBaseSettingBadgeItem *badgeItem = (YZBaseSettingBadgeItem *)_item;
    } else {
        self.accessoryView = nil;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.labelView.frame = self.bounds;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
