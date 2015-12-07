//
//  MMBEmotionListView.m
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/6.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "MMBEmotionListView.h"
#import "MMBEmotionPageView.h"


@interface MMBEmotionListView ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIPageControl *pageControl;
@end
@implementation MMBEmotionListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        //scrollView.backgroundColor = MMBRandomColor;
        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView = scrollView;
        [self addSubview:scrollView];
        
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        //关闭pageControld的用户交互
        pageControl.userInteractionEnabled = NO;
        //设置pageControl内部的原点的图片名称
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_normal"] forKey:@"pageImage"];
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_selected"] forKey:@"currentPageImage"];
        self.pageControl = pageControl;
        [self addSubview:pageControl];
    }
    return self;
}

- (void)setEmotions:(NSArray *)emotions{
    _emotions = emotions;
    NSInteger count =(emotions.count + MMBEmotionPageSize -1) / MMBEmotionPageSize;
    self.pageControl.numberOfPages = count;
    
    
    //用来创建每页显示的表情控件
    for (int i = 0 ; i < count; ++i) {
        MMBEmotionPageView *pageView = [[MMBEmotionPageView alloc] init];
        NSRange range;
        range.location = i * MMBEmotionPageSize;
        NSInteger left = emotions.count - range.location;
        
        if (left >= MMBEmotionPageSize) {
            range.length = MMBEmotionPageSize;
        }else{
            range.length = left;
        }
        //设置一页的表情
        pageView.emotions = [emotions subarrayWithRange:range];
        [self.scrollView addSubview:pageView];
    }
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.pageControl.width = self.width;
    self.pageControl.height = 25;
    self.pageControl.x = 0;
    self.pageControl.y = self.height - self.pageControl.height;
    
    self.scrollView.width = self.width;
    self.scrollView.height = self.pageControl.y;
    self.scrollView.x = self.scrollView.y = 0;
    
    NSInteger count = self.scrollView.subviews.count;
    for (int i = 0 ; i < count; ++i) {
        MMBEmotionPageView *pageView = self.scrollView.subviews[i];
        pageView.width = self.width;
        pageView.height = self.scrollView.height;
        pageView.y = 0;
        pageView.x = pageView.width * i;
    }
    self.scrollView.contentSize = CGSizeMake(self.width * count, 0);
}


#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    double pageNo = scrollView.contentOffset.x / scrollView.width;
    self.pageControl.currentPage = (int)(pageNo + 0.5);
}

@end

