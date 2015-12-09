//
//  MMBEmotionTextView.m
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/8.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "MMBEmotionTextView.h"
#import "MMBEmotion.h"
#import "MMBTextAttachment.h"


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
        MMBTextAttachment *attch = [[MMBTextAttachment alloc] init];//附件类
        attch.emotion = emotion;
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

- (NSString *)fullText{
    NSMutableString *fullText = [NSMutableString string];
    
    //遍历所有的属性文字 (图片,emoji,文字)
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        //这里有个问题,就是不能根据attach的Image属性拿到image图片原来的图片名称,想了一下,如果这里的NSTextAttachment中有一个我们知道MMBEmotion模型属性就好了,我们就可以根据Emotion属性拿到emotion.chs属性了,想想真是 醉了
        MMBTextAttachment *attach = attrs[@"NSAttachment"];
        if (attach) {//图片
            [fullText appendString:attach.emotion.chs];
        }else{//emoji 和 普通文本
            //range 获取这个范围内的内容
            NSAttributedString *text = [self.attributedText attributedSubstringFromRange:range];
            [fullText appendString:text.string];
        }
    }];
    
    return fullText;
}

@end
