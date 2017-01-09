//
//  YZLiveBottomToolView.m
//  BoomCast
//
//  Created by Yong Zeng on 12/17/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import "YZLiveBottomToolView.h"

@interface YZLiveBottomToolView()

@end

@implementation YZLiveBottomToolView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (NSArray *)tools{
    return @[@"btn_message", @"btn_overturn", @"btn_mute", @"btn_close"];
}

- (void)initViews{
    CGFloat margin = 10;
    CGFloat x = 10;
    CGFloat y = 0;
    for (int i = 0; i < self.tools.count; i++) {
        if (i == self.tools.count - 1) {
            x = KDeviceWidth - (margin + BOTTOMTOOL_BUTTON_SIZE);
        } else {
            x = margin + (margin + BOTTOMTOOL_BUTTON_SIZE) * i;
        }
        
        UIButton *toolButton = [UIButton buttonWithType:UIButtonTypeCustom];
        toolButton.frame = CGRectMake(x, y, BOTTOMTOOL_BUTTON_SIZE, BOTTOMTOOL_BUTTON_SIZE);
        toolButton.tag = i;
        [toolButton setImage:[UIImage imageNamed:self.tools[i]] forState:UIControlStateNormal];
        [toolButton addTarget:self action:@selector(bottonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:toolButton];
    }
}

- (void)bottonClick:(UIButton *)sender{
    if (self.clickBottomToolBlock) {
        self.clickBottomToolBlock(sender);
    }
}

- (void) hideBroadCasterButton{
    for (UIView *view in self.subviews){
        if([view isKindOfClass:[UIButton class]]){
            UIButton *button = (UIButton *)view;
            if(button.tag == YZLiveBottomToolTypeOverTurn ||
               button.tag == YZLiveBottomToolTypeMute){
                button.hidden = true;
            }
        }
    }
}


@end
