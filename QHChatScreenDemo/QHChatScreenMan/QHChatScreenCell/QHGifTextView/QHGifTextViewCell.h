//
//  QHGifTextViewCell.h
//  zhibo
//
//  Created by chen on 16/4/26.
//  Copyright © 2016年 Qianjun Network Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QHChatScreenCellDelegate.h"
#import "QHGifTextView.h"

@interface QHGifTextViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet QHGifTextView *gifTextView;

@property (nonatomic, weak) id <QHChatScreenCellDelegate> gifTextViewDelegate;

@end
