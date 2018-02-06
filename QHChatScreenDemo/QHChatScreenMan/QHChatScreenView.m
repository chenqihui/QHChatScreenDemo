//
//  QHChatScreenView.m
//  QHQHChatScreenDemo
//
//  Created by chen on 16/2/24.
//  Copyright © 2016年 chen. All rights reserved.
//

#import "QHChatScreenView.h"

#import "QHChatScreenViewCell.h"

#import "NSTimer+QHEOCBlocksSupport.h"

#import "QHGifTextViewCell.h"
#import "QHHighlightViewCell.h"

#define CHATCELL_IDENTIFIER @"chatGIfIdentifier"
#define HIGHLIGHT_IDENTIFIER @"highlightIdentifier"

#define MAX_CHATDATA 100
#define HEIGHT_CONTENTLABEL 19

#define TIME_REFRESH 0.7

typedef NS_ENUM(NSUInteger, CellType) {
    CellTypeNormal = 1,
    CellTypeHighlight
};

@interface QHChatScreenView () <UITableViewDataSource, UITableViewDelegate, QHChatScreenCellDelegate>

@property (nonatomic, strong) dispatch_queue_t chatQueue;

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
//@property (nonatomic, strong) QHChatScreenViewCell *chatDataPrototyCell;

@property (nonatomic, strong) NSMutableArray *chatDataList;
@property (nonatomic, strong) NSMutableArray *chatDataTempList;

@property (nonatomic) BOOL bScrollRoll;
@property (nonatomic) BOOL bInBottom;
@property (nonatomic) BOOL bControlTimerClose;
@property (nonatomic) BOOL bReloadByTimer;

@property (nonatomic, strong) UIView *hasNewChatDataView;

@property (nonatomic, weak) id <QHChatScreenDelegate> chatDelegate;
@property (nonatomic, weak) id <QHChatScreenDataSource> chatDataSource;

//@property (nonatomic) CGFloat cellHeigth;//自己计算高度的时候需要

@property (nonatomic, strong) NSTimer *reloadTimer;
@property (nonatomic) NSInteger openReloadTimerCount;
@property (nonatomic) BOOL isReloadTimerRun;
@property (nonatomic) double lastInsertTime;
@property (nonatomic) BOOL bSrollBottomAnimation;

@end

@implementation QHChatScreenView

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
    self.chatDataList = nil;
    self.chatDataTempList = nil;
    _hasNewChatDataView = nil;
    [_reloadTimer invalidate];
    _reloadTimer = nil;
}

