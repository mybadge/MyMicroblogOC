//
//  MMBTabBar.m
//  My-Microblog
//
//  Created by 赵志丹 on 15/11/29.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "MMBTabBar.h"

@interface MMBTabBar ()

@property (nonatomic,weak) UIButton *plusBtn;
@end

@implementation MMBTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *plusBtn = [[UIButton alloc] init];
        [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
        [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
        
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
        plusBtn.size = plusBtn.currentBackgroundImage.size;
        self.plusBtn = plusBtn;
        [self addSubview:plusBtn];
        [plusBtn addTarget:self action:@selector(plusBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)plusBtnClick{
    if ([self.delegate respondsToSelector:@selector(tabBarDidClickPlusButton:)]) {
        [self.delegate tabBarDidClickPlusButton:self];
    } 

}


- (void)layoutSubviews{
    [super layoutSubviews];
    //MMBLog(@"tabBar.height= %f",self.height);
    self.plusBtn.centerX = self.width * 0.5;
    self.plusBtn.centerY = self.height * 0.5;
    int tabBarButtonIndex = 0;
    Class class = NSClassFromString(@"UITabBarButton");
    CGFloat tabBarButtonWidth = self.width / 5;
    for (MMBTabBar *tabBar in self.subviews) {
        if ([tabBar isKindOfClass:class]) {
            tabBar.width = tabBarButtonWidth;
            tabBar.x = tabBarButtonWidth * tabBarButtonIndex;
            tabBarButtonIndex++;
            if (tabBarButtonIndex == 2) {
                tabBarButtonIndex++;
            }
        }
    }
}

@end
