//
//  MMBStatus.m
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/1.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "MMBStatus.h"
#import "MJExtension.h"
#import "MMBPhoto.h"

@implementation MMBStatus

//告诉他 数组里面是什么类型
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"pic_urls" : @"MMBPhoto"};
}

- (NSString *)created_at{
//    NSString *temp = @"";
//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    df.dateFormat = @"yyyy-MM-dd hh:mm:ss";
//    NSDate *date = [NSDate alloc] initWith
//    NSDate *date = [df dateFromString:_created_at];
    return _created_at;
}
@end
