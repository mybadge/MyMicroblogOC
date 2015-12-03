//
//  MMBStatusPhotosView.m
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/3.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "MMBStatusPhotosView.h"
#import "MMBPhoto.h"
#import "MMBStatusPhotoView.h"

#define MMBStatusPhotoMargin 4
#define MMBStatusPhotoWH ([UIScreen mainScreen].bounds.size.width - MMBStatusPhotoMargin * 4) / 3
#define MMBStatusPhotoMaxCol(count) ((count == 4) ? 2 : 3)


@implementation MMBStatusPhotosView

- (void)setPhotos:(NSArray *)photos{
    _photos = photos;
    
    while (self.subviews.count < photos.count) {
        MMBStatusPhotoView *photoView = [[MMBStatusPhotoView alloc] init];
        [self addSubview:photoView];
    }
    
    for (int i = 0 ; i < self.subviews.count; ++i) {
        MMBStatusPhotoView *photoView = self.subviews[i];
        if (i < photos.count) {
            photoView.photo = photos[i];
            photoView.hidden = NO;
        }else{
            photoView.hidden = YES;
        }
    }
}


- (void)layoutSubviews{
    [super layoutSubviews];
    int maxCols = MMBStatusPhotoMaxCol(self.photos.count);
    //设置子控件的尺寸和位置
    for (int i = 0 ; i < self.photos.count; ++i) {
        MMBStatusPhotoView *photoView = self.subviews[i];
        photoView.photo = self.photos[i];
        int col = i % maxCols;
        int row = i / maxCols;
        photoView.x = col * (MMBStatusPhotoWH + MMBStatusPhotoMargin);
        photoView.y = row * (MMBStatusPhotoWH + MMBStatusPhotoMargin);
        photoView.width = MMBStatusPhotoWH;
        photoView.height = MMBStatusPhotoWH;
    }
}

+ (CGSize)sizeWithCount:(NSUInteger)count{
    // 最大列数（一行最多有多少列）
    NSUInteger maxCols = MMBStatusPhotoMaxCol(count);
    
    
    NSUInteger cols = count >= maxCols ? maxCols : count;
    CGFloat photosW = cols * MMBStatusPhotoWH + (cols - 1) * MMBStatusPhotoMargin;
    // 最大行数 最多有多少行
    NSUInteger rows = (count + maxCols - 1) / maxCols;
    CGFloat photosH = rows * MMBStatusPhotoWH + (rows - 1) * MMBStatusPhotoMargin;
    
    return CGSizeMake(photosW, photosH);
}


@end
