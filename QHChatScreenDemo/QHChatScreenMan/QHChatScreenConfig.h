//
//  QHChatScreenConfig.h
//  zhibo
//
//  Created by chen on 2017/4/27.
//  Copyright © 2017年 Qianjun Network Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QHChatScreenConfig : NSObject

@property (nonatomic, readonly) CGSize userLevelImageSize;
@property (nonatomic, readonly) CGSize userLuckNumberImageSize;
@property (nonatomic, readonly) CGFloat emojiImageWidth;
@property (nonatomic, strong, readonly) UIFont *font;
@property (nonatomic, strong, readonly) UIFont *luckNumberFont;

//set
@property (nonatomic) CGFloat fontSize;
@property (nonatomic) CGFloat userLevelImageHeight;
@property (nonatomic) CGFloat highlightHeight;
@property (nonatomic) CGFloat luckNumberFontSize;

+ (QHChatScreenConfig *)sharedInstance;

- (void)resetConfig;

+ (CGSize)calculateString:(NSString *)string size:(CGSize)size font:(UIFont *)font;

@end

@interface QHChatScreenConfig (Min)

- (void)normalMinConfig;

@end
