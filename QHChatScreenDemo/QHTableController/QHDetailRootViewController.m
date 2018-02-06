//
//  QHDetailRootViewController.m
//  QHTableDemo
//
//  Created by chen on 17/3/13.
//  Copyright © 2017年 chen. All rights reserved.
//

#import "QHDetailRootViewController.h"

#import "QHChatScreenView.h"
#import "QHChatScreenDataSourceObject.h"
#import "SHChatScreenKey.h"
#import "NSTimer+QHEOCBlocksSupport.h"

@interface QHDetailRootViewController () <QHChatScreenDelegate>

@property (weak, nonatomic) IBOutlet UIView *chatScreenV;
@property (nonatomic, strong) QHChatScreenView *chatScreenView;

@property (nonatomic, strong) QHChatScreenDataSourceObject *chatScreenDataSourceObject;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSTimer *chatDataTimer;

@end

@implementation QHDetailRootViewController

- (void)dealloc {
    _chatScreenView = nil;
    _chatScreenDataSourceObject = nil;
    _dataArray = nil;
    [_chatDataTimer invalidate];
    _chatDataTimer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self p_setup];
    
    __weak typeof(self) weakSelf = self;
    self.chatDataTimer = [NSTimer qheoc_scheduledTimerWithTimeInterval:1 block:^{
        [weakSelf chatDataTimerAction];
    } repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)p_setup {
    [self p_setData];
    [self p_setUI];
}

- (void)p_setUI {
    self.chatScreenDataSourceObject = [QHChatScreenDataSourceObject new];
    [self p_addChatScreenView];
}

- (void)p_setData {
    self.dataArray = [NSMutableArray new];
    //进场
    NSDictionary *dic = @{KEY_CHATSCREEN_ROUTER: VALUE_ROUTER_CHATSCREEN_WELCOME,
                          KEY_CHATSCREEN_BODY: @{KEY_CHATSCREEN_UID: @"12345",
                                                 KEY_CHATSCREEN_USERNAME: @"James",
                                                 KEY_CHATSCREEN_LEVEL: @"1",
                                                 KEY_CHATSCREEN_CONTENT: @"hello"
                                                 }
                          };
    [self.dataArray addObject:dic];
    //聊天
    dic = @{KEY_CHATSCREEN_ROUTER: VALUE_ROUTER_CHATSCREEN_CHAT,
            KEY_CHATSCREEN_BODY: @{KEY_CHATSCREEN_UID: @"12345",
                                   KEY_CHATSCREEN_USERNAME: @"James",
                                   KEY_CHATSCREEN_LEVEL: @1,
                                   KEY_CHATSCREEN_CONTENT: @"hello",
                                   KEY_CHATSCREEN_TYPE: @0
                                   }
            };
    [self.dataArray addObject:dic];
    //系统消息+高亮
    dic = @{KEY_CHATSCREEN_ROUTER: VALUE_ROUTER_CHATSCREEN_SYSTEM,
            KEY_CHATSCREEN_BODY: @{KEY_CHATSCREEN_TYPE: @0,
                                   KEY_CHATSCREEN_CONTENT: @"新年快乐",
                                   KEY_CHATSCREEN_URL: @"www.baidu.com"
                                   }
            };
    [self.dataArray addObject:dic];
    //进场
    dic = @{KEY_CHATSCREEN_ROUTER: VALUE_ROUTER_CHATSCREEN_WELCOME,
            KEY_CHATSCREEN_BODY: @{KEY_CHATSCREEN_UID: @"12345",
                                   KEY_CHATSCREEN_USERNAME: @"James",
                                   KEY_CHATSCREEN_LEVEL: @2,
                                   KEY_CHATSCREEN_CONTENT: @"hello",
                                   KEY_CHATSCREEN_ISLUCKYNUMBER: @YES
                                   }
            };
    [self.dataArray addObject:dic];
    //聊天（对谁说）
    dic = @{KEY_CHATSCREEN_ROUTER: VALUE_ROUTER_CHATSCREEN_CHAT,
            KEY_CHATSCREEN_BODY: @{KEY_CHATSCREEN_UID: @"12345",
                                   KEY_CHATSCREEN_USERNAME: @"James",
                                   KEY_CHATSCREEN_LEVEL: @2,
                                   KEY_CHATSCREEN_CONTENT: @"hello",
                                   KEY_CHATSCREEN_TYPE: @1,
                                   KEY_CHATSCREEN_TOUSERNAME: @"Wade"
                                   }
            };
    [self.dataArray addObject:dic];
    //进场
    dic = @{KEY_CHATSCREEN_ROUTER: VALUE_ROUTER_CHATSCREEN_WELCOME,
            KEY_CHATSCREEN_BODY: @{KEY_CHATSCREEN_UID: @"12345",
                                   KEY_CHATSCREEN_USERNAME: @"James1",
                                   KEY_CHATSCREEN_LEVEL: @"1",
                                   KEY_CHATSCREEN_CONTENT: @"hello"
                                   }
            };
    [self.dataArray addObject:dic];
    //进场
    dic = @{KEY_CHATSCREEN_ROUTER: VALUE_ROUTER_CHATSCREEN_WELCOME,
            KEY_CHATSCREEN_BODY: @{KEY_CHATSCREEN_UID: @"12345",
                                   KEY_CHATSCREEN_USERNAME: @"James2",
                                   KEY_CHATSCREEN_LEVEL: @"1",
                                   KEY_CHATSCREEN_CONTENT: @"hello"
                                   }
            };
    [self.dataArray addObject:dic];
    //进场（以上进行折叠）
    dic = @{KEY_CHATSCREEN_ROUTER: VALUE_ROUTER_CHATSCREEN_WELCOME,
            KEY_CHATSCREEN_BODY: @{KEY_CHATSCREEN_UID: @"12345",
                                   KEY_CHATSCREEN_USERNAME: @"James3",
                                   KEY_CHATSCREEN_LEVEL: @"1",
                                   KEY_CHATSCREEN_CONTENT: @"hello"
                                   }
            };
    [self.dataArray addObject:dic];
    //系统消息
    dic = @{KEY_CHATSCREEN_ROUTER: VALUE_ROUTER_CHATSCREEN_SYSTEM,
            KEY_CHATSCREEN_BODY: @{KEY_CHATSCREEN_TYPE: @0,
                                   KEY_CHATSCREEN_CONTENT: @"再见"
                                   }
            };
    [self.dataArray addObject:dic];
    //聊天
    dic = @{KEY_CHATSCREEN_ROUTER: VALUE_ROUTER_CHATSCREEN_CHAT,
            KEY_CHATSCREEN_BODY: @{KEY_CHATSCREEN_UID: @"12345",
                                   KEY_CHATSCREEN_USERNAME: @"Wede",
                                   KEY_CHATSCREEN_LEVEL: @1,
                                   KEY_CHATSCREEN_CONTENT: @"bye",
                                   KEY_CHATSCREEN_TYPE: @0
                                   }
            };
    [self.dataArray addObject:dic];
}

