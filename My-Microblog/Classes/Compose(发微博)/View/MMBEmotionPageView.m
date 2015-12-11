//
//  MMBEmotionPageView.m
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/7.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "MMBEmotionPageView.h"
#import "MMBEmotion.h"
#import "NSString+Emoji.h"
#import "MMBEmotionButton.h"
#import "MMBEmotionPopView.h"
#import "MMBEmotionTool.h"

@interface MMBEmotionPageView ()
@property (nonatomic, weak) UIButton *deleteButton;
@property (nonatomic, weak) MMBEmotionPopView *popView;
@end
@implementation MMBEmotionPageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        //添加长按手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressPageView:)];
        [self addGestureRecognizer:longPress];
    }
    return self;
}

- (void)setEmotions:(NSArray *)emotions{
    _emotions = emotions;
    NSInteger count = emotions.count;
    for (int i = 0 ; i < count; ++i) {
        MMBEmotionButton *btn = [[MMBEmotionButton alloc] init];
        //btn.backgroundColor = MMBRandomColor;
        MMBEmotion *emotion = emotions[i];
        btn.emotion = emotion;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    // 内边距(四周)
    CGFloat inset = 20;
    NSUInteger count = self.emotions.count;
    CGFloat btnW = (self.width - 2 * inset) / MMBEmotionMaxCols;
    CGFloat btnH = (self.height - inset) / MMBEmotionMaxRows;
    for (int i = 0; i<count; i++) {
        UIButton *btn = self.subviews[i];
        btn.width = btnW;
        btn.height = btnH;
        btn.x = inset + (i%MMBEmotionMaxCols) * btnW;
        btn.y = inset + (i/MMBEmotionMaxCols) * btnH;
    }
    self.deleteButton.width = btnW;
    self.deleteButton.height = btnH;
    self.deleteButton.x = self.width - inset - btnW;
    self.deleteButton.y = self.height - btnH;
}

- (void)btnClick:(MMBEmotionButton *)btn{
    //添加放大镜按钮
    [self.popView showFrom:btn];
    
    //UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    //CGRect newFrame = [btn convertRect:btn.bounds toView:nil];
    //self.popView.y = CGRectGetMidY(newFrame) - self.popView.height;
    //self.popView.centerX = CGRectGetMidX(newFrame);
    //
    //[window addSubview:self.popView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.popView removeFromSuperview];
    });
    [self selectedEmotion:btn.emotion];
}

- (void)selectedEmotion:(MMBEmotion *)emotion{
    //将表情插入到沙盒
    [MMBEmotionTool addRecentEmotion:emotion];
    
    //发出通知
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[MMBSelectEmotionKey] = emotion;
    [MMBNotificationCenter postNotificationName:MMBEmotionDidSelectedNotification object:nil userInfo:userInfo];
}



- (void)deleteButtonClick{
    [MMBNotificationCenter postNotificationName:MMBEmotionDidDeletedNotification object:nil];
}

- (MMBEmotionPopView *)popView{
    if (!_popView) {
        _popView = [MMBEmotionPopView popView];
    }
    return _popView;
}

- (void)longPressPageView:(UILongPressGestureRecognizer *)recognizer{
    CGPoint location = [recognizer locationInView:recognizer.view];
    MMBEmotionButton *btn = [self emotionButtonWithLocation:location];
    switch (recognizer.state) {
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded://手指已经不再触摸pageView了
            [self.popView removeFromSuperview];
            if (btn){
                [self selectedEmotion:btn.emotion];
            }
            break;
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
            [self.popView showFrom:btn];
            break;
        default:
            break;
    }
}

- (MMBEmotionButton *)emotionButtonWithLocation:(CGPoint)location{
    NSUInteger count = self.emotions.count;
    for (int i = 0 ; i < count; ++i) {
        MMBEmotionButton *btn = self.subviews[i];
        if (CGRectContainsPoint(btn.frame, location)) {
            //已经找到手指所在的表情按钮了,就没有必要在循环下去了
            return btn;
        }
    }
    return nil;
}

- (UIButton *)deleteButton{
    //创建删除按钮
    if (!_deleteButton) {
        UIButton *deleteButton = [[UIButton alloc] init];
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        [deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteButton];
        _deleteButton = deleteButton;
    }
    return _deleteButton;
}
@end












