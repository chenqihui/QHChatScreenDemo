//
//  QHChatScreenDelegate.h
//  QHQHChatScreenDemo
//
//  Created by chen on 16/3/3.
//  Copyright © 2016年 chen. All rights reserved.
//

#ifndef QHChatScreenDelegate_h
#define QHChatScreenDelegate_h


#endif /* QHChatScreenDelegate_h */

#import <Foundation/Foundation.h>

@class QHChatScreenView;

@protocol QHChatScreenDelegate <NSObject>

@optional

- (void)chatScreenView:(QHChatScreenView *)chatScreenView didSelectRowWithData:(NSDictionary *)chatData;

- (void)chatScreenViewUnselect:(QHChatScreenView *)chatScreenView;

- (void)scrollScreenView:(QHChatScreenView *)chatScreenView;

@end


@protocol QHChatScreenDataSource <NSObject>

- (BOOL)checkPassData:(NSDictionary *)data;

- (NSArray *)analyzeData:(NSDictionary *)data;

- (BOOL)canSelectRowWithData:(NSDictionary *)chatData;

@optional

- (NSString *)analyzeDataForHighlightTitle:(NSDictionary *)data;

- (BOOL)isFoldLastChatDataOld:(NSDictionary *)chatDataOld new:(NSDictionary *)chatDataNew;

@end
