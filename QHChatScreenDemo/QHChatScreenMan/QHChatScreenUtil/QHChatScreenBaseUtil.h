//
//  QHChatScreenBaseUtil.h
//  QHQHChatScreenDemo
//
//  Created by chen on 16/3/3.
//  Copyright © 2016年 chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//#import "SHZhiboProtocol.h"
//#import "NSString+HTML.h"
//#import "QHAppContext.h"

//#import "QHDeviceAppInfo.h"

#import "QHChatScreenConfig.h"

//#define SIZE_FONT_SMALLER 12
//#define FONT_CHATSCREEN_SMALLER [UIFont systemFontOfSize:SIZE_FONT_SMALLER]
//#define SIZE_FONT 13
//#define FONT_CHATSCREEN [UIFont systemFontOfSize:SIZE_FONT]
//#define FONT_CHATSCREEN_BIGGER [UIFont systemFontOfSize:11]

#define CHATSCREEN_RGBA(R/*红*/, G/*绿*/, B/*蓝*/, A/*透明*/) \
[UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:A]

#define YELLOW_COLOR_CHATSCREEN CHATSCREEN_RGBA(0xfe, 0xb1, 0x4a, 1)
#define BLUE_COLOR_CHATSCREEN CHATSCREEN_RGBA(0x46, 0xdc, 0xde, 1)
#define RED_COLOR_CHATSCREEN CHATSCREEN_RGBA(0xeb, 0x08, 0x3e, 1)
#define WHITE_COLOR_CHATSCREEN CHATSCREEN_RGBA(0xff, 0xff, 0xff, 1)
#define GOLD_COLOR_CHATSCREEN CHATSCREEN_RGBA(0xff, 0xd8, 0x00, 1)
#define GOLD_Light_COLOR_CHATSCREEN CHATSCREEN_RGBA(0xc8, 0xc5, 0x00, 1)
#define Gray_COLOR_CHATSCREEN CHATSCREEN_RGBA(0xcc, 0xcc, 0xcc, 1)

//5.3
#define SYSTEM_YELLOW_COLOR_CHATSCREEN CHATSCREEN_RGBA(0xff, 0xda, 0x44, 1)
#define NAME_YELLOW_COLOR_CHATSCREEN CHATSCREEN_RGBA(0xff, 0xe8, 0x89, 1)
#define ADMIN_RED_COLOR_CHATSCREEN CHATSCREEN_RGBA(0xff, 0x65, 0x3b, 1)
#define OTHER_YELLOW_COLOR_CHATSCREEN CHATSCREEN_RGBA(0xfa, 0xb1, 0x0a, 1)
#define GIFT_BLUE_COLOR_CHATSCREEN CHATSCREEN_RGBA(0x7d, 0xe5, 0xff, 1)
#define LUCKNUMBER_YELLOW_COLOR_CHATSCREEN CHATSCREEN_RGBA(0x6c, 0x42, 0x24, 1)

#import <Foundation/Foundation.h>

@interface QHChatScreenBaseUtil : NSObject

+ (CGSize)getSizeWithString:(NSString *)str withFont:(UIFont *)font;

+ (UIImage *)convertViewToImage:(UIView *)view;

+ (NSAttributedString *)toBlank;

+ (NSAttributedString *)toBlankWithSize:(CGSize)size;

+ (void)addDefualAttributes:(NSMutableAttributedString *)attr;

+ (NSAttributedString *)toContent:(NSString *)content color:(UIColor *)color;

+ (NSAttributedString *)toHtmlEscpaseContent:(NSString *)content color:(UIColor *)color;

+ (NSAttributedString *)toImage:(UIImage *)image size:(CGSize)size;

+ (CGSize)calculateString:(NSString *)string size:(CGSize)size font:(UIFont *)font;

@end
