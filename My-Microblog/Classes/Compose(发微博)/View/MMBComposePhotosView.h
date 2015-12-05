//
//  MMBComposePhotosView.h
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/5.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMBComposePhotosView : UIView
@property (nonatomic, strong, readonly) NSMutableArray *photos;

- (void)addPhoto:(UIImage *)photo;
@end
