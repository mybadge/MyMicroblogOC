//
//  MMBComposeToolbar.m
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/5.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "MMBComposeToolbar.h"

@implementation MMBComposeToolbar

+ (instancetype)toolbar{
    return  [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background"]];
        
        // 初始化按钮
        [self setupButtonWith:@"compose_camerabutton_background" highlightImageName:@"compose_camerabutton_background_highlighted" buttonType:MMBComposeToolbarButtonTypeCamera];
        
        [self setupButtonWith:@"compose_toolbar_picture" highlightImageName:@"compose_toolbar_picture_highlighted" buttonType:MMBComposeToolbarButtonTypePicture];
        
        [self setupButtonWith:@"compose_mentionbutton_background" highlightImageName:@"compose_mentionbutton_background_highlighted" buttonType:MMBComposeToolbarButtonTypeMention];
        
        [self setupButtonWith:@"compose_trendbutton_background" highlightImageName:@"compose_trendbutton_background_highlighted" buttonType:MMBComposeToolbarButtonTypeTrend];
        
        [self setupButtonWith:@"compose_emoticonbutton_background" highlightImageName:@"compose_emoticonbutton_background_highlighted" buttonType:MMBComposeToolbarButtonTypeEmotion];
    }
    return self;
}

- (void)setupButtonWith:(NSString *)imageName highlightImageName:(NSString *)highlightImageName buttonType:(MMBComposeToolbarButtonType)type{
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highlightImageName] forState:UIControlStateHighlighted];
    btn.tag = type;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat w = self.width / self.subviews.count;
   
    for (int i = 0 ; i < self.subviews.count; ++i) {
        UIButton *btn = self.subviews[i];
        btn.x = w * i;
        btn.width = w;
        btn.height = self.height;
    }
}

- (void)btnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(composeToolbar:didClickButton:)]) {
        [self.delegate composeToolbar:self didClickButton:btn.tag];
    }
}

@end
