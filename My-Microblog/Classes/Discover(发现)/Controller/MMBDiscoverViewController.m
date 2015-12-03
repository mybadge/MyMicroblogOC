//
//  MMBDiscoverViewController.m
//  My-Microblog
//
//  Created by 赵志丹 on 15/11/29.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "MMBDiscoverViewController.h"


@interface MMBDiscoverViewController ()

@end

@implementation MMBDiscoverViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    MMBSearchBar *searchBar = [MMBSearchBar searchBar];
    searchBar.width = [UIScreen mainScreen].bounds.size.width - 40;
    searchBar.height = 35;
    self.navigationItem.titleView = searchBar;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    [searchBar addTarget:self action:@selector(endChange) forControlEvents:UIControlEventEditingDidEndOnExit];
}

- (void)endChange{
    [self.view endEditing:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = @"你好,我好,大家好....";
    return cell;
}


@end
