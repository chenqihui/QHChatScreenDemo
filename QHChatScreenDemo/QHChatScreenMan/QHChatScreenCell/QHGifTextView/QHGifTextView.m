//
//  QHGifTextView.m
//  zhibo
//
//  Created by chen on 16/4/26.
//  Copyright © 2016年 Qianjun Network Technology. All rights reserved.
//

#import "QHGifTextView.h"

//#import "YLImageView.h"
//#import "YLGIFImage.h"
#import "QHGifTextAttachment.h"

@implementation QHGifTextView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
//        self.layer.shadowOpacity = 0.8;
//        self.layer.shadowColor = [UIColor blackColor].CGColor;
//        self.layer.shadowOffset = CGSizeMake(0.5, 1);
//        self.backgroundColor = [UIColor clearColor];
//        self.layer.shadowRadius = 1;
        self.textContainerInset = UIEdgeInsetsMake(6, -5, 0, -5);
    };
    return self;
}

- (void)setGifAttributedText:(NSAttributedString *)attributedText {
//    for (UIView *subView in self.subviews) {
//        if ([subView isKindOfClass:[YLImageView class]]) {
//            [subView removeFromSuperview];
//        }
//    }
//
//    [self.attributedText enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.attributedText.length) options:NSAttributedStringEnumerationReverse usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
//        if ([value isKindOfClass:[QHGifTextAttachment class]]) {
//            QHGifTextAttachment *gifTextAttachment = value;
//
//            self.selectedRange = range;
//            CGRect rect = [self firstRectForRange:self.selectedTextRange];
//            self.selectedRange = NSMakeRange(0, 0);
//
//            YLImageView *emojiGifImageView = [[YLImageView alloc] initWithFrame:(CGRect){rect.origin, gifTextAttachment.gifWidth, gifTextAttachment.gifWidth}];
//            emojiGifImageView.backgroundColor = [UIColor clearColor];
//            [self addSubview:emojiGifImageView];
//
//            UIImage *gifImage = [YLGIFImage imageNamed:[NSString stringWithFormat:@"%@.gif", gifTextAttachment.gifName]];
//            emojiGifImageView.image = gifImage;
//        }
//    }];
}

@end
