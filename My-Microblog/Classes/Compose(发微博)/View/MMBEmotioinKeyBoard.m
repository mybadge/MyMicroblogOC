//
//  MMBEmotioinKeyBoard.m
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/6.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "MMBEmotioinKeyBoard.h"
#import "MMBEmotionListView.h"
#import "MMBEmotionTabbar.h"

@interface MMBEmotioinKeyBoard ()
@property (nonatomic, weak) MMBEmotionListView *emojilistView;
@property (nonatomic, weak) MMBEmotionTabbar *tabBar;
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
        
        MMBEmotionTabbar *tabBar = [[MMBEmotionTabbar alloc] init];
        tabBar.backgroundColor = MMBRandomColor;
        [self addSubview:tabBar];
        self.tabBar = tabBar;
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.tabBar.height = 39;
    self.tabBar.y = self.height - self.tabBar.height;
    self.tabBar.width = self.width;
    self.emojilistView.width = self.width;
    self.emojilistView.height = self.tabBar.y;
}
@end
