//
//  MMBUser.m
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/1.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "MMBUser.h"

@implementation MMBUser

- (void)setMbtype:(NSInteger)mbtype
{
    _mbtype = mbtype;
    
    self.vip = mbtype > 2;
}
@end
