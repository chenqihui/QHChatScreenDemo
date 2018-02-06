//
//  QHChatScreenViewCell.h
//  QHQHChatScreenDemo
//
//  Created by chen on 16/2/27.
//  Copyright © 2016年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

//废弃

@protocol QHChatScreenViewCellDelegate <NSObject>

@optional

- (void)selectTableViewCell:(UITableViewCell *)tableViewCell;

@end

@interface QHChatScreenViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic, weak) id<QHChatScreenViewCellDelegate> cellDelegate;

- (void)addHeaderTouches:(CGRect)frame;

@end
