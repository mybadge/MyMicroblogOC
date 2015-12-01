//
//  MMBOAuthViewController.m
//  My-Microblog
//
//  Created by 赵志丹 on 15/11/30.
//  Copyright © 2015年 赵志丹. All rights reserved.
//2492369838
//App Secret：47731e717d9338fbe53f46518f150eb1

#import "MMBOAuthViewController.h"
#import <AFNetworking.h>
#import "MMBNetworkTool.h"
#import "MMBAccount.h"
#import "MMBAccountTool.h"
#import "UIWindow+Extension.h"


//#define client_id

@interface MMBOAuthViewController ()<UIWebViewDelegate>

//@property (nonatomic,weak) UIWebView *webView;
@end

@implementation MMBOAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = self.view.bounds;
    webView.delegate = self;
    [self.view addSubview:webView];
    
    /* 请求参数：
     client_id	true	string	申请应用时分配的AppKey。
     redirect_uri	true	string	授权回调地址，站外应用需与设置的回调地址一致，站内应用需填写canvas page的地址。
     */
    NSURL *url = [NSURL URLWithString:@"https://api.weibo.com/oauth2/authorize?client_id=2492369838&redirect_uri=http://"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *url = request.URL.absoluteString;
    // 截取code=后面的参数值
    NSRange range = [url rangeOfString:@"code="];
    if (range.length != 0) {
        NSInteger fromIndex = range.location + range.length;
        NSString *code = [url substringFromIndex:fromIndex];
        // 利用code换取一个accessToken
        [self accessTokenWithCode:code];
    }
    return YES;
}

- (void)accessTokenWithCode:(NSString *)code{
    /*
     URL：https://api.weibo.com/oauth2/access_token
     
     请求参数：
     client_id：申请应用时分配的AppKey
     client_secret：申请应用时分配的AppSecret
     grant_type：使用authorization_code
     redirect_uri：授权成功后的回调地址
     code：授权成功后返回的code
     */
    // 1.请求管理者
    MMBNetworkTool *mgr = [MMBNetworkTool shareNetworkTool];
    //    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    // AFN的AFJSONResponseSerializer默认不接受text/plain这种类型
    
    // 2.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"client_id"] = @"2492369838";
    params[@"client_secret"] = @"47731e717d9338fbe53f46518f150eb1";
    params[@"grant_type"] = @"authorization_code";
    params[@"redirect_uri"] = @"http://";
    params[@"code"] = code;
    
    // 3.发送请求
    [mgr POST:@"https://api.weibo.com/oauth2/access_token" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        MMBLog(@"请求成功-%@", responseObject);
        MMBAccount *account = [MMBAccount accountWithDict:responseObject];
        [MMBAccountTool saveAccount:account];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window switchRootViewController];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        MMBLog(@"请求失败-%@", error);
    }];
}



@end
