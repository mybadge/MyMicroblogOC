//
//  MMBStatusPhotosView.h
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/3.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMBStatusPhotosView : UIView
@property (nonatomic,strong) NSArray *photos;

/**
 * 根据图片的个数计算相册的尺寸
 */
+ (CGSize)sizeWithCount:(NSUInteger)count;
@end
