//
//  MMBAccountTool.m
//  My-Microblog
//
//  Created by 赵志丹 on 15/11/30.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#define MMBAccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.archive"]

#import "MMBAccountTool.h"
#import "MMBAccount.h"


@implementation MMBAccountTool


+ (void)saveAccount:(MMBAccount *)account{
    // 获得账号存储的时间（accessToken的产生时间）
    account.created_time = [NSDate date];
    // 自定义对象的存储必须用NSKeyedArchiver，不再有什么writeToFile方法
    [NSKeyedArchiver archiveRootObject:account toFile:MMBAccountPath];
}

+ (MMBAccount *)account{
    // 加载模型
    MMBAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:MMBAccountPath];
    
    //监测是否过期
    long long expires_in = [account.expires_in longLongValue];
    //获得过期时间
    NSDate *expiresTime = [account.created_time dateByAddingTimeInterval:expires_in];
    //获得当前时间
    NSDate *date = [NSDate date];
    
    // 如果expiresTime <= now，过期
    /**
     NSOrderedAscending = -1L, 升序，右边 > 左边
     NSOrderedSame, 一样
     NSOrderedDescending 降序，右边 < 左边
     */
    NSComparisonResult result = [expiresTime compare:date];
    if (result != NSOrderedDescending) {//过期
        return nil;
    }
    
    return account;
}
@end