- (void)p_addChatScreenView {
    [[QHChatScreenConfig sharedInstance] resetConfig];
    self.chatScreenView = [QHChatScreenView createChatViewToSuperView:self.chatScreenV dataSource:self.chatScreenDataSourceObject delegate:self];
    self.chatScreenView.cellWidth = self.chatScreenV.frame.size.width;
//    self.chatScreenView.cellLandscapeWidth = SCREEN_HEIGHT * 280/667;
    [self p_addMaskView:self.chatScreenView height:0.04];
}

- (void)p_addMaskView:(UIView *)superView height:(CGFloat)height {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    CGRect frame = CGRectMake(0, 0, superView.bounds.size.width, superView.bounds.size.height);
    gradientLayer.frame = frame;
    gradientLayer.colors = @[(__bridge id)[UIColor clearColor].CGColor, (__bridge id)[UIColor blackColor].CGColor, (__bridge id)[UIColor blackColor].CGColor, (__bridge id)[UIColor clearColor].CGColor];
    gradientLayer.locations = @[@(0), @(height), @(0.999), @(1)];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    UIView *maskView = [[UIView alloc] initWithFrame:frame];
    [maskView.layer addSublayer:gradientLayer];
    superView.maskView = maskView;
}

#pragma mark - Util

+ (int)getRandomNumber:(int)from to:(int)to {
    if (from > to) {
        int temp = from;
        from = to;
        to = temp;
    }
    return (int)(from + (arc4random() % (to - from + 1)));
}

#pragma mark - Action

- (void)chatDataTimerAction {
    BOOL bShow = [QHDetailRootViewController getRandomNumber:0 to:1];
    if (bShow == YES) {
        int index = [QHDetailRootViewController getRandomNumber:0 to:(int)(self.dataArray.count - 1)];
        NSDictionary *dic = self.dataArray[index];
        [self.chatScreenView insertChatData:dic];
    }
}

@end
