//
//  QHChatScreenBaseUtil+Welcome.m
//  zhibo
//
//  Created by chen on 16/3/23.
//  Copyright © 2016年 chen. All rights reserved.
//

#import "QHChatScreenBaseUtil+Welcome.h"

#import "QHChatScreenBaseUtil+Base.h"

@implementation QHChatScreenBaseUtil (Welcome)

+ (NSArray *)toWelcomeData:(NSDictionary *)dicData height:(CGFloat)height {
    NSMutableAttributedString *chatScreenCellData = [NSMutableAttributedString new];
    
    NSString *unid = [self getLuckyNum:dicData];
    
    [chatScreenCellData appendAttributedString:[QHChatScreenBaseUtil toHeaderUserLevel:[dicData[KEY_CHATSCREEN_LEVEL] integerValue] username:dicData[KEY_CHATSCREEN_USERNAME] luckyNum:unid toUsername:nil first:nil middle:nil last:nil]];
    [chatScreenCellData appendAttributedString:[QHChatScreenBaseUtil toContent:@" 来了" color:NAME_YELLOW_COLOR_CHATSCREEN]];
    
    return @[chatScreenCellData];
}

+ (BOOL)bShowWelcomeInScreen:(NSDictionary *)dicData {
    return YES;
}

@end
