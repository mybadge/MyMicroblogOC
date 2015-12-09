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
        //拼接文本框内所有的字符串, 否则会报错
        //reason: 'NSMutableRLEArray insertObject:range:: Out of bounds'
        //NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        //加载图片
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];//附件类
        attch.image = [UIImage imageNamed:emotion.png];
        CGFloat attchWH = self.font.lineHeight;
        attch.bounds = CGRectMake(0, -4, attchWH, attchWH);
        
        //根据附件创建一个文字属性
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attch];
        
        
        //插入属性到光标位置 插入表情本来就是TextView的功能,所有就写了个分类,他的功能和系统的插入文字是类似的,只不过这里插入的是表情,设置文字大小属性,需要用户自己来决定,而且想只写一次设置插入表情功能,所以就写了一个block
        [self insertAttrbuteString:imageStr settingBlock:^(NSMutableAttributedString *text) {
            //设置字体, 封装到了UItextView分类中
            [text addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, text.length)];
        }];
    }
}


@end
