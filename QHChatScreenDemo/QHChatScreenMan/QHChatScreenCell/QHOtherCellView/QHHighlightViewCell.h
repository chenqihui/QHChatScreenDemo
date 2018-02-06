//
//  QHHighlightViewCell.h
//  zhibo
//
//  Created by Anakin chen on 2017/8/24.
//  Copyright © 2017年 Qianjun Network Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QHChatScreenCellDelegate.h"

@interface QHHighlightViewCell : UITableViewCell

@property (nonatomic, weak) id <QHChatScreenCellDelegate> viewCellDelegate;

- (void)labelWithText:(NSString *)text font:(UIFont *)font height:(CGFloat)height;

@end
