//
//  MMBTextAttachment.h
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/9.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MMBEmotion;
//插入属性到光标位置 插入表情本来就是TextView的功能,所有就写了个分类,他的功能和系统的插入文字是类似的,只不过这里插入的是表情,设置文字大小属性,需要用户自己来决定,而且想只写一次设置插入表情功能,所以就写了一个block
@interface MMBTextAttachment : NSTextAttachment
@property (nonatomic, strong) MMBEmotion *emotion;



@end
