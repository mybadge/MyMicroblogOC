//
//  MMBTabBar.h
//  My-Microblog
//
//  Created by 赵志丹 on 15/11/29.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMBTabBar;
@protocol MMBTabBarDelegate <UITabBarDelegate>

@optional
- (void)tabBarDidClickPlusButton:(MMBTabBar *)tabBar;
@end

@interface MMBTabBar : UITabBar

@property (nonatomic,weak) id<MMBTabBarDelegate> delegate;

@end
