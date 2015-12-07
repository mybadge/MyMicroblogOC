//
//  MMBEmotionListView.h
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/6.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import <UIKit/UIKit.h>
//  表情键盘顶部的内容:scrollView + pageControl
@interface MMBEmotionListView : UIView
/** 表情数组(里面装的是MMBEmotion模型) */
@property (nonatomic, strong) NSArray *emotions;
@end
