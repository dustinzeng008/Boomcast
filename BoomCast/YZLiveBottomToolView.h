//
//  YZLiveBottomToolView.h
//  BoomCast
//
//  Created by Yong Zeng on 12/17/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BOTTOMTOOL_BUTTON_SIZE 54

typedef NS_ENUM(NSUInteger, YZLiveBottomToolType) {
    YZLiveBottomToolTypeMessage,
    YZLiveBottomToolTypeOverTurn,
    YZLiveBottomToolTypeMute,
    YZLiveBottomToolTypeClose
};

@interface YZLiveBottomToolView : UIView

// When click button
@property(nonatomic, copy) void (^clickBottomToolBlock) (UIButton *sender);

- (void) hideBroadCasterButton;

@end


