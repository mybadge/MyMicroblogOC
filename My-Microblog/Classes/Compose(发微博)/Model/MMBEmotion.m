//
//  MMBEmotion.m
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/7.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "MMBEmotion.h"
#import "NSObject+MJCoding.h"

@implementation MMBEmotion
+ (NSArray *)mj_allowedCodingPropertyNames{
    return @[@"chs", @"png", @"code"];
}
MJCodingImplementation


/**
 *  判断两个对象是否是同一个对象,默认是判断地址相同,而我想判断的两个模型中数据内容是否相同
 */
- (BOOL)isEqual:(MMBEmotion *)object{
    return [self.chs isEqualToString:object.chs] || [self.code isEqualToString:object.code];
}

@end
