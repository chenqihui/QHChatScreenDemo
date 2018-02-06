//
//  QHChatScreenDataSourceObject.m
//  QHChatScreenDemo
//
//  Created by Anakin chen on 2018/2/5.
//  Copyright © 2018年 Anakin Network Technology. All rights reserved.
//

#import "QHChatScreenDataSourceObject.h"

#import "QHChatScreenUtil.h"

@implementation QHChatScreenDataSourceObject

#pragma mark - QHChatScreenDataSource

- (BOOL)checkPassData:(NSDictionary *)data {
    NSDictionary *chatData = [data objectForKey:KEY_CHATSCREEN_BODY];
    
    if (chatData == nil) {
        return NO;
    }
    NSString *route = data[KEY_CHATSCREEN_ROUTER];
    if (route == nil) {
        return NO;
    }
    else if ([route isEqualToString:VALUE_ROUTER_CHATSCREEN_CHAT] == YES) {
        return YES;
    }
    else if ([route isEqualToString:VALUE_ROUTER_CHATSCREEN_SYSTEM] == YES) {
        return YES;
    }
    else if ([route isEqualToString:VALUE_ROUTER_CHATSCREEN_WELCOME] == YES) {
        return YES;
    }
    return NO;
}

- (NSArray *)analyzeData:(NSDictionary *)data {
    NSArray *chatContent = nil;
    
    @try {
        NSDictionary *chatData;
        if ([data objectForKey:KEY_CHATSCREEN_BODY]) {
            chatData = [data objectForKey:KEY_CHATSCREEN_BODY];
        }
        
        NSString *route = data[KEY_CHATSCREEN_ROUTER];
        if ([route isEqualToString:VALUE_ROUTER_CHATSCREEN_CHAT]) {
            chatContent = [QHChatScreenBaseUtil toChatData:chatData height:0];
        }
        else if ([route isEqualToString:VALUE_ROUTER_CHATSCREEN_SYSTEM]) {
            chatContent = [QHChatScreenBaseUtil toSystemNoticeData:chatData height:0];
        }
        else if ([route isEqualToString:VALUE_ROUTER_CHATSCREEN_WELCOME]) {
            chatContent = [QHChatScreenBaseUtil toWelcomeData:chatData height:0];
        }
    } @catch (NSException *exception) {
        chatContent = nil;
    }
    return chatContent;
}

- (BOOL)canSelectRowWithData:(NSDictionary *)chatData {
    return NO;
}

- (NSString *)analyzeDataForHighlightTitle:(NSDictionary *)data {
    NSDictionary *chatData = [data objectForKey:KEY_CHATSCREEN_BODY];
    
    if (chatData == nil) {
        return nil;
    }
    
    NSString *route = data[KEY_CHATSCREEN_ROUTER];
    if ([route isEqualToString:VALUE_ROUTER_CHATSCREEN_SYSTEM]) {
        NSString *url = chatData[KEY_CHATSCREEN_URL];
        if (url != nil && url.length > 0) {
            return @"查看详情";
        }
    }
    return nil;
}

- (BOOL)isFoldLastChatDataOld:(NSDictionary *)chatDataOld new:(NSDictionary *)chatDataNew {
    BOOL bCompare = NO;
    NSString *routeTNew = chatDataNew[KEY_CHATSCREEN_ROUTER];
    if ([routeTNew isEqualToString:VALUE_ROUTER_CHATSCREEN_WELCOME] == YES) {
        bCompare = YES;
    }
    if (bCompare == YES) {
        NSString *routeTOld = chatDataOld[KEY_CHATSCREEN_ROUTER];
        if ([routeTNew isEqualToString:routeTOld]) {
            return YES;
        }
    }
    return NO;
}

@end
