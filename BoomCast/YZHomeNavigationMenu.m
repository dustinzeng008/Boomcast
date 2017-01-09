//
//  YZHomeNavigationMenu.m
//  BoomCast
//
//  Created by Yong Zeng on 12/20/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import "YZHomeNavigationMenu.h"

@interface YZHomeNavigationMenu()

@property (nonatomic, weak) UIView *underLine;
@property (nonatomic, weak) UIButton *hottestBtn;

@end

@implementation YZHomeNavigationMenu

- (UIView *)underLine
{
    if (!_underLine) {
        UIView *underLine = [[UIView alloc] initWithFrame:CGRectMake(0, MENUITEMHEIGHT +4,
                                                                     MENUITEMWIDTH, 2)];
        underLine.backgroundColor = [UIColor whiteColor];
        [self addSubview:underLine];
        _underLine = underLine;
    }
    return _underLine;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initViews];
    }
    return self;
}

- (void)initViews{
    UIButton *hottestBtn = [self createMenuItem:@"Hottest" tag:HomeNavigationMenuTypeHottest];
    UIButton *newestBtn = [self createMenuItem:@"Newest" tag:HomeNavigationMenuTypeNewest];
    UIButton *followBtn = [self createMenuItem:@"Follow" tag:HomeNavigationMenuTypeFollow];
    [self addSubview:hottestBtn];
    [self addSubview:newestBtn];
    [self addSubview:followBtn];
    _hottestBtn = hottestBtn;
    
    [self layoutIfNeeded];
    [self clickMenuItem:hottestBtn];
}


- (UIButton *)createMenuItem:(NSString *)title tag:(HomeNavigationMenuType)tag{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(MENUITEMWIDTH *tag,
                                                               0, MENUITEMWIDTH, MENUITEMHEIGHT)];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    btn.tag = tag;
    [btn addTarget:self action:@selector(clickMenuItem:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)setSelectedItemType:(HomeNavigationMenuType)selectedItemType{
    _selectedItemType = selectedItemType;
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]){
            UIButton *button = (UIButton *)view;
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            if (button.tag == selectedItemType) {
                button.selected = YES;
                button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
            }
        }
    }
}

- (void)clickMenuItem:(UIButton *)button{
    button.selected = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.underLine.x = button.x;
    }];
    
    if (self.selectedBlock) {
        self.selectedBlock(button.tag);
    }
}

@end
