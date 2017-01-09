//
//  YZBroadCastTableViewCell.m
//  BoomCast
//
//  Created by Yong Zeng on 12/22/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import "YZBroadCastTableViewCell.h"
#import "YZBroadcast.h"
#import "YZBroadcastFrame.h"

@interface YZBroadCastTableViewCell()

@property (nonatomic, weak) UIImageView* iconView;
@property (nonatomic, weak) UILabel* usernameView;
@property (nonatomic, weak) UILabel* locationView;
@property (nonatomic, weak) UILabel* onlineNumberView;
@property (nonatomic, weak) UILabel* titleView;
@property (nonatomic, weak) UIImageView* pictureView;

@end

@implementation YZBroadCastTableViewCell

+ (instancetype)broadcastCellWithTableView:(UITableView *)tableView{
    static NSString *reuseId = @"cell";
    YZBroadCastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell){
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        [cell setBackgroundColor:[UIColor whiteColor]];
    }
    return cell;
}

// overrite countructor, initialization (create customize child components inside the cell)
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        UIImageView *iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        self.iconView.layer.cornerRadius = YZICONWIDTH/2;
        self.iconView.layer.masksToBounds = YES;
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickIcon:)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        [self.iconView addGestureRecognizer:singleTap];
        [self.iconView setUserInteractionEnabled:YES];
        
        UILabel *usernameView = [[UILabel alloc] init];
        [self.contentView addSubview:usernameView];
        self.usernameView = usernameView;
        usernameView.font = [UIFont systemFontOfSize:YZUSERNAMEFONT];
        
        UILabel *locationView = [[UILabel alloc] init];
        [self.contentView addSubview:locationView];
        self.locationView = locationView;
        locationView.font = [UIFont systemFontOfSize:YZLOCATIONFONT];
        
        UILabel *onlineNumberView = [[UILabel alloc] init];
        [self.contentView addSubview:onlineNumberView];
        self.onlineNumberView = onlineNumberView;
        onlineNumberView.font = [UIFont systemFontOfSize:YZUSERNAMEFONT];
        onlineNumberView.textAlignment = NSTextAlignmentRight;
        onlineNumberView.textColor = [UIColor mainColor];
        
        UILabel *titleView = [[UILabel alloc] init];
        [self.contentView addSubview:titleView];
        self.titleView = titleView;
        titleView.font = [UIFont systemFontOfSize:YZTITLEFONT];
        
        UIImageView *pictureView = [[UIImageView alloc] init];
        [self.contentView addSubview:pictureView];
        self.pictureView = pictureView;
        pictureView.contentMode = UIViewContentModeScaleToFill;
    }
    return self;
}

- (void)clickIcon:(UIGestureRecognizer *)gestureRecognizer {
    if ([self.delegate respondsToSelector:@selector(clickProfileImage:)]) {
        [self.delegate clickProfileImage:self.broadcastFrame];
    }
}

- (void)setBroadcastFrame:(YZBroadcastFrame *)broadcastFrame{
    _broadcastFrame = broadcastFrame;
    // set component value
    [self setSubViewsContent];
    // set frame
    [self setSubViewsFrame];
}

- (void)setSubViewsContent{
    YZBroadcast *broadcast = self.broadcastFrame.broadcast;
    self.usernameView.text = [[broadcast user] username];
    self.locationView.text = [[broadcast user] location];
    self.onlineNumberView.text = [NSString stringWithFormat:@"live# %@", [broadcast.onlineNumber stringValue]];
    self.titleView.text = [broadcast title];
    if ([[broadcast user] profileImage] == nil) {
        self.pictureView.image = [UIImage imageNamed:@"empty_profile"];
        self.iconView.image = [UIImage imageNamed:@"empty_profile"];
    } else {
        self.pictureView.image = [[broadcast user] profileImage];
        self.iconView.image = [[broadcast user] profileImage];
    }
    
}

- (void)setSubViewsFrame{
    self.iconView.frame = self.broadcastFrame.iconFrame;
    self.usernameView.frame = self.broadcastFrame.userNameFrame;
    self.locationView.frame = self.broadcastFrame.locationFrame;
    self.onlineNumberView.frame = self.broadcastFrame.onlineNumberFrame;
    self.titleView.frame = self.broadcastFrame.titleFrame;
    self.pictureView.frame = self.broadcastFrame.pictureFrame;
}

@end
