//
//  QHChatScreenBaseUtil+Chat.m
//  QHQHChatScreenDemo
//
//  Created by chen on 16/3/3.
//  Copyright © 2016年 chen. All rights reserved.
//

#import "QHChatScreenBaseUtil+Chat.h"

#import "QHChatScreenBaseUtil+Base.h"

#import "QHGifTextAttachment.h"
#import "NSString+HTML.h"

#define GifEmojiRegex @"\\[[_a-zA-Z0-9\\u4e00-\\u9fa5]+\\]"

@implementation QHChatScreenBaseUtil (Chat)

+ (NSArray *)toChatData:(NSDictionary *)dicData height:(CGFloat)height {
    NSMutableAttributedString *chatScreenCellData = [NSMutableAttributedString new];
    NSString *type = [NSString stringWithFormat:@"%@", dicData[KEY_CHATSCREEN_TYPE]];
    NSString *unid = [QHChatScreenBaseUtil getLuckyNum:dicData];
    if ([type isEqualToString:@"1"]) {
        [chatScreenCellData appendAttributedString:[QHChatScreenBaseUtil toHeaderUserLevel:[dicData[KEY_CHATSCREEN_LEVEL] integerValue] username:dicData[KEY_CHATSCREEN_USERNAME] luckyNum:unid toUsername:dicData[KEY_CHATSCREEN_TOUSERNAME] first:nil middle:@"对" last:@"说"]];
    }
    else if ([type isEqualToString:@"0"]) {
        [chatScreenCellData appendAttributedString:[QHChatScreenBaseUtil toHeaderUserLevel:[dicData[KEY_CHATSCREEN_LEVEL] integerValue] username:dicData[KEY_CHATSCREEN_USERNAME] luckyNum:unid toUsername:nil first:nil middle:nil last:nil]];
    }
    else {
        return nil;
    }
    
    [chatScreenCellData appendAttributedString:[QHChatScreenBaseUtil toBlank]];
    [self toChatScreenCellChatContent:dicData height:height complete:^(NSMutableAttributedString *chatScreenCellContent, CGFloat width) {
        [chatScreenCellData appendAttributedString:chatScreenCellContent];
    }];
    
    return @[chatScreenCellData];
}

+ (void)toChatScreenCellChatContent:(NSDictionary *)dicData height:(CGFloat)height complete:(void(^)(NSMutableAttributedString *chatScreenCellContent, CGFloat width))complete {
    NSString *contentString = [NSString stringWithFormat:@"%@", dicData[KEY_CHATSCREEN_CONTENT]];
    if (contentString == nil) {
        contentString = @"";
    }
//    contentString = [contentString sh_decodeHTMLCharacterEntities];
    NSMutableAttributedString *chatScreenCellContent = [NSMutableAttributedString new];
    [chatScreenCellContent appendAttributedString:[QHChatScreenBaseUtil toContent:contentString color:WHITE_COLOR_CHATSCREEN]];
//    [[QHEmojiGifUtil sharedInstance] content:chatScreenCellContent size:CGSizeMake([QHChatScreenConfig sharedInstance].emojiImageWidth, [QHChatScreenConfig sharedInstance].emojiImageWidth)];
    
//    NSRegularExpression *exp_emoji =
//    [[NSRegularExpression alloc] initWithPattern:GifEmojiRegex
//                                         options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators
//                                           error:nil];
//    NSMutableDictionary *emojiDict = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary *gifDict = [[NSMutableDictionary alloc] init];
//    [exp_emoji enumerateMatchesInString:chatScreenCellContent.string options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators range:NSMakeRange(0, chatScreenCellContent.string.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
//        if (result != nil) {
//            NSString *resultString = [chatScreenCellContent.string substringWithRange:result.range];
//            [[QHEmojiGifUtil sharedInstance].allArData enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
//                if ([((NSDictionary *)dic.allValues[0]).allValues containsObject:resultString]) {
//                    if ([[QHEmojiGifUtil sharedInstance].isGifArray[idx] boolValue]) {
//                        [gifDict setValue:resultString forKey:NSStringFromRange(result.range)];
//                    }
//                    else {
//                        [emojiDict setValue:resultString forKey:NSStringFromRange(result.range)];
//                    }
//                    *stop = YES;
//                }
//            }];
//        }
//    }];
//    NSComparator cmptr = ^(NSString *obj1, NSString *obj2) {
//        if (NSRangeFromString(obj1).location > NSRangeFromString(obj2).location) {
//            return (NSComparisonResult)NSOrderedAscending;
//        }
//        else if (NSRangeFromString(obj1).location < NSRangeFromString(obj2).location) {
//            return (NSComparisonResult)NSOrderedDescending;
//        }
//        return (NSComparisonResult)NSOrderedDescending;
//    };
//    NSArray *ranges = emojiDict.allKeys;
//    ranges = [ranges sortedArrayUsingComparator:cmptr];
//    for (NSString *keyString in ranges) {
//        NSString *value = emojiDict[keyString];
//        UIImage *image = [UIImage imageNamed:value];
//        
//        if (image != nil) {
//            UIImageView *imageV = [[UIImageView alloc] initWithImage:image];
//            imageV.frame = (CGRect){CGPointZero, CGSizeMake(FONT_CHATSCREEN_BIGGER.pointSize, FONT_CHATSCREEN_BIGGER.pointSize)};
//            NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
//            textAttachment.image = [self convertViewToImage:imageV];;
//            textAttachment.bounds = CGRectMake(0, -2, textAttachment.image.size.width, textAttachment.image.size.height);
//            NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
//            [chatScreenCellContent replaceCharactersInRange:NSRangeFromString(keyString) withAttributedString:attachmentString];
//        }
//    }
//    ranges = gifDict.allKeys;
//    ranges = [ranges sortedArrayUsingComparator:cmptr];
//    for (NSString *keyString in ranges) {
//        NSString *value = emojiDict[keyString];
//
//        QHGifTextAttachment *textAttachment = [[QHGifTextAttachment alloc] init];
//        textAttachment.bounds = (CGRect){{0, -2}, CGSizeMake(FONT_CHATSCREEN_BIGGER.pointSize, FONT_CHATSCREEN_BIGGER.pointSize)};
//        NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
//        [chatScreenCellContent replaceCharactersInRange:NSRangeFromString(keyString) withAttributedString:attachmentString];
//        textAttachment.gifName = value;
//        textAttachment.gifWidth = textAttachment.image.size.width;
//    }
    
    complete(chatScreenCellContent, 0);
}

@end
