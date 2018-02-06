//
//  QHChatScreenBaseUtil+Chat.h
//  QHQHChatScreenDemo
//
//  Created by chen on 16/3/3.
//  Copyright © 2016年 chen. All rights reserved.
//

#import "QHChatScreenBaseUtil.h"

#define IMAGE_HEADER @"imageHeader"
#define NAME_HEADER @"nameHeader"
#define TEXT_CONTENT @"textContent"
#define GIFT_CONTENT @"giftContent"

@interface QHChatScreenBaseUtil (Chat)

+ (NSArray *)toChatData:(NSDictionary *)dicData height:(CGFloat)height;

@end
