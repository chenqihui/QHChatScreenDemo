//
//  QHChatScreenView.h
//  QHQHChatScreenDemo
//
//  Created by chen on 16/2/24.
//  Copyright © 2016年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QHChatScreenUtil.h"
#import "QHChatScreenDelegate.h"

@interface QHChatScreenView : UIView

//以下是手动计算文本需要的高度
@property (nonatomic) CGFloat cellWidth;//自己计算高度的时候需要
@property (nonatomic) CGFloat cellLandscapeWidth;//自己计算高度的时候需要
@property BOOL bLandscape;//自己计算高度的时候需要

@property BOOL bReturnScrollScreenView;

+ (QHChatScreenView *)createChatViewToSuperView:(UIView *)superView dataSource:(id<QHChatScreenDataSource>)dataSource delegate:(id<QHChatScreenDelegate>)delegate;

- (void)moveChatViewToSuperView:(UIView *)superView;

- (void)insertChatData:(id)data;

- (void)insertChatMutableData:(id)data;

- (void)scrollChatScreenToBottom:(BOOL)bBottom;

//必须保证公屏不滑动的情况下操作
- (void)reloadChatScreen:(BOOL)bReload;

- (void)clearChatScreen;

@end
