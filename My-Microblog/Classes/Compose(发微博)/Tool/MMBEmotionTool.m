//
//  MMBEmotionTool.m
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/11.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "MMBEmotionTool.h"
// 最近表情的存储路径
#define MMBRecentEmotionsPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"emotions.archive"]

@implementation MMBEmotionTool
static NSMutableArray *_recentEmotions;
+ (void)initialize{
    //加载沙盒中的表情
    //NSLog(NSHomeDirectory());
    _recentEmotions = [NSKeyedUnarchiver unarchiveObjectWithFile:MMBRecentEmotionsPath];
    if (_recentEmotions == nil) {
        _recentEmotions = [NSMutableArray array];
    }
}

+ (void)addRecentEmotion:(MMBEmotion *)emotion{
    
    //要解决重复添加的问题
    [_recentEmotions removeObject:emotion];
    
    
    //将表情插入到数组中的最前面
    [_recentEmotions insertObject:emotion atIndex:0];
    
    //将所有表情插入到沙盒中
    [NSKeyedArchiver archiveRootObject:_recentEmotions toFile:MMBRecentEmotionsPath];
}

/**
 *  返回装着MMBEmotion 模型的数组
 */
+ (NSArray *)recentEmotions{
    
    return _recentEmotions;
}
@end
