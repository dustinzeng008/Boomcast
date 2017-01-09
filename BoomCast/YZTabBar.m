//
//  YZTabBar.m
//  BoomCast
//
//  Created by Yong Zeng on 11/26/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import "YZTabBar.h"
#import "UIColor+color.h"
#import "UIImage+Image.h"

@interface YZTabBar()
@property (nonatomic, weak) UIButton *plusButton;
@end

@implementation YZTabBar

- (UIButton *)plusButton{
    if (_plusButton == nil) {
        UIButton *plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [plusButton setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
        [plusButton setBackgroundImage:[UIImage imageFromColor:
                                 [UIColor turquoiseColor]]
                       forState:UIControlStateNormal];
        [plusButton setBackgroundImage:[UIImage imageFromColor:
                                 [UIColor greenSeaColor]]
                       forState:UIControlStateHighlighted];
        [plusButton setTintColor:[UIColor cloudsColor]];
        [plusButton sizeToFit];
        _plusButton = plusButton;
        [self addSubview:_plusButton];
        [plusButton addTarget:self action:@selector(clickPlusBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _plusButton;
}

- (void)clickPlusBtn
{
    if ([_tabBarDelegate respondsToSelector:@selector(tabBarDidClickPlusBtn:)]) {
        [_tabBarDelegate tabBarDidClickPlusBtn:self];
    }
}

// adjust child component's position
- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat tabBarWidth = self.bounds.size.width;
    CGFloat tabBarHeight = self.bounds.size.height;
    
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnW = tabBarWidth / (self.items.count + 1);
    CGFloat btnH = tabBarHeight;
    
    int i = 0;
    for (UIView *tabBarButton in self.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            if (i == 1) {
                i = 2;
            }
            btnX = btnW * i;
            tabBarButton.frame = CGRectMake(btnX, btnY, btnW, btnH);
            i++;
        }
    }
    
    CGPoint center = CGPointMake(tabBarWidth * 0.5, tabBarHeight * 0.5);
    center.y = center.y - 5;
    self.plusButton.frame = CGRectMake(center.x - (btnH+5)/2, center.y- (btnH+5)/2, btnH+5, btnH + 5);
    self.plusButton.layer.cornerRadius = self.plusButton.frame.size.height/2;
    self.plusButton.layer.masksToBounds = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
