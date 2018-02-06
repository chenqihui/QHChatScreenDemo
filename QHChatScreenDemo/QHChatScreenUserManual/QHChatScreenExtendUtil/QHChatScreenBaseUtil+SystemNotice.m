//
//  QHChatScreenBaseUtil+SystemNotice.m
//  zhibo
//
//  Created by chen on 16/4/28.
//  Copyright © 2016年 chen. All rights reserved.
//

#import "QHChatScreenBaseUtil+SystemNotice.h"

#import "SHChatScreenKey.h"

@implementation QHChatScreenBaseUtil (SystemNotice)

+ (NSArray *)toSystemNoticeData:(NSDictionary *)dicData height:(CGFloat)height {
    NSInteger type = [dicData[KEY_CHATSCREEN_TYPE] integerValue];
    NSString *contentString = nil;
    switch (type) {
        case 0: {
            contentString = @"系统消息:";
            break;
        }
        case 1: {
            contentString = @"官方活动:";
            break;
        }
        default: {
            contentString = nil;
            break;
        }
    }
    
    if (contentString == nil) {
        return nil;
    }
    
    NSString *content = [NSString stringWithFormat:@"%@ %@", contentString, dicData[KEY_CHATSCREEN_CONTENT]];
    
    NSMutableAttributedString *chatScreenCellData = [NSMutableAttributedString new];
    [chatScreenCellData appendAttributedString:[QHChatScreenBaseUtil toContent:content color:SYSTEM_YELLOW_COLOR_CHATSCREEN]];
    
    return @[chatScreenCellData];
}

@end
