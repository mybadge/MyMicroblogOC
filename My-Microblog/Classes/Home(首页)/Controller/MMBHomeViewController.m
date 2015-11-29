//
//  MMBHomeViewController.m
//  My-Microblog
//
//  Created by 赵志丹 on 15/11/29.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "MMBHomeViewController.h"
#import "MMBDropdownMenu.h"
#import "MMBTitleMenuViewController.h"

@interface MMBHomeViewController ()<MMBDropdownMenuDelegate>

@end

@implementation MMBHomeViewController

- (void)friendSearch{
    NSLog(@"%s",__func__);
}

- (void)pop{
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //这里有个注意点,若是在创建tabBarController 时 为每个子控制器添加了背景颜色的话,就会创建该控制器并且调用viewDidLoad 方法,而此时NavigationController还没有被创建,所以此时设置导航栏上面的内容是显示不出来的.
  
    /* 设置导航栏上面的内容 */
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithTarget:self action:@selector(friendSearch) image:@"navigationbar_friendsearch" highImage:@"navigationbar_friendsearch_highlighted"];
    //设置右边按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTarget:self action:@selector(pop) image:@"navigationbar_pop" highImage:@"navigationbar_pop_highlighted"];

    //设置中间标题按钮
    UIButton *titleButton = [[UIButton alloc] init];
    titleButton.width = 150;
    titleButton.height = 30;
    [titleButton setTitle:@"首页" forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    titleButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [titleButton setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
    [titleButton setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateSelected];
    titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, 70, 0, 0);
    titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 40);
    
    [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = titleButton;
    
}

- (void)titleClick:(UIButton *)sender{
    MMBDropdownMenu *menu = [MMBDropdownMenu menu];
    menu.delegate = self;
    MMBTitleMenuViewController *titleMenuVc = [[MMBTitleMenuViewController alloc] init];
    titleMenuVc.view.width = 150;
    titleMenuVc.view.height = 150;
    menu.contentController = titleMenuVc;
    [menu showFrom:sender];
}

- (void)dropdownMenuDidShow:(MMBDropdownMenu *)menu{
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    titleButton.selected = YES;
}

- (void)dropdownMenuDidDismiss:(MMBDropdownMenu *)menu{
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    titleButton.selected = NO;
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}


@end
