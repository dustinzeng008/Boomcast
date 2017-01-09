//
//  YZBroadcastFrame.h
//  BoomCast
//
//  Created by Yong Zeng on 12/22/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import <Foundation/Foundation.h>

#define YZUSERNAMEFONT 15


#define YZUSERNAMEFONT 15
#define YZLOCATIONFONT 13
#define YZTITLEFONT 14
#define YZICONWIDTH 44

@class YZBroadcast;
@interface YZBroadcastFrame : NSObject

@property (nonatomic, strong) YZBroadcast * broadcast;

@property (nonatomic, assign, readonly) CGRect iconFrame;
@property (nonatomic, assign, readonly) CGRect userNameFrame;
@property (nonatomic, assign, readonly) CGRect locationFrame;
@property (nonatomic, assign, readonly) CGRect onlineNumberFrame;
@property (nonatomic, assign, readonly) CGRect titleFrame;
@property (nonatomic, assign, readonly) CGRect pictureFrame;

@property (nonatomic, assign, readonly) CGFloat rowHeight;

@end
