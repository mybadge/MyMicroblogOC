//
//  MMBEmotionTextView.m
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/8.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "MMBEmotionTextView.h"
#import "MMBEmotion.h"


@implementation MMBEmotionTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)insertEmotion:(MMBEmotion *)emotion{
    if (emotion.code) {
        [self insertText:emotion.code.emoji];
    }else if (emotion.png){
        
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
        //加载图片
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];//附件类
        attch.image = [UIImage imageNamed:emotion.png];
        NSLog(@"image = %@",[UIImage imageNamed:emotion.png]);
        CGFloat attchWH = self.font.lineHeight;
        attch.bounds = CGRectMake(0, -4, attchWH, attchWH);
        
        //根据附件创建一个文字属性
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attch];
        NSUInteger loc = self.selectedRange.location;
        NSLog(@"%zd",loc);
        NSLog(@"%@",imageStr);
        
        //拼接附件
        
        
        //[attributedText replaceCharactersInRange:self.selectedRange withAttributedString:imageStr];
        [attributedText appendAttributedString:imageStr];
        //        [attributedText insertAttributedString:imageStr.copy atIndex:loc];
        
        //        [attributedText insertAttributedString:imageStr atIndex:loc];
        [attributedText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedText.length)];
        self.attributedText = attributedText;
        self.selectedRange = NSMakeRange(loc+1, 0);
        
        ////插入属性到光标位置
        //[self insertAttrbuteString:imageStr];
        
        ////设置字体
        //NSMutableAttributedString *text = (NSMutableAttributedString *)self.attributedText;
        //        [text addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, text.length)];
        
    }
}


@end
