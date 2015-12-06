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
    
//    /**
//     NSRegularExpressionCaseInsensitive             = 1 << 0,     /* Match letters in the pattern independent of case. */
//    NSRegularExpressionAllowCommentsAndWhitespace  = 1 << 1,     /* Ignore whitespace and #-prefixed comments in the pattern. */
//    NSRegularExpressionIgnoreMetacharacters        = 1 << 2,     /* Treat the entire pattern as a literal string. */
//    NSRegularExpressionDotMatchesLineSeparators    = 1 << 3,     /* Allow . to match any character, including line separators. */
//    NSRegularExpressionAnchorsMatchLines           = 1 << 4,     /* Allow ^ and $ to match the start and end of lines. */
//    NSRegularExpressionUseUnixLineSeparators       = 1 << 5,     /* Treat only \n as a line separator (otherwise, all standard line separators are used). */
//    //讬唯一 \n 作为行分隔符 (否则为所有标准线使用分隔符)
//    NSRegularExpressionUseUnicodeWordBoundaries    = 1 << 6      /* Use Unicode TR#29 to specify word boundaries (otherwise, traditional regular expression word boundaries are used). */
//    //使用 Unicode TR #29 指定单词边界 (否则为传统的正则表达式单词边界使用)。
//     */
    
//    NSRegularExpression *res = [NSRegularExpression regularExpressionWithPattern:@"" options:0 error:nil];
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