+ (QHChatScreenView *)createChatViewToSuperView:(UIView *)superView dataSource:(id<QHChatScreenDataSource>)dataSource delegate:(id<QHChatScreenDelegate>)delegate {
    QHChatScreenView *chatScreenView = [[[NSBundle mainBundle] loadNibNamed:@"QHChatScreenView" owner:nil options:nil] firstObject];
    chatScreenView.chatDataSource = dataSource;
    chatScreenView.chatDelegate = delegate;
    [chatScreenView initChatScreen];
    [superView addSubview:chatScreenView];
    chatScreenView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(chatScreenView);
    [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[chatScreenView]-0-|" options:NSLayoutFormatAlignAllBaseline metrics:0 views:viewsDict]];
    [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[chatScreenView]-0-|" options:NSLayoutFormatAlignAllBaseline metrics:0 views:viewsDict]];
    return chatScreenView;
}

- (void)moveChatViewToSuperView:(UIView *)superView {
    [superView addSubview:self];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(self);
    [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[self]-0-|" options:NSLayoutFormatAlignAllBaseline metrics:0 views:viewsDict]];
    [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[self]-0-|" options:NSLayoutFormatAlignAllBaseline metrics:0 views:viewsDict]];
}

#pragma mark - Private

- (void)setup {
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    self.mainTableView.allowsSelection = NO;
    self.bControlTimerClose = NO;
    if ([[UIDevice currentDevice].systemVersion floatValue] < 9) {
        self.bSrollBottomAnimation = NO;
    }
    else {
        self.bSrollBottomAnimation = NO;
    }

//    UINib *cellNib = [UINib nibWithNibName:@"QHChatScreenViewCell" bundle:nil];
//    [self.mainTableView registerNib:cellNib forCellReuseIdentifier:CHATCELL_IDENTIFIER];
    
    UINib *cellNib = [UINib nibWithNibName:@"QHGifTextViewCell" bundle:nil];
    [self.mainTableView registerNib:cellNib forCellReuseIdentifier:CHATCELL_IDENTIFIER];
    UINib *cellNibHighlight = [UINib nibWithNibName:@"QHHighlightViewCell" bundle:nil];
    [self.mainTableView registerNib:cellNibHighlight forCellReuseIdentifier:HIGHLIGHT_IDENTIFIER];
    
//    self.chatDataPrototyCell = [self.mainTableView dequeueReusableCellWithIdentifier:CHATCELL_IDENTIFIER];
//    self.chatDataPrototyCell.translatesAutoresizingMaskIntoConstraints = NO;
//    self.chatDataPrototyCell.contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)setupData {
    self.chatDataList = [NSMutableArray new];
    self.chatDataTempList = [NSMutableArray new];
    self.bScrollRoll = YES;
    self.chatQueue = dispatch_queue_create("com.qf.chatdata", DISPATCH_QUEUE_SERIAL);
    self.bInBottom = YES;
    self.bReturnScrollScreenView = NO;
    self.bReloadByTimer = NO;
    
//    self.cellWidth = [UIScreen mainScreen].bounds.size.width - 20;
//    CGSize size = [QHChatScreenBaseUtil calculateString:@"陈" size:CGSizeMake(CGFLOAT_MAX, 100) font:FONT_CHATSCREEN_BIGGER];
//    self.cellHeigth = size.height;
    
    self.openReloadTimerCount = 0;
    self.isReloadTimerRun = NO;
    self.cellLandscapeWidth = 0;
    self.bLandscape = NO;
}

//刷新聊天区消息

- (void)p_refreshChatData:(id)chatData {
    [self p_refreshChatData:chatData mutable:NO];
}

- (void)p_refreshChatData:(id)chatData mutable:(BOOL)bMutable {
    if (self.chatDataList.count == 0) {
        if (chatData != nil) {
            if (bMutable == YES) {
                NSMutableArray *chatDataListTemp = [NSMutableArray new];
                for (id data in chatData) {
                    if (![data isKindOfClass:[NSDictionary class]])
                        continue;
                    if ([self p_checkAnalyseData:data] == NO)
                        continue;
                    NSArray *dataArray = [self p_analyseData:data];
                    if (dataArray == nil)
                        continue;
                    NSMutableAttributedString *chatContent = dataArray[0];
                    [chatDataListTemp addObject:@[chatContent, data, @(CellTypeNormal)]];
                }
                if (chatDataListTemp.count > 0) {
                    [self.chatDataList addObjectsFromArray:chatDataListTemp];
                    [chatDataListTemp removeAllObjects];
                }
                chatDataListTemp = nil;
            }
            else {
                if ([self p_checkAnalyseData:chatData] == NO)
                    return;
                NSArray *dataArray = [self p_analyseData:chatData];
                if (dataArray == nil)
                    return;
                NSMutableAttributedString *chatContent = dataArray[0];
                //            NSValue *frameValue = dataArray[1];
    //            NSNumber *height = dataArray[1];
    //            NSNumber *landscapeHeight = dataArray[2];
                [self.chatDataList addObject:@[chatContent, chatData, @(CellTypeNormal)/*, frameValue*//*, height, landscapeHeight*/]];
            }
//            if ([self.chatDelegate getIsAnchor]) {
                [self p_reloadChatScreen:NO];
//            }
            [self.mainTableView reloadData];
            NSInteger counts = [self.mainTableView numberOfRowsInSection:0];
            if (counts > 0) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(counts - 1) inSection:0];
                [self.mainTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO/*self.bSrollBottomAnimation*/];
            }
        }
    }
    else {
        if (chatData != nil) {
            if (bMutable == YES) {
                NSMutableArray *chatDataTempListTemp = [NSMutableArray new];
                for (id data in chatData) {
                    if (![data isKindOfClass:[NSDictionary class]])
                        continue;
                    if ([self p_checkAnalyseData:data] == NO)
                        continue;
                    if (self.chatDataTempList.count > MAX_CHATDATA) {
                        [self.chatDataTempList removeObjectAtIndex:0];
                    }
                    [chatDataTempListTemp addObject:data];
                }
                if (chatDataTempListTemp.count > 0) {
                    [self.chatDataTempList addObjectsFromArray:chatDataTempListTemp];
                    [chatDataTempListTemp removeAllObjects];
                }
                chatDataTempListTemp = nil;
            }
            else {
                if ([self p_checkAnalyseData:chatData] == NO)
                    return;
                if (self.chatDataTempList.count > MAX_CHATDATA) {
                    [self.chatDataTempList removeObjectAtIndex:0];
                }
                [self.chatDataTempList addObject:chatData];
            }
        }
        if (self.bScrollRoll) {
            if (self.chatDataTempList.count <= 0) {
                if (self.bInBottom) {
                    self.hasNewChatDataView.hidden = YES;
                    NSInteger counts = [self.mainTableView numberOfRowsInSection:0];
                    if (counts > 0) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(counts - 1) inSection:0];
                        [self.mainTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:self.bSrollBottomAnimation];
                    }
                }
                return;
            }
//            self.bScrollRoll = NO;
            
            for (int index = 0; index < self.chatDataTempList.count; index++) {
                id chatDataIndex = self.chatDataTempList[index];
                NSString *title = [self p_staticAnalyseData:chatDataIndex];
                
                if ([self p_isFoldEnter:chatDataIndex] == YES) {
                    [self.chatDataList replaceObjectAtIndex:self.chatDataList.count - 1 withObject:@[@(NO), chatDataIndex, @(CellTypeNormal)]];
                }
                else {
                    [self.chatDataList addObject:@[@(NO), chatDataIndex, @(CellTypeNormal)/*, frameValue*//*, height, landscapeHeight*/]];
                }
                if (title != nil) {
                    [self.chatDataList addObject:@[title, chatDataIndex, @(CellTypeHighlight)]];
                }
                chatDataIndex = nil;
            }
            [self.chatDataTempList removeAllObjects];
            if (self.chatDataList.count > MAX_CHATDATA) {
                [self.chatDataList removeObjectsInRange:NSMakeRange(0, self.chatDataList.count - MAX_CHATDATA)];
            }
            
            self.bReloadByTimer = YES;
            if (self.bControlTimerClose == NO) {
                [self p_reloadChatScreen:YES];
            }
            if (self.bInBottom == YES && self.hasNewChatDataView.hidden == NO) {
                self.hasNewChatDataView.hidden = YES;
            }
        }
        else {
            if (self.bInBottom) {
                self.hasNewChatDataView.hidden = YES;
            }
            else {
                self.hasNewChatDataView.hidden = NO;
//                UILabel *titleL = [self.hasNewChatDataView viewWithTag:250];
//                titleL.text = [NSString stringWithFormat:@"+%lu条新消息", (unsigned long)self.chatDataTempList.count];
            }
        }
    }
}

