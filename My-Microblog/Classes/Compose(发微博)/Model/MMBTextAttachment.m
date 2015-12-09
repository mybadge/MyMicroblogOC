//
//  MMBTextAttachment.m
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/9.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "MMBTextAttachment.h"
#import "MMBEmotion.h"

@implementation MMBTextAttachment

- (void)setEmotion:(MMBEmotion *)emotion{
    _emotion = emotion;
    //附件类
    self.image = [UIImage imageNamed:emotion.png];
}
@end
