//
//  NSString+Extension.h
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/07.
//  Copyright © 2015年 赵志丹. All rights reserved.


#import <Foundation/Foundation.h>

@interface NSString (Extension)
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;
- (CGSize)sizeWithFont:(UIFont *)font;
@end
