//
//  MMBaaa.h
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/11.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMBaaa : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *title;
- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)aaaWithDict:(NSDictionary *)dict;

+ (NSMutableArray *)aaas;

@end
