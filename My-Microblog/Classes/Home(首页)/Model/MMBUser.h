//
//  MMBUser.h
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/1.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMBUser : NSObject
/** string 字符串型的用户 UID */
@property (nonatomic,copy) NSString *idstr;

/** string 友好显示名称 */
@property (nonatomic,copy) NSString *name;

/** string 用户头像地址, 50*50像素 */
@property (nonatomic,copy) NSString *profile_image_url;
@end
