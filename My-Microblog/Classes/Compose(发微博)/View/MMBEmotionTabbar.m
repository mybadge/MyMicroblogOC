//
//  MMBEmotionTabbar.m
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/6.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "MMBEmotionTabBar.h"

@interface MMBEmotionTabBarButton : UIButton

@end
@implementation MMBEmotionTabBarButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 设置文字颜色
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
        // 设置字体
        self.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted{
    //取消button按钮的高亮状态
}
@end

//######################上面是定义了MMBEmotionTabBarButton######################
//############################################################################

@interface MMBEmotionTabBar ()
@property (nonatomic, weak) MMBEmotionTabBarButton *selectedBtn;
@end
@implementation MMBEmotionTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupButtonWith:@"最近" buttonType:MMBEmotionTabBarButtonTypeRecent];
        [self setupButtonWith:@"默认" buttonType:MMBEmotionTabBarButtonTypeDefault];
        [self setupButtonWith:@"Emoji" buttonType:MMBEmotionTabBarButtonTypeEmoji];
        [self setupButtonWith:@"浪小花" buttonType:MMBEmotionTabBarButtonTypeLxh];
    }
    return self;
}

+ (instancetype)tabBar{
    return [[self alloc] init];
}


/** 初始化 按钮 根据title 和按钮类型 */
- (void)setupButtonWith:(NSString *)title buttonType:(MMBEmotionTabBarButtonType)buttonType{
    MMBEmotionTabBarButton *btn = [[MMBEmotionTabBarButton alloc] init];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    btn.tag = buttonType;
    [btn setTitle:title forState:UIControlStateNormal];
    [self addSubview:btn];
    //设置背景图片
    NSString *imageName = @"compose_emotion_table_mid_normal";
    NSString *selectImageName = @"compose_emotion_table_mid_selected";
    if (MMBEmotionTabBarButtonTypeRecent ==buttonType){
        imageName = @"compose_emotion_table_left_normal";
        selectImageName = @"compose_emotion_table_left_selected";
    }else if (MMBEmotionTabBarButtonTypeLxh == buttonType) {
        imageName = @"compose_emotion_table_right_normal";
        selectImageName = @"compose_emotion_table_right_selected";
    }
    
    UIImage *image = [UIImage imageNamed:imageName];
    //切图,横切和竖切
    image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    
    UIImage *selectImage = [UIImage imageNamed:selectImageName];
    
    selectImage = [selectImage stretchableImageWithLeftCapWidth:selectImage.size.width * 0.5 topCapHeight:selectImage.size.height * 0.5];
    
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [btn setBackgroundImage:selectImage forState:UIControlStateDisabled];
    
}

- (void)btnClick:(MMBEmotionTabBarButton *)sender{
    self.selectedBtn.enabled = YES;
    sender.enabled = NO;
    self.selectedBtn = sender;
    if ([self.delegate respondsToSelector:@selector(emotionTabBar:didSelectedButtonType:)]) {
        [self.delegate emotionTabBar:self didSelectedButtonType:(int)sender.tag];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat btnW = self.width / self.subviews.count;
    
    for (int i = 0 ; i < self.subviews.count; ++i) {
        MMBEmotionTabBarButton *btn = self.subviews[i];
        btn.y = 0;
        btn.x = btnW * i;
        btn.width = btnW;
        btn.height = self.height;
    }
}

- (void)setDelegate:(id<MMBEmotionTabBarDelegate>)delegate{
    _delegate = delegate;
    // 选中“默认”按钮
    [self btnClick:[self viewWithTag:MMBEmotionTabBarButtonTypeDefault]];
}

@end