- (BOOL)p_checkAnalyseData:(NSDictionary *)data {
    BOOL bResult = [self.chatDataSource checkPassData:data];
    return bResult;
}

- (NSArray *)p_analyseData:(NSDictionary *)data {
    NSArray *chatContent = [self.chatDataSource analyzeData:data];
    return chatContent;
}

- (NSString *)p_staticAnalyseData:(NSDictionary *)data {
    if ([self.chatDataSource respondsToSelector:@selector(analyzeDataForHighlightTitle:)] == YES) {
        NSString *title = [self.chatDataSource analyzeDataForHighlightTitle:data];
        return title;
    }
    return nil;
}

- (BOOL)p_isFoldEnter:(NSDictionary *)chatDataNew {
    if ([self.chatDataSource respondsToSelector:@selector(isFoldLastChatDataOld:new:)] == YES)
    if (self.chatDataList != nil && self.chatDataList.count >= 1 &&/*设置折叠在大于多少条之后有效*/ chatDataNew != nil) {
        NSDictionary *dataOld = ((NSArray *)self.chatDataList.lastObject)[1];
        return [self.chatDataSource isFoldLastChatDataOld:dataOld new:chatDataNew];
    }
    return NO;
}

- (void)p_reloadChatScreen:(BOOL)bReload {
    if (bReload == self.isReloadTimerRun) {
        return;
    }
    if (bReload) {
        if (_reloadTimer == nil) {
            __weak typeof(self) weakSelf = self;
            _reloadTimer = [NSTimer qheoc_scheduledTimerWithTimeInterval:TIME_REFRESH block:^{
                [weakSelf p_reloadAction];
            } repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.reloadTimer forMode:NSRunLoopCommonModes];
        }
        else {
            [self.reloadTimer setFireDate:[NSDate date]];
        }
    }
    else {
        if (self.reloadTimer == nil) {
            return;
        }
        [self.reloadTimer setFireDate:[NSDate distantFuture]];
    }
    self.isReloadTimerRun = bReload;
}

- (void)p_reloadAction {
    //        dispatch_async(dispatch_get_main_queue(), ^{
//    dispatch_sync(self.chatQueue, ^{
        if (self.chatDataList.count > 0 && self.bReloadByTimer == YES) {
            self.bReloadByTimer = NO;
            [self.mainTableView reloadData];
            NSInteger counts = [self.mainTableView numberOfRowsInSection:0];
            if (counts > 0) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.chatDataList.count - 1) inSection:0];
                [self.mainTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:self.bSrollBottomAnimation];
            }
        }
