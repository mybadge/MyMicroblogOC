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
    //拼接文本框内所有的字符串, 否则会报错
    //reason: 'NSMutableRLEArray insertObject:range:: Out of bounds'
    //NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    //加载图片
    //拼接之前的文字和图片
    NSMutableAttributedString *attrbutedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    
    //[attrbutedString appendAttributedString:self.attributedText];
    
    //插入图片
    NSUInteger loc = self.selectedRange.location;
    //[attrbutedString insertAttributedString:text atIndex:loc];
    [attrbutedString replaceCharactersInRange:self.selectedRange withAttributedString:text];
    self.attributedText = attrbutedString;
    

    
    //移动光标到表情的后面
    self.selectedRange = NSMakeRange(loc + 1, 0);
}

- (void)insertAttrbuteString:(NSAttributedString *)text settingBlock:(void (^)(NSMutableAttributedString *))settingBlock{
    //拼接之前的文字和图片
    NSMutableAttributedString *attrbutedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    
    //[attrbutedString appendAttributedString:self.attributedText];
    
    //插入图片
    NSUInteger loc = self.selectedRange.location;
    //[attrbutedString insertAttributedString:text atIndex:loc];
    [attrbutedString replaceCharactersInRange:self.selectedRange withAttributedString:text];
    if (settingBlock) {
        settingBlock(attrbutedString);
    }
    self.attributedText = attrbutedString;
    
    
    
    //移动光标到表情的后面
    self.selectedRange = NSMakeRange(loc + 1, 0);
}
@end
