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

/** 微博配图地址,多图时返回多图连接,无配图时返回[] */
@property (nonatomic, strong) NSArray *pic_urls;

/** 被转发的原微博信息字段,当该微博为转发微博时返回 */
@property (nonatomic, strong) MMBStatus *retweeted_status;

/**	int	转发数*/
@property (nonatomic, assign) NSInteger reposts_count;
/**	int	评论数*/
@property (nonatomic, assign) NSInteger comments_count;
/**	int	表态数*/
@property (nonatomic, assign) NSInteger attitudes_count;

@end
