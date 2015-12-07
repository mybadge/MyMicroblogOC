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
#import "MMBEmotion.h"
#import "MJExtension.h"


@interface MMBEmotioinKeyBoard ()<MMBEmotionTabBarDelegate>

/** 保存正在显示的listView */
@property (nonatomic, weak) MMBEmotionListView *showingListView;

/** 表情内容 */
@property (nonatomic, strong) MMBEmotionListView *recentListView;
@property (nonatomic, strong) MMBEmotionListView *defaultListView;
@property (nonatomic, strong) MMBEmotionListView *emojiListView;
@property (nonatomic, strong) MMBEmotionListView *lxhListView;

/** tabBar */
@property (nonatomic, weak) MMBEmotionTabBar *tabBar;
@end
@implementation MMBEmotioinKeyBoard

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //这里不用创建showingListView, 在调用tabBar按钮的点击事件时,就会调用初始化方法,并设置frame
        //MMBEmotionListView *showingListView = [[MMBEmotionListView alloc] init];
        //showingListView.backgroundColor = MMBRandomColor;
        //[self addSubview:showingListView];
        //self.emojiListView = showingListView;
        
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
    
    self.showingListView.width = self.width;
    self.showingListView.height = self.tabBar.y;
}

#pragma mark -MMBEmotionTabBar代理方法
/** 这里 把键盘视图添加给showingListView,并设置frame以供显示 */
- (void)emotionTabBar:(MMBEmotionTabBar *)tabBar didSelectedButtonType:(MMBEmotionTabBarButtonType)buttonType{
    //移除上一词的表情图片.
    [self.showingListView removeFromSuperview];
    switch (buttonType) {
        case MMBEmotionTabBarButtonTypeRecent:
            [self addSubview: self.recentListView];
            break;
        case MMBEmotionTabBarButtonTypeDefault:
            [self addSubview:self.defaultListView];
            break;
        case MMBEmotionTabBarButtonTypeEmoji:
            [self addSubview:self.emojiListView];
            break;
        case MMBEmotionTabBarButtonTypeLxh:
            [self addSubview:self.lxhListView];
            break;
        default:
            break;
    }
    //设置正在显示的listView
    self.showingListView = [self.subviews lastObject];
    //设置listView的frame, 被动调用 layoutSubViews方法
    [self setNeedsLayout];
}

#pragma mark - 懒加载
- (MMBEmotionListView *)recentListView{
    if (!_recentListView) {
        _recentListView = [[MMBEmotionListView alloc] init];
       //这里 waiting ...
    }
    return _recentListView;
}

- (MMBEmotionListView *)defaultListView{
    if (!_defaultListView) {
        _defaultListView = [[MMBEmotionListView alloc] init];
        NSArray *array = [MMBEmotion mj_objectArrayWithFilename:@"EmotionIcons/default/info.plist"];
        self.defaultListView.emotions = array;
    }
    return _defaultListView;
}

- (MMBEmotionListView *)emojiListView{
    if (!_emojiListView) {
        _emojiListView = [[MMBEmotionListView alloc] init];
         NSArray *array = [MMBEmotion mj_objectArrayWithFilename:@"EmotionIcons/emoji/info.plist"];
        _emojiListView.emotions = array;
    }
    return _emojiListView;
}

- (MMBEmotionListView *)lxhListView{
    if (!_lxhListView) {
        _lxhListView = [[MMBEmotionListView alloc] init];
        NSArray *array = [MMBEmotion mj_objectArrayWithFilename:@"EmotionIcons/lxh/info.plist"];
        _lxhListView.emotions = array;
     }
    return _lxhListView;
}



@end
