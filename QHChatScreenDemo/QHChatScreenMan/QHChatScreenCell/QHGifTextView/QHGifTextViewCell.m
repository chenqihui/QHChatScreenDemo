//
//  QHGifTextViewCell.m
//  zhibo
//
//  Created by chen on 16/4/26.
//  Copyright © 2016年 Qianjun Network Technology. All rights reserved.
//

#import "QHGifTextViewCell.h"

#import <CoreText/CoreText.h>

@interface QHGifTextViewCell ()

@property (nonatomic) CTFrameRef ctFrame;

@end

@implementation QHGifTextViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.gifTextView.textColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTextViewAction:)];
    [self addGestureRecognizer:tap];
    self.backgroundColor = [UIColor clearColor];
//    self.contentView.backgroundColor = [UIColor clearColor];
    tap = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [super touchesBegan:touches withEvent:event];
//    UITouch *touch = [touches anyObject];
//    //    if (CGRectContainsPoint(self.headerFrame, [touch locationInView:self])) {
//    //        [self headerAction:nil];
//    //    }
//}

// 将点击的位置转换成字符串的偏移量，如果没有找到，则返回-1
+ (CFIndex)touchContentOffsetInView:(UIView *)view atPoint:(CGPoint)point data:(CTFrameRef)ctFrame {
    CTFrameRef textFrame = ctFrame;
    CFArrayRef lines = CTFrameGetLines(textFrame);
    if (!lines) {
        return -1;
    }
    CFIndex count = CFArrayGetCount(lines);
    
    // 获得每一行的origin坐标
    CGPoint origins[count];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0,0), origins);
    
    // 翻转坐标系
    CGAffineTransform transform =  CGAffineTransformMakeTranslation(0, view.bounds.size.height);
    transform = CGAffineTransformScale(transform, 1.f, -1.f);
    
    CFIndex idx = -1;
    for (int i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        // 获得每一行的CGRect信息
        CGRect flippedRect = [self getLineBounds:line point:linePoint];
        CGRect rect = CGRectApplyAffineTransform(flippedRect, transform);
        
        if (CGRectContainsPoint(rect, point)) {
            // 将点击的坐标转换成相对于当前行的坐标
            CGPoint relativePoint = CGPointMake(point.x-CGRectGetMinX(rect),
                                                point.y-CGRectGetMinY(rect));
            // 获得当前点击坐标对应的字符串偏移
            idx = CTLineGetStringIndexForPosition(line, relativePoint);
        }
    }
    return idx;
}

+ (CGRect)getLineBounds:(CTLineRef)line point:(CGPoint)point {
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat leading = 0.0f;
    CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = ascent + descent;
    return CGRectMake(point.x, point.y - descent, width, height);
}

#pragma mark - Action

- (IBAction)tapTextViewAction:(id)sender {
    if (self.gifTextView.attributedText == nil) {
        return;
    }
    if (self.frame.size.width <= self.gifTextView.attributedText.size.width) {
        if ([self.gifTextViewDelegate respondsToSelector:@selector(selectViewCell:)]) {
            [self.gifTextViewDelegate selectViewCell:self];
        }
    }
    else {
        UITapGestureRecognizer *tap = sender;
//        if (self.ctFrame == nil) {
//            CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.gifTextView.attributedText);
//            CGMutablePathRef path = CGPathCreateMutable();
//            CGRect bounds = self.bounds;//CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);
//            CGPathAddRect(path, NULL, bounds);
//            self.ctFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
//        }
        CGPoint touchPoint = [tap locationInView:self.gifTextView];
//        CGFloat hh = 29/2;//单行中心位置
//        touchPoint.y = hh;
//        CFIndex index = [QHGifTextViewCell touchContentOffsetInView:self.gifTextView atPoint:touchPoint data:self.ctFrame];
//        if (index == -1) {
//            if ([self.gifTextViewDelegate respondsToSelector:@selector(deselectGifTextViewCell:)]) {
//                [self.gifTextViewDelegate deselectGifTextViewCell:self];
//            }
//        }
//        else {
//            if ([self.gifTextViewDelegate respondsToSelector:@selector(selectGifTextViewCell:)]) {
//                [self.gifTextViewDelegate selectGifTextViewCell:self];
//            }
//        }
        if (self.gifTextView.attributedText.size.width < touchPoint.x) {
            if ([self.gifTextViewDelegate respondsToSelector:@selector(deselectViewCell:)]) {
                [self.gifTextViewDelegate deselectViewCell:self];
            }
        }
        else {
            if ([self.gifTextViewDelegate respondsToSelector:@selector(selectViewCell:)]) {
                [self.gifTextViewDelegate selectViewCell:self];
            }
        }
    }
}


@end
