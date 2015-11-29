//
//  MMBDropdownMenu.m
//  My-Microblog
//
//  Created by 赵志丹 on 15/11/29.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "MMBDropdownMenu.h"

@interface MMBDropdownMenu ()

@property (nonatomic,weak) UIImageView *containerView;
@end
@implementation MMBDropdownMenu

+ (instancetype)menu{
    return  [[self alloc] init];
}

- (UIImageView *)containerView{
    if (!_containerView) {
        UIImageView *containerView = [[UIImageView alloc] init];
        _containerView = containerView;
        containerView.image = [UIImage imageNamed:@"popover_background"];
        containerView.userInteractionEnabled = YES;
        [self addSubview:containerView];
    }
    return _containerView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setContent:(UIView *)content{
    _content = content;
    content.x = 10;
    content.y = 15;
    //设置灰色的高度
    self.containerView.height = CGRectGetMaxY(content.frame) + 11;
    self.containerView.width = CGRectGetMaxX(content.frame) + 10;
    
    [self.containerView addSubview:content];
}

- (void)showFrom:(UIView *)from{
    //1.获取最上面的窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    //2.把自己添加到窗口上
    [window addSubview:self];
    
    //3.设置尺寸
    self.frame = window.bounds;
    //4.转换坐标系
    CGRect newFrame = [from convertRect:from.bounds toView:window];
    self.containerView.centerX = CGRectGetMidX(newFrame);
    self.containerView.y = CGRectGetMaxY(newFrame);
    
    //5.通知外界,自己显示了
    if ([self.delegate respondsToSelector:@selector(dropdownMenuDidShow:)]){
        [self.delegate dropdownMenuDidShow:self];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismiss];
}

- (void)dismiss{
    [self removeFromSuperview];
    //通知外界自己要销毁了
    if ([self.delegate respondsToSelector:@selector(dropdownMenuDidDismiss:)]){
        [self.delegate dropdownMenuDidDismiss:self];
    }
}

- (void)setContentController:(UIViewController *)contentController{
    _contentController = contentController;
    self.content = contentController.view;
}
@end
