//
//  MMBEmotioinKeyBoard.m
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/6.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "MMBEmotioinKeyBoard.h"
#import "MMBEmotionListView.h"
#import "MMBEmotionTabBar.h"

@interface MMBEmotioinKeyBoard ()<MMBEmotionTabBarDelegate>
@property (nonatomic, weak) MMBEmotionListView *emojilistView;
@property (nonatomic, weak) MMBEmotionTabBar *tabBar;
@end
@implementation MMBEmotioinKeyBoard

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        MMBEmotionListView *emojilistView = [[MMBEmotionListView alloc] init];
        emojilistView.backgroundColor = MMBRandomColor;
        [self addSubview:emojilistView];
        self.emojilistView = emojilistView;
        
        MMBEmotionTabBar *tabBar = [[MMBEmotionTabBar alloc] init];
        //tabBar.backgroundColor = MMBRandomColor;
        tabBar.delegate = self;
        [self addSubview:tabBar];
        self.tabBar = tabBar;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.tabBar.height = 37;
    self.tabBar.y = self.height - self.tabBar.height;
    self.tabBar.width = self.width;
    self.emojilistView.width = self.width;
    self.emojilistView.height = self.tabBar.y;
}

- (void)emotionTabBar:(MMBEmotionTabBar *)tabBar didSelectedButtonType:(MMBEmotionTabBarButtonType)buttonType{
    switch (buttonType) {
        case MMBEmotionTabBarButtonTypeRecent:
            NSLog(@"最近");
            break;
        case MMBEmotionTabBarButtonTypeDefault:
            NSLog(@"默认");
            break;
        case MMBEmotionTabBarButtonTypeEmoji:
            NSLog(@"Emoji");
            break;
        case MMBEmotionTabBarButtonTypeLxh:
            NSLog(@"浪小花");
            break;
        default:
            break;
    }
}

@end
