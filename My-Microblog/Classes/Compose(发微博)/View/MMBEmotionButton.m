//
//  MMBEmotionButton.m
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/8.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "MMBEmotionButton.h"
#import "NSString+Emoji.h"
#import "MMBEmotion.h"


@implementation MMBEmotionButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    self.titleLabel.font = [UIFont systemFontOfSize:32];
    [self setAdjustsImageWhenHighlighted:NO];
}


- (void)setEmotion:(MMBEmotion *)emotion{
    _emotion = emotion;
    if (emotion.png) {//有图片
        [self setImage:[UIImage imageNamed:emotion.png] forState:UIControlStateNormal];
    }else if (emotion.code) {//emoji图片
        [self setTitle:emotion.code.emoji forState:UIControlStateNormal];
    }
}

@end
