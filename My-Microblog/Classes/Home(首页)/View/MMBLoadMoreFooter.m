//
//  MMBLoadMoreFooter.m
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/1.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "MMBLoadMoreFooter.h"

@implementation MMBLoadMoreFooter
+ (instancetype)footer{
    return [[[NSBundle mainBundle] loadNibNamed:@"MMBLoadMoreFooter" owner:nil options:nil] lastObject];
}
@end
