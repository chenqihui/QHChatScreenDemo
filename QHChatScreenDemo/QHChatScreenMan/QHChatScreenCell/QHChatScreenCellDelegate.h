//
//  QHChatScreenCellDelegate.h
//  QHChatScreenDemo
//
//  Created by Anakin chen on 2018/2/5.
//  Copyright © 2018年 Anakin Network Technology. All rights reserved.
//

#ifndef QHChatScreenCellDelegate_h
#define QHChatScreenCellDelegate_h


#endif /* QHChatScreenCellDelegate_h */

@protocol QHChatScreenCellDelegate <NSObject>

@optional

- (void)selectViewCell:(UITableViewCell *)viewCell;

- (void)deselectViewCell:(UITableViewCell *)viewCell;

@end
