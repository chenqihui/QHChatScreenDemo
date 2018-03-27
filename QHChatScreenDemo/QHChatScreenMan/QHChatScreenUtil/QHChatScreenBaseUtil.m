//
//  QHChatScreenBaseUtil.m
//  QHQHChatScreenDemo
//
//  Created by chen on 16/3/3.
//  Copyright © 2016年 chen. All rights reserved.
//

#import "QHChatScreenBaseUtil.h"

@implementation QHChatScreenBaseUtil

+ (CGSize)getSizeWithString:(NSString *)str withFont:(UIFont *)font {
    CGSize s;
    
    s = [str sizeWithAttributes:@{NSFontAttributeName:font}];
    
    return s;
}

+ (UIImage *)convertViewToImage:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    //    [view drawRect:CGRectMake(0, 50, view.frame.size.width, view.frame.size.height)];
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    view.layer.contents = nil;
    
    return image;
}

+ (NSAttributedString *)toBlank {
    NSMutableAttributedString *blankAttr = [[NSMutableAttributedString alloc] initWithString:@" "];
    [QHChatScreenBaseUtil addDefualAttributes:blankAttr];
    return blankAttr;
}

+ (NSAttributedString *)toBlankWithSize:(CGSize)size {
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:(CGRect){CGPointZero, size}];
    NSAttributedString *imageAttr = nil;
    @try {
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.image = [self convertViewToImage:imageV];;
        textAttachment.bounds = CGRectMake(0, -2, textAttachment.image.size.width, textAttachment.image.size.height);
        imageAttr = [NSAttributedString attributedStringWithAttachment:textAttachment];
    } @catch (NSException *exception) {
    } @finally {
    }
    return imageAttr;
}

+ (void)addDefualAttributes:(NSMutableAttributedString *)attr {
    NSShadow * shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithWhite:0 alpha:0.5];
    shadow.shadowOffset = CGSizeMake(0.0f, 1.0f);
    shadow.shadowBlurRadius = 1;
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 0;
    [attr addAttributes:@{NSFontAttributeName: [QHChatScreenConfig sharedInstance].font, NSParagraphStyleAttributeName: paragraphStyle, NSShadowAttributeName: shadow} range:NSMakeRange(0, attr.length)];
}

+ (NSAttributedString *)toContent:(NSString *)content color:(UIColor *)color {
    
    if (!content)
    {
        content = @"";
    }
    
    NSMutableAttributedString *contentAttr = [[NSMutableAttributedString alloc] initWithString:content attributes:@{NSForegroundColorAttributeName:color}];
    [QHChatScreenBaseUtil addDefualAttributes:contentAttr];
    return contentAttr;
}

+ (NSAttributedString *)toHtmlEscpaseContent:(NSString *)content color:(UIColor *)color {
    NSDictionary *options = @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                               NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)};
    
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableAttributedString *contentAttr = [[NSMutableAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
    [contentAttr addAttributes:@{NSForegroundColorAttributeName: color} range:NSMakeRange(0, contentAttr.length)];
    [QHChatScreenBaseUtil addDefualAttributes:contentAttr];
    return contentAttr;
}

+ (NSAttributedString *)toImage:(UIImage *)image size:(CGSize)size {
    UIImageView *imageV = [[UIImageView alloc] initWithImage:image];
    imageV.frame = (CGRect){CGPointZero, size};
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

+ (CGSize)calculateString:(NSString *)string size:(CGSize)size font:(UIFont *)font {
    CGSize expectedLabelSize = CGSizeZero;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        
        expectedLabelSize = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    }
    else {
//        expectedLabelSize = [string sizeWithFont:font
//                             constrainedToSize:size
//                                 lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    return CGSizeMake(ceil(expectedLabelSize.width), ceil(expectedLabelSize.height));
}

@end
