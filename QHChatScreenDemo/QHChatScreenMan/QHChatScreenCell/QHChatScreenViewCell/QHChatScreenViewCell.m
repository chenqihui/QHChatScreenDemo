//
//  QHChatScreenViewCell.m
//  QHQHChatScreenDemo
//
//  Created by chen on 16/2/27.
//  Copyright © 2016年 chen. All rights reserved.
//

#import "QHChatScreenViewCell.h"

#import <CoreText/CoreText.h>

#import "QHChatScreenUtil.h"

@interface QHChatScreenViewCell ()

@property (nonatomic) CGRect headerFrame;

@property (nonatomic, strong) UIButton *headerButton;

@property (nonatomic) CTFrameRef ctFrame;

@end

@implementation QHChatScreenViewCell

- (void)dealloc {
    _headerButton = nil;
    if (self.ctFrame != nil) {
        CFRelease(self.ctFrame);
    }
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)headerAction:(id)sender {
    if ([self.cellDelegate respondsToSelector:@selector(selectTableViewCell:)]) {
        [self.cellDelegate selectTableViewCell:self];
    }
}

- (void)addHeaderTouches:(CGRect)frame {
//    self.headerFrame = frame;
    self.headerButton.frame = frame;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
//    if (CGRectContainsPoint(self.headerFrame, [touch locationInView:self])) {
//        [self headerAction:nil];
//    }
    if (self.ctFrame == nil) {
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.contentLabel.attributedText);
        CGMutablePathRef path = CGPathCreateMutable();
        CGRect bounds = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);
        CGPathAddRect(path, NULL, bounds);
        self.ctFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    }
//    CFIndex index = [QHChatScreenViewCell touchContentOffsetInView:self atPoint:[touch locationInView:self] data:self.ctFrame];
    NSLog(@"11");
}

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

#pragma mark - Get

- (UIButton *)headerButton {
    if (_headerButton == nil) {
        _headerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _headerButton.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_headerButton];
        [_headerButton addTarget:self action:@selector(headerAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerButton;
}

@end