//
//  MMBStatusPhotoView.m
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/3.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "MMBStatusPhotoView.h"
#import "UIImageView+WebCache.h"

@interface MMBStatusPhotoView ()

@property (nonatomic, weak) UIImageView *gifView;
@end
@implementation MMBStatusPhotoView

- (UIImageView *)gifView{
    if (!_gifView) {
        UIImage *image = [UIImage imageNamed:@"timeline_image_gif"];
        UIImageView *gifView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:gifView];
        _gifView = gifView;
    }
    return _gifView;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setPhoto:(MMBPhoto *)photo{
    _photo = photo;
    [self sd_setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    
    // 判断是够以gif或者GIF结尾
    self.gifView.hidden = ![photo.thumbnail_pic.lowercaseString hasSuffix:@"gif"];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.gifView.x = self.width - self.gifView.width;
    self.gifView.y = self.height - self.gifView.height;
}

@end
