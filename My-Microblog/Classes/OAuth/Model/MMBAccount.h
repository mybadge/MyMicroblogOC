//
//  MMBAccount.h
//  My-Microblog
//
//  Created by 赵志丹 on 15/11/30.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMBAccount : NSObject<NSCoding>
//2015-11-30 22:47:59.327 My-Microblog[6239:191684] 请求成功-{
//    "access_token" = "2.00qcxPXFWPjfiC9eefed557816UaRC";
//    "expires_in" = 157679999;
//    "remind_in" = 157679999;
//    uid = 5072087372;
//}

/**　string	用于调用access_token，接口获取授权后的access token。*/
@property (nonatomic, copy) NSString *access_token;

/**　string	access_token的生命周期，单位是秒数。*/
@property (nonatomic, copy) NSNumber *expires_in;

/**　string	当前授权用户的UID。*/
@property (nonatomic, copy) NSString *uid;

/**	access token的创建时间 */
@property (nonatomic, strong) NSDate *created_time;

/** name 用户昵称 */
@property (nonatomic,copy) NSString *name;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)accountWithDict:(NSDictionary *)dict;



@end
