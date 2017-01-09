//
//  YZLiveRoomViewController.h
//  BroadCast
//
//  Created by Yong Zeng on 12/3/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>
#import "YZBroadcast.h"

@class YZLiveRoomViewController;
@protocol YZLiveRoomVCDelegate <NSObject>
- (void)liveVCNeedClose:(YZLiveRoomViewController *)liveVC;
@end

@interface YZLiveRoomViewController : UIViewController

@property (strong, nonatomic) YZBroadcast *broadcast;
@property (copy, nonatomic) NSString *userName;
@property (copy, nonatomic) NSString *broadcastTitle;
//@property (copy, nonatomic) NSString *userPassword;
@property (assign, nonatomic) AgoraRtcClientRole clientRole;
@property (assign, nonatomic) AgoraRtcVideoProfile videoProfile;

@property (weak, nonatomic) id<YZLiveRoomVCDelegate> delegate;

@end
