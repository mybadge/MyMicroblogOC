//
//  MMBMessageCenterViewController.m
//  My-Microblog
//
//  Created by 赵志丹 on 15/11/29.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "MMBMessageCenterViewController.h"

@interface MMBMessageCenterViewController ()

@end

@implementation MMBMessageCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"写私信" style:UIBarButtonItemStylePlain target:self action:@selector(composeMsg)];
    
}

- (void)composeMsg{
    MMBLog(@"%s",__func__);
}



@end
