//
//  MMBNavigationController.m
//  My-Microblog
//
//  Created by 赵志丹 on 15/11/29.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "MMBNavigationController.h"


@implementation MMBNavigationController

- (void)viewDidLoad{
    //设置整个项目所有Item的主题样式
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    //设置普通状态
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    //设置不可用状态
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.7];
    disableTextAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    [item setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
    
    
//    [self.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] }];

}

+ (void)initialize{
   //    // 设置整个项目所有item的主题样式
//    UIBarButtonItem *item = [UIBarButtonItem appearance];
//    
//    // 设置普通状态
//    // key：NS****AttributeName
//    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
//    textAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
//    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
//    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
//    
//    [item setTintColor:[UIColor blackColor]];
//    // 设置不可用状态
//    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
//    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.7];
//    disableTextAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
//    [item setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
    

}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //这时push进来的Controller 不是第一个控制器,也就是说不是跟控制器
    if (self.viewControllers.count > 0) {
        //自动显示和隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    //设置导航栏上的内容
    viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithTarget:self action:@selector(back) image:@"navigationbar_back" highImage:@"navigationbar_back_highlighted"];
    viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTarget:self action:@selector(more) image:@"navigationbar_more" highImage:@"navigationbar_more_highlighted"];
    
    [super pushViewController:viewController animated:animated];
}

- (void)back{
    [self popViewControllerAnimated:YES];
}

- (void)more{
    [self popToRootViewControllerAnimated:YES];
}

@end