//    });
//        });
}

#pragma mark - Util

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chatDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    QHChatScreenViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CHATCELL_IDENTIFIER];
//    cell.cellDelegate = self;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    NSMutableAttributedString *chatContent = self.chatDataList[indexPath.row][0];
//    cell.contentLabel.attributedText = chatContent;
////    [cell addHeaderTouches:[self.chatDataList[indexPath.row][2] CGRectValue]];
//    [cell sizeToFit];
    
    
    UITableViewCell *cellResult = nil;
    NSInteger cellType = [self.chatDataList[indexPath.row][2] integerValue];
    switch (cellType) {
        case CellTypeHighlight: {
            QHHighlightViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HIGHLIGHT_IDENTIFIER];
            cell.viewCellDelegate = self;
            [cell labelWithText:self.chatDataList[indexPath.row][0] font:nil height:30];
            cellResult = cell;
            break;
        }
        case CellTypeNormal:
        default: {
            QHGifTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CHATCELL_IDENTIFIER];
            cell.gifTextViewDelegate = self;
            NSMutableAttributedString *chatContent = nil;
            NSArray *contentDataArray = self.chatDataList[indexPath.row];
            id contentData = contentDataArray[0];
            if ([contentData isKindOfClass:[NSMutableAttributedString class]] == YES) {
                chatContent = contentData;
            }
            else {
                NSDictionary *chatDataIndex = contentDataArray[1];
                NSArray *dataArray = [self p_analyseData:chatDataIndex];
                if (dataArray != nil) {
                    chatContent = dataArray[0];
                    //缓存起来
                    NSMutableArray *array = [NSMutableArray arrayWithArray:contentDataArray];
                    array[0] = chatContent;
                    self.chatDataList[indexPath.row] = array;
                }
            }
            cell.gifTextView.attributedText = chatContent;
            cellResult = cell;
            break;
        }
    }
    
    cellResult.layer.shouldRasterize = YES;
    cellResult.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    return cellResult;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSMutableAttributedString *chatContent = self.chatDataList[indexPath.row][0];
//    [((QHGifTextViewCell *)cell).gifTextView setGifAttributedText:chatContent];
//}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.bLandscape == NO) {
//        return [self.chatDataList[indexPath.row][2] floatValue];
//    }
//    else {
//        return [self.chatDataList[indexPath.row][3] floatValue];
//    }

    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self reloadChatScreen:NO];
    if (self.bReturnScrollScreenView) {
        if ([self.chatDelegate respondsToSelector:@selector(scrollScreenView:)]) {
            [self.chatDelegate scrollScreenView:self];
        }
    }
    else {
        if (self.chatDataList.count == 0) {
            return;
        }
        if ([self.chatDelegate respondsToSelector:@selector(scrollScreenView:)]) {
            if (self.mainTableView.contentSize.height >= self.mainTableView.frame.size.height) {
                [self.chatDelegate scrollScreenView:self];
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollChatScreenToBottom:NO];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self scrollChatScreenToBottom:NO];
    }
//    if ([self.chatDelegate respondsToSelector:@selector(didEndDragging:willDecelerate:)]) {
//        [self.chatDelegate didEndDragging:scrollView willDecelerate:decelerate];
//    }
}

#pragma mark - QHGifTextViewCellDelegate

- (void)selectViewCell:(UITableViewCell *)viewCell {
    @try {
        if ([self.chatDelegate respondsToSelector:@selector(chatScreenView:didSelectRowWithData:)]) {
            BOOL bAction = NO;
            
            NSIndexPath *indexPath = [self.mainTableView indexPathForCell:viewCell];
            NSDictionary *data = self.chatDataList[indexPath.row][1];
            //DataSource
            if (bAction == YES) {
                [self.chatDelegate chatScreenView:self didSelectRowWithData:data];
            }
        }
    } @catch (NSException *exception) {
        
    }
}

- (void)deselectViewCell:(UITableViewCell *)viewCell {
    if ([self.chatDelegate respondsToSelector:@selector(chatScreenViewUnselect:)]) {
        [self.chatDelegate chatScreenViewUnselect:self];
    }
}

#pragma mark - Action

- (void)initChatScreen {
    [self setupData];
    [self setup];
}

- (void)insertChatData:(id)data {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (data == nil) {
            return;
        }
        if (![data isKindOfClass:[NSDictionary class]]) {
            return;
        }
        dispatch_sync(self.chatQueue, ^{
            [self p_refreshChatData:data];
        });
    });
}

