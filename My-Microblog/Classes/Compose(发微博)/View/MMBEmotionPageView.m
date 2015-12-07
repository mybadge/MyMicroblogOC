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

@implementation MMBEmotionPageView

- (void)setEmotions:(NSArray *)emotions{
    _emotions = emotions;
    NSInteger count = emotions.count;
    for (int i = 0 ; i < count; ++i) {
        UIButton *btn = [[UIButton alloc] init];
        MMBEmotion *emotion = emotions[i];
        if (emotion.png) {//有图片
            [btn setImage:[UIImage imageNamed:emotion.png] forState:UIControlStateNormal];
        }else if (emotion.code) {
            [btn setTitle:emotion.code.emoji forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:32];
        }
        [self addSubview:btn];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
//    //内边距 (四周)
//    CGFloat inset = 20;
//    NSUInteger count = self.subviews.count;
//    CGFloat btnW = (self.width - 2 * inset) / MMBEmotionMaxCols;
//    CGFloat btnH = (self.height - 2 * inset) / MMBEmotionMaxRows;
//    for (int i = 0 ; i < count; ++i) {
//        UIButton *btn = self.subviews[i];
//        btn.width = btnW;
//        btn.height = btnH;
//        int col = i % MMBEmotionMaxCols;
//        btn.x = inset + col * btnW;
//        int row = i / MMBEmotionMaxCols;
//        btn.y = inset + row * btnH;
//    }
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

}

@end
