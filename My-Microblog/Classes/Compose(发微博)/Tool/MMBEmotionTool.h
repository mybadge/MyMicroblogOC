//
//  MMBEmotionTool.h
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/11.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MMBEmotion;

@interface MMBEmotionTool : NSObject
+ (void)addRecentEmotion:(MMBEmotion *)emotion;

+ (NSArray *)recentEmotions;

/**
 *  根据显示名称,获取图片对象  例如 [马到成功] -> UIImage
 */
+ (UIImage *)getEmotionWithName:(NSString *)name;
@end
