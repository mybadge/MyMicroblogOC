//
//  UITextView+Extention.h
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/8.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Extention)
/**
 *  拼接表情
 */
- (void)insertAttrbuteString:(NSAttributedString *)text;

/**
 *  拼接表情 还可以设置属性
 */

- (void)insertAttrbuteString:(NSAttributedString *)text settingBlock:(void (^)(NSMutableAttributedString *))settingBlock;
@end
