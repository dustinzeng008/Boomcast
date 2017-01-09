//
//  YZLiveRoomTableViewCell.m
//  BoomCast
//
//  Created by Yong Zeng on 12/28/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import "YZLiveRoomTableViewCell.h"
#import <TTTAttributedLabel.h>

#define YZFontSize 18

@interface YZLiveRoomTableViewCell()<TTTAttributedLabelDelegate>
@property (nonatomic, weak) TTTAttributedLabel *messageLabel;
@end

@implementation YZLiveRoomTableViewCell

+ (instancetype) cellWithTableView:(UITableView *)tableView{
    static NSString *reuseId = @"cell";
    YZLiveRoomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil){
        cell = [[YZLiveRoomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        //Message`
        TTTAttributedLabel *messageLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _messageLabel = messageLabel;
        [self.contentView addSubview:messageLabel];
        messageLabel.font = [UIFont systemFontOfSize: YZFontSize];
        //messageLabel.textAlignment = NSTextAlignmentLeft;
        messageLabel.textColor = [UIColor colorWithRed: 0.44 green: 0.68 blue: 0.87 alpha: 1.0];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.shadowOffset = CGSizeMake(0, 1);
        messageLabel.shadowColor = [UIColor colorWithRed: 0.09 green: 0.28 blue: 0.42 alpha: 1.0];
        messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        messageLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        messageLabel.linkAttributes = [self getLinkAttributes];
        messageLabel.activeLinkAttributes = [self getActiveLinkAttributes];
        messageLabel.delegate = self;
    }
    return self;
}

- (void)createAttributedLabel{
    
}

- (NSDictionary *)getLinkAttributes{
    NSMutableDictionary *mutableActiveLinkAttributes = [NSMutableDictionary dictionary];
    
    [mutableActiveLinkAttributes setValue: [UIFont boldSystemFontOfSize: 15]
                                   forKey: (NSString *) kCTFontAttributeName];
    
    [mutableActiveLinkAttributes setValue: [NSNumber numberWithBool: NO]
                                   forKey: (NSString *) kCTUnderlineStyleAttributeName];
    
    return [NSDictionary dictionaryWithDictionary: mutableActiveLinkAttributes];
}

- (NSDictionary *)getActiveLinkAttributes{
    NSMutableDictionary *mutableActiveLinkAttributes = [NSMutableDictionary dictionary];
    [mutableActiveLinkAttributes setValue: [NSNumber numberWithBool: YES]
                                   forKey: (NSString *) kCTUnderlineStyleAttributeName];
    
    return [NSDictionary dictionaryWithDictionary: mutableActiveLinkAttributes];
}

#pragma mark - TTTAttributedLabelDelegate
- (void) attributedLabel: (TTTAttributedLabel *)label
didSelectLinkWithAddress: (NSDictionary *)addressComponents
{
    YZLog(@"UserName clicked\nAddress:\t%@", addressComponents);
}

- (void)setChatRoomMessage:(YZChatRoomMessage *)chatRoomMessage{
    _chatRoomMessage = chatRoomMessage;
    
    NSString *message = [NSString stringWithFormat: @"%@: %@", chatRoomMessage.user.username, chatRoomMessage.message];
    NSRange userNameRange = [message rangeOfString: chatRoomMessage.user.username];
    [self.messageLabel setText:message];
    
    [self.messageLabel addLinkToAddress: @{ @"username" : chatRoomMessage.user.username,
                                            @"message" : chatRoomMessage.message }
                              withRange: userNameRange];
    
    CGSize messageSize = [NSString sizeWithText:message
                                        maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                       fontSize:YZFontSize];
    self.messageLabel.frame = CGRectMake(0, 0, self.contentView.size.width, messageSize.height);
    self.messageLabel.backgroundColor = [UIColor blueColor];
}

+ (CGFloat)heightForCellWithText:(NSString *)text availableWidth:(CGFloat)availableWidth {
    static CGFloat padding = 10.0;
    
    UIFont *systemFont = [UIFont systemFontOfSize:YZFontSize];
    CGSize textSize = CGSizeMake(availableWidth - (2 * padding) - 26, CGFLOAT_MAX); // rough accessory size
    NSDictionary *attributes = @{
                                 NSFontAttributeName : systemFont,
                                 };
    CGSize sizeWithFont = [text boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
#if defined(__LP64__) && __LP64__
    return ceil(sizeWithFont.height) + padding;
#else
    return ceilf(sizeWithFont.height) + padding;
#endif
}

@end
