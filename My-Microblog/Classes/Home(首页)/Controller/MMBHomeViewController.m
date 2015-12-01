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
#import "MMBNetworkTool.h"
#import "MMBAccount.h"
#import "MMBAccountTool.h"
#import "MMBTitleButton.h"
#import "UIImageView+WebCache.h"
#import "MMBUser.h"
#import "MMBStatus.h"
#import "MJExtension.h"

@interface MMBHomeViewController ()<MMBDropdownMenuDelegate>

/**
 * 微博数组 (里面放的都是微博字典, 一个字典对象就代表一条微博)
 */
@property (nonatomic,strong) NSMutableArray *statuses;
@end

@implementation MMBHomeViewController

- (NSMutableArray *)statuses{
    if (!_statuses) {
        _statuses = [NSMutableArray array];
    }
    return _statuses;
}


- (void)friendSearch{
    NSLog(@"%s",__func__);
}

- (void)pop{
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏
    [self setupNav];
    
    //更改用户信息
    [self setupUserInfo];
    
    //加载最新的微博数据
    [self loadNewStatus];
}


- (void)loadNewStatus{
    MMBAccount *account = [MMBAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    [[MMBNetworkTool shareNetworkTool] GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        MMBLog(@"%@",responseObject);
        if (responseObject) {
            self.statuses = [MMBStatus mj_objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
            //刷新表格
            [self.tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        MMBLog(@"loadNewStatus.error = %@",error);
    }];
}

/**
 *
 */


//设置用户昵称
- (void)setupUserInfo{
    // https://api.weibo.com/2/users/show.json
    // access_token	falsestring	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
    // uid	false	int64	需要查询的用户ID。
    
    MMBAccount *account = [MMBAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    
    [[MMBNetworkTool shareNetworkTool] GET:@"https://api.weibo.com/2/users/show.json" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        //NSLog(@"微博账号信息 = %@",responseObject);
        UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
        NSString *name = responseObject[@"name"];
        [titleButton setTitle:name forState:UIControlStateNormal];
        
        //存储昵称到沙盒中
        account.name = name;
        [MMBAccountTool saveAccount:account];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"请求失败 error= %@",error);
    }];

}


#pragma mark - 设置导航栏title
- (void)setupNav{
    //这里有个注意点,若是在创建tabBarController 时 为每个子控制器添加了背景颜色的话,就会创建该控制器并且调用viewDidLoad 方法,而此时NavigationController还没有被创建,所以此时设置导航栏上面的内容是显示不出来的.
    
    /* 设置导航栏上面的内容 */
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithTarget:self action:@selector(friendSearch) image:@"navigationbar_friendsearch" highImage:@"navigationbar_friendsearch_highlighted"];
    //设置右边按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTarget:self action:@selector(pop) image:@"navigationbar_pop" highImage:@"navigationbar_pop_highlighted"];
    
    //设置中间标题按钮
    MMBTitleButton *titleButton = [[MMBTitleButton alloc] init];
//    titleButton.width = 150;
//    titleButton.height = 30;
    NSString *name = [[MMBAccountTool account] name];
    [titleButton setTitle:name ? name:@"首页" forState:UIControlStateNormal];

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


#pragma mark - tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.statuses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    MMBStatus *status = self.statuses[indexPath.row];
    MMBUser *user = status.user;
    cell.textLabel.text = user.name;
    cell.detailTextLabel.text = status.text;
    
    NSString *imageUrl = user.profile_image_url;
    UIImage *placeholder = [UIImage imageNamed:@"avatar_default_small"];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl ] placeholderImage:placeholder];
    
    return cell;
}


@end
