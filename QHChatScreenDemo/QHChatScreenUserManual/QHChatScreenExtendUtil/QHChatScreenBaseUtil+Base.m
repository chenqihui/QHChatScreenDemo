//
//  QHChatScreenBaseUtil+Base.m
//  QHChatScreenDemo
//
//  Created by Anakin chen on 2018/2/5.
//  Copyright © 2018年 Anakin Network Technology. All rights reserved.
//

#import "QHChatScreenBaseUtil+Base.h"


@implementation QHChatScreenBaseUtil (Base)

+ (NSAttributedString *)toUserlevel:(NSInteger)userlevel {
    NSMutableAttributedString *userLevelAttr = [NSMutableAttributedString new];
    if (userlevel != 1) {
        NSString *level = nil;
        level = @"level_1";
        NSArray *imageArray = @[level];
        if (imageArray != nil) {
            for (int i = 0; i < imageArray.count; i++) {
                UIImage *image = [UIImage imageNamed:imageArray[i]];
                if (image == nil) {
                    continue;
                }
                [userLevelAttr appendAttributedString:[QHChatScreenBaseUtil toUserLevelImage:image]];
            }
        }
    }
    if (userLevelAttr.length > 0) {
        return userLevelAttr;
    }
    return nil;
}

+ (NSAttributedString *)toUserLevelImage:(UIImage *)image {
    return [QHChatScreenBaseUtil toImage:image size:[QHChatScreenConfig sharedInstance].userLevelImageSize];
}

+ (NSString *)getLuckyNum:(NSDictionary *)dicData {
    NSNumber *isLuckyNum = dicData[KEY_CHATSCREEN_ISLUCKYNUMBER];
    NSString *unid = nil;
    if (isLuckyNum != nil && [isLuckyNum boolValue] == YES) {
        unid = [NSString stringWithFormat:@"%@", dicData[KEY_CHATSCREEN_UID]];
    }
    return unid;
}

+ (NSAttributedString *)toUserluckNumber:(NSString *)luckNumberString {
    UIImage *image = [UIImage imageNamed:@"Liang_Live_icon.png"];
    NSAttributedString *luckNumberAttributedString = [self toImage:image size:[QHChatScreenConfig sharedInstance].userLuckNumberImageSize title:luckNumberString];
    return luckNumberAttributedString;
}

+ (NSAttributedString *)toImage:(UIImage *)image size:(CGSize)size title:(NSString *)title {
    UIImageView *imageV = [[UIImageView alloc] initWithImage:image];
    imageV.frame = (CGRect){CGPointZero, size};
    CGFloat xx = size.width/4.0;
    UILabel *titleL = [[UILabel alloc] initWithFrame:(CGRect){CGPointMake(xx, 0), CGSizeMake(size.width - xx - 1, size.height)}];
    titleL.text = title;
    [titleL setFont:[QHChatScreenConfig sharedInstance].luckNumberFont];
    [titleL setTextColor:LUCKNUMBER_YELLOW_COLOR_CHATSCREEN];
    [titleL setTextAlignment:NSTextAlignmentCenter];
    titleL.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [imageV addSubview:titleL];
    NSAttributedString *imageAttr = nil;
    @try {
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.image = [self convertViewToImage:imageV];;
        textAttachment.bounds = CGRectMake(0, -2, textAttachment.image.size.width, textAttachment.image.size.height);
        imageAttr = [NSAttributedString attributedStringWithAttachment:textAttachment];
    } @catch (NSException *exception) {
        imageAttr = [[NSAttributedString alloc] initWithString:@""];
    } @finally {
        
    }
    return imageAttr;
}

+ (NSAttributedString *)toHeaderUserLevel:(NSInteger)userlevel username:(NSString *)username  toUsername:(NSString *)toUsername first:(NSString *)firstString middle:(NSString *)middleString last:(NSString *)lastString {
    return [self toHeaderUserLevel:userlevel username:username luckyNum:nil toUsername:toUsername first:firstString middle:middleString last:lastString];
}

+ (NSAttributedString *)toHeaderUserLevel:(NSInteger)userlevel username:(NSString *)username luckyNum:(NSString *)luckyNum toUsername:(NSString *)toUsername first:(NSString *)firstString middle:(NSString *)middleString last:(NSString *)lastString {
    NSMutableAttributedString *headerAttr = [NSMutableAttributedString new];
    if (firstString != nil) {
        [headerAttr appendAttributedString:[QHChatScreenBaseUtil toContent:firstString color:WHITE_COLOR_CHATSCREEN]];
    }
    if (userlevel > 1) {
        NSAttributedString *levelAttr = [QHChatScreenBaseUtil toUserlevel:userlevel];
        if (levelAttr != nil) {
            [headerAttr appendAttributedString:levelAttr];
            NSAttributedString *blankLevelAttr = [QHChatScreenBaseUtil toBlankWithSize:CGSizeMake(2, 1)];
            if (blankLevelAttr != nil) {
                [headerAttr appendAttributedString:blankLevelAttr];
            }
        }
    }
    
    if (luckyNum != nil && luckyNum.length > 0) {
        [headerAttr appendAttributedString:[self toUserluckNumber:luckyNum]];
        NSAttributedString *blankAttr = [QHChatScreenBaseUtil toBlankWithSize:CGSizeMake(2, 1)];
        if (blankAttr != nil) {
            [headerAttr appendAttributedString:blankAttr];
        }
    }
    
    if (username != nil) {
        [headerAttr appendAttributedString:[QHChatScreenBaseUtil toUsername:username]];
    }
    if (middleString != nil) {
        [headerAttr appendAttributedString:[QHChatScreenBaseUtil toContent:middleString color:WHITE_COLOR_CHATSCREEN]];
    }
    if (toUsername != nil) {
        [headerAttr appendAttributedString:[QHChatScreenBaseUtil toUsername:toUsername]];
    }
    if (lastString != nil) {
        [headerAttr appendAttributedString:[QHChatScreenBaseUtil toContent:lastString color:WHITE_COLOR_CHATSCREEN]];
    }
    return headerAttr;
}

@end
