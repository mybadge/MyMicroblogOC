//
//  MMBUser.h
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/1.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    MMBUserVerifiedTypeNone = -1, // 没有任何认证
    
    MMBUserVerifiedPersonal = 0,  // 个人认证
    
    MMBUserVerifiedOrgEnterprice = 2, // 企业官方：CSDN、EOE、搜狐新闻客户端
    MMBUserVerifiedOrgMedia = 3, // 媒体官方：程序员杂志、苹果汇
    MMBUserVerifiedOrgWebsite = 5, // 网站官方：猫扑
    
    MMBUserVerifiedDaren = 220 // 微博达人
} MMBUserVerifiedType;

@interface MMBUser : NSObject
/** string 字符串型的用户 UID */
@property (nonatomic,copy) NSString *idstr;

/** string 友好显示名称 */
@property (nonatomic,copy) NSString *name;

/** string 用户头像地址, 50*50像素 */
@property (nonatomic,copy) NSString *profile_image_url;

/** 会员类型 > 2 代表是会员 */
@property (nonatomic,assign) NSInteger mbtype;

/** 会员等级 */
@property (nonatomic,assign) NSInteger mbrank;

/** bool 是否是Vip */
@property (nonatomic,assign, getter=isVip) BOOL vip;

/** 认证类型 */
@property (nonatomic, assign) MMBUserVerifiedType verified_type;

@end
