//
//  MMBEmotionTool.m
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/11.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "MMBEmotionTool.h"
#import "MJExtension.h"
#import "MMBEmotion.h"

// 最近表情的存储路径
#define MMBRecentEmotionsPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"emotions.archive"]

@implementation MMBEmotionTool
static NSMutableArray *_recentEmotions;
/**
 *  表情字典 里面放的是 [哭] = d_cry.png
 */
static NSMutableDictionary *_emotionDict;

+ (void)initialize{
    //加载沙盒中的表情
    //NSLog(NSHomeDirectory());
    _recentEmotions = [NSKeyedUnarchiver unarchiveObjectWithFile:MMBRecentEmotionsPath];
    if (_recentEmotions == nil) {
        _recentEmotions = [NSMutableArray array];
    }
    
    
    //创建表情数组
    NSMutableArray *arrayM = [NSMutableArray array];
    arrayM = [MMBEmotion mj_objectArrayWithFilename:@"EmotionIcons/default/info.plist"];
    [arrayM addObjectsFromArray:[MMBEmotion mj_objectArrayWithFilename:@"EmotionIcons/lxh/info.plist"]];
    
    _emotionDict = [NSMutableDictionary dictionaryWithCapacity:arrayM.count];
    //遍历数组给字典赋值
    [arrayM enumerateObjectsUsingBlock:^(MMBEmotion  *emotion, NSUInteger idx, BOOL * _Nonnull stop) {
        _emotionDict[emotion.chs] = emotion.png;
    }];

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

/**
 *  根据 [哭] 加载 哭图片
 */
+ (UIImage *)getEmotionWithName:(NSString *)name{
    NSString *currentPath = _emotionDict[name];
    if (currentPath) {
        return [UIImage imageNamed:currentPath];
    }
    return nil;
}



@end
