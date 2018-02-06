//
//  QHHighlightViewCell.m
//  zhibo
//
//  Created by Anakin chen on 2017/8/24.
//  Copyright © 2017年 Qianjun Network Technology. All rights reserved.
//

#import "QHHighlightViewCell.h"

#import "QHChatScreenConfig.h"

@interface QHHighlightViewCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *highlightLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *highlightLabelWidthLC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *highlightLabelHeightLC;

@end

@implementation QHHighlightViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTapAction:)];
    [self.bgView addGestureRecognizer:tap];
    tap = nil;
    
    UITapGestureRecognizer *tapLabel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapAction:)];
    [self.highlightLabel addGestureRecognizer:tapLabel];
    tapLabel = nil;
    self.backgroundColor = [UIColor clearColor];
    
    [self setup];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setup {
//    self.highlightLabel.font = [UIFont systemFontOfSize:[QHChatScreenConfig sharedInstance].fontSize];
    self.highlightLabelHeightLC.constant = [QHChatScreenConfig sharedInstance].highlightHeight;
    self.highlightLabel.layer.cornerRadius = [QHChatScreenConfig sharedInstance].highlightHeight/2;
    self.highlightLabel.layer.masksToBounds = YES;
}

- (void)labelWithText:(NSString *)text font:(UIFont *)font height:(CGFloat)height {
    self.highlightLabel.text = text;
}

- (void)bgTapAction:(id)sender {
    if ([self.viewCellDelegate respondsToSelector:@selector(deselectViewCell:)]) {
        [self.viewCellDelegate deselectViewCell:self];
    }
}

- (IBAction)labelTapAction:(id)sender {
    if ([self.viewCellDelegate respondsToSelector:@selector(selectViewCell:)]) {
        [self.viewCellDelegate selectViewCell:self];
    }
}

@end
