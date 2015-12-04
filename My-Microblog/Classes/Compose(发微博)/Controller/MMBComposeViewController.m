//
//  MMBComposeViewController.m
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/4.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "MMBComposeViewController.h"
#import "MMBAccountTool.h"
#import "MMBAccount.h"

@interface MMBComposeViewController ()

@end

@implementation MMBComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
}

#pragma mark - 初始化导航栏
/**
 * 初始化导航栏
 */
- (void)setupNav{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(compose)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    MMBAccount *account = [MMBAccountTool account];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = [NSString stringWithFormat:@"发微博\n%@", account.name];
    titleLabel.numberOfLines = 0;
//    NSAttributedString
//    NSTextAttachment
//    titleLabel.attributedText = [NSAttributedString attributedStringWithAttachment:<#(nonnull NSTextAttachment *)#>];
//    self.navigationItem.titleView = titleLabel;
}

/**
 * 发布微博
 */
- (void)compose{
    NSLog(@"%s",__func__);
}

- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
