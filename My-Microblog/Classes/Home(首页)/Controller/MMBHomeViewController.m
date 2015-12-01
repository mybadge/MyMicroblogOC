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
    
    //集成刷新控件
    [self setupRefresh];
}


/**
 * 集成刷新控件
 */
- (void)setupRefresh{
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshStateChange:) forControlEvents:UIControlEventValueChanged];
    //添加到父控制器中
    [self.tableView addSubview:refreshControl];
}

/**
 *  UIRefreshControl进入刷新状态：加载最新的数据
 */
- (void)refreshStateChange:(UIRefreshControl *)control{
    MMBAccount *account = [MMBAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    //params[@"uid"] = account.uid;
    
    // 取出最前面的微博（最新的微博，ID最大的微博）
    MMBStatus *firstStatus = [self.statuses firstObject];
    if (firstStatus) {
        // 若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0
        params[@"since_id"] = firstStatus.idstr;
    }
    
    
    [[MMBNetworkTool shareNetworkTool] GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        //MMBLog(@"%@",responseObject);
        
        // 将 "微博字典"数组 转为 "微博模型"数组
        NSArray *newStatuses = [MMBStatus mj_objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        // 将最新的微博数据，添加到总数组的最前面
        NSRange range = NSMakeRange(0, newStatuses.count);
        NSIndexSet *set = [[NSIndexSet alloc] initWithIndexesInRange:range];
        [self.statuses insertObjects:newStatuses atIndexes:set];
        
        //刷新表格
        [self.tableView reloadData];
        
        //结束刷新
        [control endRefreshing];
        
        // 显示最新微博的数量
        [self showNewStatusCount:newStatuses.count];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        MMBLog(@"loadNewStatus.error = %@",error);
        // 结束刷新
        [control endRefreshing];
    }];
    
}

- (void)showNewStatusCount:(NSInteger)count{
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];
    label.width = [UIScreen mainScreen].bounds.size.width;
    label.height = 35;
    if (count == 0) {
        label.text = @"没有新的微博数据,请稍后再试";
    }else{
        label.text = [NSString stringWithFormat:@"共加载了%zd条新数据",count];
    }
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    label.y = 64 - label.height;
    // 将label添加到导航控制器的view中，并且是盖在导航栏下边
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    CGFloat duration = 1.0;
    [UIView animateWithDuration:duration animations:^{
        //label.y = label.height;
        label.transform = CGAffineTransformMakeTranslation(0, label.height);
    }completion:^(BOOL finished) {
        CGFloat delay = 1.0;
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
            label.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
    
}

//获取用户信息(昵称)
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
