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

-  (void)setEmotion:(MMBEmotion *)emotion{
    _emotion = emotion;
    
    self.emotionButton.emotion = emotion;
}


+ (instancetype)popView{
    return [[[NSBundle mainBundle] loadNibNamed:@"MMBEmotionPopView" owner:nil options:nil] lastObject];
}

@end
