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
#import "MMBLoadMoreFooter.h"
#import "MMBStatusCell.h"
#import "MMBStatusFrame.h"

@interface MMBHomeViewController ()<MMBDropdownMenuDelegate>

/**
 * 微博数组 (里面放的都是微博字典, 一个字典对象就代表一条微博)
 * 需要将微博数组转化成statusesFrame数组.
 */
//@property (nonatomic,strong) NSMutableArray *statuses;
@property (nonatomic,strong) NSMutableArray *statusFrames;
@end

@implementation MMBHomeViewController

- (NSMutableArray *)statusFrames{
    if (!_statusFrames) {
        _statusFrames = [NSMutableArray array];
    }
    return _statusFrames;
}


- (void)friendSearch{
    NSLog(@"%s",__func__);
}

- (void)pop{
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.tableView.rowHeight = 70;
    self.tableView.backgroundColor = MMBColor(211, 211, 211);

    //设置导航栏
    [self setupNav];
    
    //更改用户信息
    [self setupUserInfo];
    
    //集成下拉刷新控件
    [self setupDownRefresh];
    
    //集成上拉加载更多
    [self setupUpRefresh];
    
    //获得未读数
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:240 target:self selector:@selector(setupUnreadCount) userInfo:nil repeats:YES];
    // 主线程也会抽时间处理一下timer（不管主线程是否正在其他事件）
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
}

/**
 * 获得未读数
 */
- (void)setupUnreadCount{
    MMBAccount *account = [MMBAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;

    [[MMBNetworkTool shareNetworkTool] GET:@"https://rm.api.weibo.com/2/remind/unread_count.json" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"setupUnreadCount = %@",responseObject);
        NSString *status = [responseObject[@"status"] description];
        if ([status intValue] == 0) {
            self.tabBarItem.badgeValue = nil;
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        }else{
            self.tabBarItem.badgeValue = status;
            [UIApplication sharedApplication].applicationIconBadgeNumber = [status intValue];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        MMBLog(@"setupUnreadCount.error = %@",error);
    }];
}

/**
 * 集成刷新控件
 */
- (void)setupDownRefresh{
    //1.添加刷新控件
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(loadNewStatus:) forControlEvents:UIControlEventValueChanged];
    //添加到父控制器中
    [self.tableView addSubview:refreshControl];
    
     // 2.马上进入刷新状态(仅仅是显示刷新状态，并不会触发UIControlEventValueChanged事件)
    [refreshControl beginRefreshing];
    [self loadNewStatus:refreshControl];
}


/**
 * 讲stasues数组装换成statusFrames数组
 */
- (NSArray *)statusFramesWithStatuses:(NSArray *)statues{
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:statues.count];
    [statues enumerateObjectsUsingBlock:^(MMBStatus *status, NSUInteger idx, BOOL * _Nonnull stop) {
        MMBStatusFrame *statusFrame = [[MMBStatusFrame alloc] init];
        statusFrame.status = status;
        [arrayM addObject:statusFrame];
    }];
    return arrayM.copy;
}

/**
 *  UIRefreshControl进入刷新状态：加载最新的数据
 */
- (void)loadNewStatus:(UIRefreshControl *)control{
    MMBAccount *account = [MMBAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    //params[@"uid"] = account.uid;
    
    // 取出最前面的微博（最新的微博，ID最大的微博）
    MMBStatusFrame *firstStatus = [self.statusFrames firstObject];
    if (firstStatus) {
        // 若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0
        params[@"since_id"] = firstStatus.status.idstr;
    }
    
    [[MMBNetworkTool shareNetworkTool] GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        //MMBLog(@"%@",responseObject);
        
        // 将 "微博字典"数组 转为 "微博模型"数组
        NSArray *newStatuses = [MMBStatus mj_objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        // 将statuses 装换为 statusFrame
        NSArray *newFrames = [self statusFramesWithStatuses:newStatuses];
         //MMBLog(@"%@",newFrames);
        // 将最新的微博数据，添加到总数组的最前面
        NSRange range = NSMakeRange(0, newFrames.count);
        NSIndexSet *set = [[NSIndexSet alloc] initWithIndexesInRange:range];
        [self.statusFrames insertObjects:newFrames atIndexes:set];
        
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

//下拉刷新
- (void)setupUpRefresh{
    MMBLoadMoreFooter *footer = [MMBLoadMoreFooter footer];
    footer.hidden = YES;
    self.tableView.tableFooterView = footer;
}

/**
 *  UIRefreshControl进入刷新状态：加载最新的数据
 */
- (void)loadMoreStatus{
    MMBAccount *account = [MMBAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    
    // 取出最前面的微博（最新的微博，ID最大的微博）
    MMBStatusFrame *lastStatus = [self.statusFrames lastObject];
    if (lastStatus) {
        // 若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
        // id这种数据一般都是比较大的，一般转成整数的话，最好是long long类型
        long long maxId = [lastStatus.status.idstr longLongValue] - 1;
        params[@"max_id"] = @(maxId);
    }
    
    [[MMBNetworkTool shareNetworkTool] GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        //MMBLog(@"%@",responseObject);
        
        // 将 "微博字典"数组 转为 "微博模型"数组
        NSArray *newStatuses = [MMBStatus mj_objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        NSArray *newFrames = [self statusFramesWithStatuses:newStatuses];
        
        [self.statusFrames addObjectsFromArray:newFrames];
        //刷新表格
        [self.tableView reloadData];
        
        // 结束刷新
        self.tableView.tableFooterView.hidden = YES;
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        MMBLog(@"loadMoreStatus.error = %@",error);
        // 结束刷新
        self.tableView.tableFooterView.hidden = YES;
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
        // 延迟1s后，再利用1s的时间，让label往上移动一段距离（回到一开始的状态）
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
            label.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
    // 如果某个动画执行完毕后，又要回到动画执行前的状态，建议使用transform来做动画
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
        MMBUser *user = [MMBUser mj_objectWithKeyValues:responseObject];
        [titleButton setTitle:user.name forState:UIControlStateNormal];
        
        //存储昵称到沙盒中
        account.name = user.name;
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
    return self.statusFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MMBStatusCell *cell = [MMBStatusCell cellWithTableView:tableView];
    MMBStatusFrame *statusFrame = self.statusFrames[indexPath.row];
    //MMBUser *user = status.user;
    //cell.textLabel.text = user.name;
    //cell.detailTextLabel.text = status.text;
    //cell.detailTextLabel.numberOfLines = 2;
    //NSString *imageUrl = user.profile_image_url;
    //UIImage *placeholder = [UIImage imageNamed:@"avatar_default_small"];
    //[cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl ] placeholderImage:placeholder];
    cell.statusFrame = statusFrame;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MMBStatusFrame *frame = self.statusFrames[indexPath.row];
    return frame.cellHeight;
}

#pragma mark - scrollView 代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.tableView.tableFooterView.isHidden == NO || self.statusFrames.count == 0) return;
    
    CGFloat offsetY = scrollView.contentOffset.y;
    // 当最后一个cell完全显示在眼前时，contentOffset的y值
    CGFloat judgeOffsetY = scrollView.contentSize.height + scrollView.contentInset.bottom - scrollView.height - self.tableView.tableFooterView.height;
    if (offsetY >= judgeOffsetY) { // 最后一个cell完全进入视野范围内
        self.tableView.tableFooterView.hidden = NO;
        //加载数据
        [self loadMoreStatus];
    }
}

@end
