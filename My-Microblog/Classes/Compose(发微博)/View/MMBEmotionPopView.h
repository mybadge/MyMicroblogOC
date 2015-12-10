//
//  MMBEmotionPopView.h
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/8.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MMBEmotion;
/** 用于点击表情按钮,显示上面的指示头像 */
@interface MMBEmotionPopView : UIView
@property (nonatomic, strong) MMBEmotion *emotion;

+ (instancetype)popView;

/**
 *  添加显示层
 */
- (void)showFrom:(UIButton *)btn;
@end
