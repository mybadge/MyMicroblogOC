//
//  MMBDropdownMenu.h
//  My-Microblog
//
//  Created by 赵志丹 on 15/11/29.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMBDropdownMenu;

@protocol MMBDropdownMenuDelegate <NSObject>

@optional
- (void)dropdownMenuDidShow:(MMBDropdownMenu *)menu;
- (void)dropdownMenuDidDismiss:(MMBDropdownMenu *)menu;


@end

@interface MMBDropdownMenu : UIView

/**
 *  内容视图
 */
@property (nonatomic,strong) UIView *content;
/**
 *  内容控制器
 */
@property (nonatomic,strong) UIViewController *contentController;

@property (nonatomic,weak) id<MMBDropdownMenuDelegate> delegate;

+ (instancetype)menu;

/**
 *  显示
 *
 *  @param from 来自那个页面
 */
- (void)showFrom:(UIView *)from;

/**
 *  销毁
 */
- (void)dismiss;
@end
