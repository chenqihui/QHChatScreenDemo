//
//  QHChatScreenBaseUtil+Base.h
//  QHChatScreenDemo
//
//  Created by Anakin chen on 2018/2/5.
//  Copyright © 2018年 Anakin Network Technology. All rights reserved.
//

#import "QHChatScreenBaseUtil.h"

#import "SHChatScreenKey.h"

@interface QHChatScreenBaseUtil (Base)

+ (NSAttributedString *)toUsername:(NSString *)username;

+ (NSAttributedString *)toUserLevelImage:(UIImage *)image;

+ (NSAttributedString *)toUserlevel:(NSInteger)userlevel;

+ (NSString *)getLuckyNum:(NSDictionary *)dicData;

+ (NSAttributedString *)toHeaderUserLevel:(NSInteger)userlevel username:(NSString *)username toUsername:(NSString *)toUsername first:(NSString *)firstString middle:(NSString *)middleString last:(NSString *)lastString;

+ (NSAttributedString *)toHeaderUserLevel:(NSInteger)userlevel username:(NSString *)username luckyNum:(NSString *)luckyNum toUsername:(NSString *)toUsername first:(NSString *)firstString middle:(NSString *)middleString last:(NSString *)lastString;

@end
