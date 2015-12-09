//
//  MMBEmotionTextView.h
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/8.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "MMBTextView.h"
@class MMBEmotion;

@interface MMBEmotionTextView : MMBTextView
/**
 *  插入表情
 */
- (void)insertEmotion:(MMBEmotion *)emotion;


/**
 *  UITextView的富文本字符串
 */
- (NSString *)fullText;
@end
