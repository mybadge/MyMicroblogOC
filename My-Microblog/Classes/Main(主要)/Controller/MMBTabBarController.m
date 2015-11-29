//
//  MMBTabBarController.m
//  My-Microblog
//
//  Created by 赵志丹 on 15/11/29.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "MMBTabBarController.h"
#import "MMBHomeViewController.h"
#import "MMBDiscoverViewController.h"
#import "MMBMessageCenterViewController.h"
#import "MMBProfileViewController.h"
#import "MMBNavigationController.h"

@interface MMBTabBarController ()

@end

@implementation MMBTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化控制器
    MMBHomeViewController *homeVc = [[MMBHomeViewController alloc] init];
    [self addCHildVc:homeVc title:@"首页" image:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
    MMBMessageCenterViewController *messageCenterVc = [[MMBMessageCenterViewController alloc] init];
    [self addCHildVc:messageCenterVc title:@"消息" image:@"tabbar_message_center" selectedImage:@"tabbar_message_center_selected"];
    MMBDiscoverViewController *discoverVc = [[MMBDiscoverViewController alloc] init];
    [self addCHildVc:discoverVc title:@"发现" image:@"tabbar_discover" selectedImage:@"tabbar_discover_selected"];
    
    MMBProfileViewController *profileVc = [[MMBProfileViewController alloc] init];
    [self addCHildVc:profileVc title:@"我" image:@"tabbar_profile" selectedImage:@"tabbar_profile_selected"];
    
}


/**
 *  添加一个自控制器
 *
 *  @param childVc       自控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中图片
 */
- (void)addCHildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage{

    // 设置子控制器的文字
    childVc.title = title; // 同时设置tabbar和navigationBar的文字
    //childVc.tabBarItem.title = title;     // 设置tabbar的文字
    //childVc.navigationItem.title = title; // 设置navigationBar的文字
    
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//设置图片渲染方式为原始状态
    
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = MMBColor(123, 123, 123);
    
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
    //设置随机色
    childVc.view.backgroundColor = MMBRandomColor;
    //先给外面传进来的小控制器 包装 一个导航控制器
    MMBNavigationController *nav = [[MMBNavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
}


@end
