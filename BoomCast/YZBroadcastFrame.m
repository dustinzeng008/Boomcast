//
//  YZBroadcastFrame.m
//  BoomCast
//
//  Created by Yong Zeng on 12/22/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import "YZBroadcastFrame.h"
#import "YZBroadcast.h"

@implementation YZBroadcastFrame

- (void)setBroadcast:(YZBroadcast *)broadcast{
    _broadcast = broadcast;
    
    CGFloat margin = 10;
    // iconFrame
    CGFloat iconW = YZICONWIDTH;
    CGFloat iconH = YZICONWIDTH;
    CGFloat iconX = margin;
    CGFloat iconY = margin;
    _iconFrame = CGRectMake(iconX, iconY, iconW, iconH);
    
    //userNameFrame
    CGSize userNameSize = [NSString sizeWithText:[[_broadcast user] username]
                                     maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                    fontSize:YZUSERNAMEFONT];
    CGFloat userNameX = CGRectGetMaxX(_iconFrame) + margin;
    CGFloat userNameY = iconY;
    _userNameFrame = CGRectMake(userNameX, userNameY, userNameSize.width, userNameSize.height);
    
    
    //locationFrame
    CGSize locationSize = [NSString sizeWithText:[[_broadcast user] location]
                                         maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                        fontSize:YZUSERNAMEFONT];
    CGFloat locationX = CGRectGetMaxX(_iconFrame) + margin;
    CGFloat locationY = CGRectGetMaxY(_userNameFrame) + margin;
    _locationFrame = CGRectMake(locationX, locationY, locationSize.width, locationSize.height);
    
    
    //onlineNumber Frame
    CGSize onlineNumberSize = [NSString sizeWithText: [NSString stringWithFormat:@"live# %@",
                                                       [broadcast.onlineNumber stringValue]]
                                             maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                            fontSize:YZUSERNAMEFONT];
    CGFloat onlineNumberX = KDeviceWidth/2 + margin;
    CGFloat onlineNumberY = CGRectGetMaxY(_userNameFrame) + margin;
    _onlineNumberFrame = CGRectMake(onlineNumberX, onlineNumberY,
                                    KDeviceWidth/2 - margin*2, onlineNumberSize.height);
    
    
    //Title Frame
    CGSize titleSize = [NSString sizeWithText:[_broadcast title]
                                      maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                     fontSize:YZTITLEFONT];
    CGFloat textX = iconX;
    CGFloat textY = CGRectGetMaxX(_iconFrame) + margin;
    _titleFrame = CGRectMake(textX, textY, titleSize.width, titleSize.height);
    
    // Picture Frame
    CGFloat pictureW = KDeviceWidth;
    CGFloat pictureH = KDeviceWidth;
    CGFloat pictureX = 0;
    CGFloat pictureY = CGRectGetMaxY(_titleFrame) + margin;
    _pictureFrame = CGRectMake(pictureX, pictureY, pictureW, pictureH);
    
    
    
    _rowHeight = CGRectGetMaxY(_pictureFrame)+ margin;
}

@end
