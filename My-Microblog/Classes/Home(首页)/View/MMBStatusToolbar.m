//
//  MMBStatusToolbar.m
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/2.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "MMBStatusToolbar.h"
#import "MMBStatus.h"
@interface MMBStatusToolbar ()
/** 里面存放所有的按钮 */
@property (nonatomic, strong) NSMutableArray *btns;
/** 里面存放所有的分割线 */
@property (nonatomic, strong) NSMutableArray *dividers;

/** 转发按钮 */
@property (nonatomic, weak) UIButton *repostBtn;
/** 评论按钮 */
@property (nonatomic, weak) UIButton *commentBtn;
/** 点赞按钮 attitude :态度 */
@property (nonatomic, weak) UIButton *attitudeBtn;//
@end
@implementation MMBStatusToolbar

+ (instancetype)toolbar{
    return [[self alloc] init];
}

- (NSMutableArray *)btns{
    if (!_btns) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}

- (NSMutableArray *)dividers{
    if (!_dividers) {
        _dividers = [NSMutableArray array];
    }
    return _dividers;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_card_bottom_background"]];
        //添加按钮
        self.repostBtn = [self setupBtn:@"转发" icon:@"timeline_icon_retweet"];
        self.commentBtn = [self setupBtn:@"评论" icon:@"timeline_icon_comment"];
        self.attitudeBtn = [self setupBtn:@"赞" icon:@"timeline_icon_unlike"];
        
        //添加分隔线
        [self setupDivider];
        [self setupDivider];
    }
    return self;
}

/**
 * 添加分隔线
 */
- (void)setupDivider{
    UIImageView *divider = [[UIImageView alloc] init];
    divider.image = [UIImage imageNamed:@"timeline_card_bottom_line"];
    [self addSubview:divider];
    [self.dividers addObject:divider];
}

/**
 * 初始化一个按钮 
 *   title: 按钮文字    icon: 按钮图片名称
 */
- (UIButton *)setupBtn:(NSString *)title icon:(NSString *)icon{
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"timeline_card_bottom_background_highlighted"] forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [self.btns addObject:btn];
    [self addSubview:btn];
    return btn;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    NSInteger btnCount = self.btns.count;
    CGFloat btnW = self.width / btnCount;
    CGFloat btnH = self.height;
    for (int i = 0 ; i < btnCount; ++i) {
        UIButton *btn = self.btns[i];
        btn.y = 0;
        btn.x = i * btnW;
        btn.width = btnW;
        btn.height = btnH;
    }

    //设置分割线的frame
    NSInteger dividerCount = self.dividers.count;
    for (int i = 0 ; i < dividerCount; ++i) {
        UIImageView *divider = self.dividers[i];
        divider.width = 1;
        divider.height = btnH;
        divider.x = (i + 1) * btnW;
        divider.y = 0;
    }
}


- (void)setStatus:(MMBStatus *)status{
    _status = status;
 
    //转发
    [self setupBtnCount:status.reposts_count btn:self.repostBtn title:@"转发"];
    //评论
    [self setupBtnCount:status.comments_count btn:self.commentBtn title:@"评论"];
    //赞
    [self setupBtnCount:status.attitudes_count btn:self.attitudeBtn title:@"赞"];
}

- (void)setupBtnCount:(NSInteger)count btn:(UIButton *)btn title:(NSString *)title{
    if (count) {
        if (count < 10000) {
            title = [NSString stringWithFormat:@"%zd",count];
        }else {
            double wan = count / 10000.0;
            title = [NSString stringWithFormat:@"%.1f万", wan];
            title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        }
    }
    [btn setTitle:title forState:UIControlStateNormal];
}

@end
