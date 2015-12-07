//
//  MMBEmotionTabbar.h
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/6.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    /** 最近 */
    MMBEmotionTabBarButtonTypeRecent,
    /** 默认 */
    MMBEmotionTabBarButtonTypeDefault,
    /** emoji */
    MMBEmotionTabBarButtonTypeEmoji,
    /** 浪小花 */
    MMBEmotionTabBarButtonTypeLxh
    
} MMBEmotionTabBarButtonType;

@class MMBEmotionTabBar;
@protocol MMBEmotionTabBarDelegate <NSObject>

@optional
- (void)emotionTabBar:(MMBEmotionTabBar *)tabBar didSelectedButtonType:(MMBEmotionTabBarButtonType)buttonType;
@end

@interface MMBEmotionTabBar : UIView
@property (nonatomic, weak) id<MMBEmotionTabBarDelegate> delegate;

+ (instancetype)tabBar;

@end
