//
//  UITextView+Extention.m
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/8.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "UITextView+Extention.h"
@implementation UITextView (Extention)
- (void)insertAttrbuteString:(NSAttributedString *)text{
    NSMutableAttributedString *attrbutedString = [[NSMutableAttributedString alloc] init];
    //拼接之前的文字和图片
    [attrbutedString appendAttributedString:self.attributedText];
    
    //插入图片
    NSUInteger loc = self.selectedRange.location;
    [attrbutedString insertAttributedString:text atIndex:loc];
    self.attributedText = attrbutedString;
    
    //移动光标到表情的后面
    self.selectedRange = NSMakeRange(loc + 1, 0);
}
@end
