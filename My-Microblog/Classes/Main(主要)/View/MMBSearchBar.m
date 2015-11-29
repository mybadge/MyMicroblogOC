//
//  MMBSearchBar.m
//  My-Microblog
//
//  Created by 赵志丹 on 15/11/29.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "MMBSearchBar.h"

@implementation MMBSearchBar

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.font = [UIFont systemFontOfSize:15];
        UIColor *color = [UIColor orangeColor];
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入搜索条件" attributes:@{NSForegroundColorAttributeName: color}];
        self.background = [UIImage imageNamed:@"searchbar_textfield_background"];
        
        UIImageView *searchIcon = [[UIImageView alloc] init];
        searchIcon.image = [UIImage imageNamed:@"searchbar_textfield_search_icon"];
        searchIcon.width = 30;
        searchIcon.height = 30;
        searchIcon.contentMode = UIViewContentModeCenter;
        self.leftView = searchIcon;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    
    return self;
}

+ (instancetype)searchBar{
    return [[self alloc] init];
}


@end
