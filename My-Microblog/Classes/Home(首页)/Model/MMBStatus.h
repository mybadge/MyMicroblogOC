//
//  MMBStatus.h
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/1.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MMBUser;

@interface MMBStatus : NSObject
/** string 字符串型的微博ID */
@property (nonatomic, copy) NSString *idstr;

/** string 微博信息内容 */
@property (nonatomic, copy) NSString *text;

/** 微博作者的用户信息字段 */
@property (nonatomic, strong) MMBUser *user;

/** string 微博创建时间 */
@property (nonatomic, copy) NSString *created_at;

/** 微博来源 */
@property (nonatomic, copy) NSString *source;


@end
