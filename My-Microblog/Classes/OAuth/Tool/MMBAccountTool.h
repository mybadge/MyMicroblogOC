//
//  MMBAccountTool.h
//  My-Microblog
//
//  Created by 赵志丹 on 15/11/30.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MMBAccount;

@interface MMBAccountTool : NSObject

/**
 *  存储账号信息
 *
 *  @param account 账号模型
 */
+ (void)saveAccount:(MMBAccount *)account;

/**
 *  返回账号信息
 *
 *  @return 账号模型（如果账号过期，返回nil）
 */
+ (MMBAccount *)account;
@end
