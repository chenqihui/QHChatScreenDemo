//
//  QHChatScreenConfig.m
//  zhibo
//
//  Created by chen on 2017/4/27.
//  Copyright © 2017年 Qianjun Network Technology. All rights reserved.
//

#import "QHChatScreenConfig.h"

@interface QHChatScreenConfig ()

@property (nonatomic, readwrite) CGSize userLevelImageSize;
@property (nonatomic, readwrite) CGSize userLuckNumberImageSize;

@property (nonatomic, readwrite) CGFloat emojiImageWidth;

@property (nonatomic, strong, readwrite) UIFont *font;
@property (nonatomic, strong, readwrite) UIFont *luckNumberFont;

@end

@implementation QHChatScreenConfig

+ (QHChatScreenConfig *)sharedInstance {
    static QHChatScreenConfig *this = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        this = [[QHChatScreenConfig alloc] init];
        [this setup];
    });
    return this;
}

- (void)setup {
    self.fontSize = 16;
    self.userLevelImageHeight = -1;
    self.highlightHeight = 30;
    self.luckNumberFontSize = 10;
}
                       
#pragma mark - Util
                       
+ (CGSize)calculateString:(NSString *)string size:(CGSize)size font:(UIFont *)font {
   CGSize expectedLabelSize = CGSizeZero;
   
   NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
   paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
   NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
   
   expectedLabelSize = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
   
   return CGSizeMake(ceil(expectedLabelSize.width), ceil(expectedLabelSize.height));
}


#pragma mark - Action

- (void)resetConfig {
    self.fontSize = 16;
    self.userLevelImageHeight = -1;
    self.highlightHeight = 30;
    self.luckNumberFontSize = 10;
}

#pragma mark - Set

- (void)setFontSize:(CGFloat)fontSize {
    if (_fontSize == fontSize) {
        return;
    }
    _fontSize = fontSize;
    CGSize size = [QHChatScreenConfig calculateString:@"陈" size:CGSizeMake(CGFLOAT_MAX, 100) font:[UIFont systemFontOfSize:_fontSize]];
    self.emojiImageWidth = size.height;
    
    _font = nil;
}

- (void)setUserLevelImageHeight:(CGFloat)userLevelImageHeight {
    if (_userLevelImageHeight == userLevelImageHeight) {
        return;
    }
    if (userLevelImageHeight <= 0) {
        _userLevelImageHeight = 0;
    }
    else {
        _userLevelImageHeight = userLevelImageHeight;
    }
    
    UIImage *image = [UIImage imageNamed:@"level_1"];
    if (_userLevelImageHeight <= 0) {
        self.userLevelImageSize = image.size;
    }
    else {
        CGFloat w = (_userLevelImageHeight / image.size.height) * image.size.width;
        self.userLevelImageSize = (CGSize){w, _userLevelImageHeight};
    }
    
    UIImage *luckNumberImage = [UIImage imageNamed:@"Liang_Live_icon"];
    if (_userLevelImageHeight <= 0) {
        self.userLuckNumberImageSize = luckNumberImage.size;
    }
    else {
        CGFloat w = (_userLevelImageHeight / luckNumberImage.size.height) * luckNumberImage.size.width;
        self.userLuckNumberImageSize = (CGSize){w, _userLevelImageHeight};
    }
    
}

#pragma mark - Get

- (UIFont *)font {
    if (_font == nil) {
        _font = [UIFont boldSystemFontOfSize:self.fontSize];
    }
    return _font;
}

- (UIFont *)luckNumberFont {
    if (_luckNumberFont == nil) {
        _luckNumberFont = [UIFont boldSystemFontOfSize:self.luckNumberFontSize];
    }
    return _luckNumberFont;
}

@end

@implementation QHChatScreenConfig (Min)

- (void)normalMinConfig {
    self.fontSize = 12;
    self.userLevelImageHeight = 13;
    self.highlightHeight = 26;
    self.luckNumberFontSize = 7.5;
}

@end
