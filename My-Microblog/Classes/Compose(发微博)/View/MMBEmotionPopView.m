//
//  MMBEmotionPopView.m
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/8.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "MMBEmotionPopView.h"
#import "MMBEmotionButton.h"
#import "MMBEmotion.h"
#import "NSString+Emoji.h"

@interface MMBEmotionPopView ()
@property (weak, nonatomic) IBOutlet MMBEmotionButton *emotionButton;

@end
@implementation MMBEmotionPopView
/*** 添加显示层 */
- (void)showFrom:(MMBEmotionButton *)btn{
    self.emotion = btn.emotion;
    //添加放大镜按钮
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    CGRect newFrame = [btn convertRect:btn.bounds toView:nil];
    self.y = CGRectGetMidY(newFrame) - self.height;
    self.centerX = CGRectGetMidX(newFrame);
    [window addSubview:self];
}

-  (void)setEmotion:(MMBEmotion *)emotion{
    _emotion = emotion;
    
    self.emotionButton.emotion = emotion;
}


+ (instancetype)popView{
    return [[[NSBundle mainBundle] loadNibNamed:@"MMBEmotionPopView" owner:nil options:nil] lastObject];
}


@end
