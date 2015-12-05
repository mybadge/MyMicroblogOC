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
#import "MMBTextView.h"

@interface MMBComposeViewController ()
@property (nonatomic, weak) MMBTextView *textView;

@end

@implementation MMBComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNav];
    
    [self setupTextView];
}

#pragma mark - 初始化导航栏
/**
 * 初始化导航栏
 */
- (void)setupNav{
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStyleDone target:self action:@selector(compose)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    NSString *prefix = @"发微博";
    MMBAccount *account = [MMBAccountTool account];
    NSString *name = account.name;
    if (name) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.width = 300;
        titleLabel.height = 50;
        titleLabel.numberOfLines = 0;
        NSString *str = [NSString stringWithFormat:@"%@\n%@", prefix, account.name];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:[str rangeOfString:prefix]];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:[str rangeOfString:account.name]];
        titleLabel.attributedText = attrStr;
        self.navigationItem.titleView = titleLabel;
    }else{
        self.title = prefix;
    }
}

/**
 * 初始化文本框
 */
- (void)setupTextView{
    // 在这个控制器中，textView的contentInset.top默认会等于64
    MMBTextView *textView = [[MMBTextView alloc] init];
    // 垂直方向上永远可以拖拽（有弹簧效果）
    textView.alwaysBounceVertical = YES;
    textView.frame = self.view.bounds;
    textView.font = [UIFont systemFontOfSize:15];
    textView.placeholderColor = [UIColor orangeColor];
    textView.placeholder = @"分享一下你的新鲜事...";
    [self.view addSubview:textView];
    self.textView = textView;
    
    // 文字改变的通知
    [MMBNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:textView];
    
    // 键盘通知
    // 键盘的frame发生改变时发出的通知（位置和尺寸）
    //    UIKeyboardWillChangeFrameNotification
    //    UIKeyboardDidChangeFrameNotification
    // 键盘显示时发出的通知
    //    UIKeyboardWillShowNotification
    //    UIKeyboardDidShowNotification
    // 键盘隐藏时发出的通知
    //    UIKeyboardWillHideNotification
    //    UIKeyboardDidHideNotification
    [MMBNotificationCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)textDidChange{
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    
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
