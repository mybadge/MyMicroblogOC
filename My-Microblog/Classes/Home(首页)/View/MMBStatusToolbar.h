//
//  MMBStatusToolbar.h
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/2.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MMBStatus;

@interface MMBStatusToolbar : UIView
@property (nonatomic,strong)MMBStatus *status;
+ (instancetype)toolbar;
@end