- (void)insertChatMutableData:(id)data {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (data == nil) {
            return;
        }
        if (![data isKindOfClass:[NSArray class]]) {
            return;
        }
        dispatch_sync(self.chatQueue, ^{
            [self p_refreshChatData:data mutable:YES];
        });
    });
}

- (void)scrollChatScreenToBottom:(BOOL)bBottom {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (bBottom) {
            self.bScrollRoll = YES;
            self.bInBottom = YES;
            self.bControlTimerClose = NO;
            dispatch_sync(self.chatQueue, ^{
                [self p_refreshChatData:nil];
            });
        }
        else {
            if (self.mainTableView.contentSize.height < self.mainTableView.frame.size.height) {
                self.bScrollRoll = YES;
                self.bInBottom = YES;
                self.bControlTimerClose = NO;
                self.hasNewChatDataView.hidden = YES;
                dispatch_sync(self.chatQueue, ^{
                    [self p_refreshChatData:nil];
                });
            }
            else {
                CGFloat offY = self.mainTableView.contentSize.height - self.mainTableView.frame.size.height - self.mainTableView.contentOffset.y;
                if (offY <= 20) {
                    self.bScrollRoll = YES;
                    self.bInBottom = YES;
                    self.bControlTimerClose = NO;
                    self.hasNewChatDataView.hidden = YES;
                    dispatch_sync(self.chatQueue, ^{
                        [self p_refreshChatData:nil];
                    });
                }
                else {
                    self.bScrollRoll = NO;
                    self.bInBottom = NO;
                }
            }
        }
    });
}

- (void)scrollChatScreenToBottom {
    self.hasNewChatDataView.hidden = YES;
    [self scrollChatScreenToBottom:YES];
}

- (void)reloadChatScreen:(BOOL)bReload {
    self.bControlTimerClose = !bReload;
//    if ([self.chatDelegate getIsAnchor]) {
        [self p_reloadChatScreen:bReload];
//    }
}

- (void)clearChatScreen {
    dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_sync(self.chatQueue, ^{
            [self p_reloadChatScreen:NO];
            [self.chatDataList removeAllObjects];
            [self scrollChatScreenToBottom:YES];
            [self.mainTableView reloadData];
            _hasNewChatDataView.hidden = YES;
        });
    });
}

- (IBAction)tapChatScreenAtion:(id)sender {
    if ([self.chatDelegate respondsToSelector:@selector(chatScreenViewUnselect:)]) {
        [self.chatDelegate chatScreenViewUnselect:self];
    }
}

#pragma mark - Get

- (UIView *)hasNewChatDataView {
    if (_hasNewChatDataView == nil) {
        _hasNewChatDataView = [[UIView alloc] initWithFrame:CGRectZero];
        _hasNewChatDataView.backgroundColor = CHATSCREEN_RGBA(0xff, 0xff, 0xff, 1);
        _hasNewChatDataView.layer.cornerRadius = 13;
        _hasNewChatDataView.clipsToBounds = YES;
        
        [self addSubview:_hasNewChatDataView];
        
        _hasNewChatDataView.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *viewsDict = NSDictionaryOfVariableBindings(_hasNewChatDataView);
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_hasNewChatDataView(26)]-0-|" options:NSLayoutFormatAlignAllBaseline metrics:0 views:viewsDict]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_hasNewChatDataView(100)]" options:NSLayoutFormatAlignAllBaseline metrics:0 views:viewsDict]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_hasNewChatDataView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectZero];
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.textColor = CHATSCREEN_RGBA(0xfa, 0xb1, 0x0a, 1);
        titleL.font = [UIFont systemFontOfSize:12];
        titleL.text = @"底部有新消息";//[NSString stringWithFormat:@"+%lu条新消息", (unsigned long)self.chatDataTempList.count];
        titleL.tag = 250;
        [_hasNewChatDataView addSubview:titleL];
        
        titleL.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *subViewsDict = NSDictionaryOfVariableBindings(titleL/*, bgIV*/);
        [_hasNewChatDataView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[titleL]-0-|" options:NSLayoutFormatAlignAllBaseline metrics:0 views:subViewsDict]];
        [_hasNewChatDataView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[titleL]-0-|" options:NSLayoutFormatAlignAllBaseline metrics:0 views:subViewsDict]];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollChatScreenToBottom)];
        [_hasNewChatDataView addGestureRecognizer:tap];
        
        tap = nil;
        titleL = nil;
    }
    return _hasNewChatDataView;
}

@end
