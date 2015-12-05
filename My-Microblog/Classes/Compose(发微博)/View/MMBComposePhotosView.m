//
//  MMBComposePhotosView.m
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/5.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "MMBComposePhotosView.h"

@implementation MMBComposePhotosView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _photos = [NSMutableArray array];
    }
    return self;
}

- (void)addPhoto:(UIImage *)photo{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = photo;
    [self addSubview:imageView];
    [self.photos addObject:photo];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    NSUInteger count = self.subviews.count;
    int maxCol = 3;
    CGFloat photosViewMargin = 10;//外边框
    CGFloat imageViewMargin = 5;  //内边框
    CGFloat imageViewWh = (self.width - photosViewMargin*2 - (maxCol - 1)*imageViewMargin) / maxCol;
    for (int i = 0 ; i < count; ++i) {
        UIImageView *photoView = self.subviews[i];
        int col = i % maxCol;
        photoView.x = photosViewMargin + col * (imageViewWh + imageViewMargin);
        int row = i / maxCol;
        photoView.y = row * (imageViewWh + imageViewMargin);
        photoView.width = imageViewWh;
        photoView.height = imageViewWh;
    }
}

@end
