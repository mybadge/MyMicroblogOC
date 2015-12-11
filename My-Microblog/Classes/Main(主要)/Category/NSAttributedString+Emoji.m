//
//  NSAttributedString+Emoji.m
//  MiYa
//
//  Created by GX on 14/12/18.
//  Copyright (c) 2014年 WLA. All rights reserved.
//

#import "NSAttributedString+Emoji.h"
#import <UIKit/UIKit.h>


@interface EmojiAttachment : NSTextAttachment

@end

@implementation EmojiAttachment

//I want my emoticon has the same size with line's height
- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex
{
    return CGRectMake( 0 , -3, lineFrag.size.height, lineFrag.size.height);
}

@end

#import "MMBEmotionTool.h"


@implementation NSAttributedString (Emoji)

+ (NSAttributedString *)emojiStringWithString:(NSMutableAttributedString *)emojiString //convertBlock:(void (^)(NSString *emoji))convertBlock
{
    NSRegularExpression *regularEx =
    //[NSRegularExpression regularExpressionWithPattern:@"\\[\\S+\\]" options:NSRegularExpressionCaseInsensitive error:nil];
    [NSRegularExpression regularExpressionWithPattern:@"\\[\\S*?\\]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSString *string = emojiString.string;
    
    NSTextCheckingResult *result = [regularEx firstMatchInString:string options:NSMatchingReportCompletion range:NSMakeRange(0, string.length)];
    if (result != nil) {
        NSString *imageName = [string substringWithRange:result.range];
        NSLog(@"%@",imageName);
        EmojiAttachment *attachment = [[EmojiAttachment alloc] initWithData:nil ofType:nil];
        UIImage *image = [MMBEmotionTool getEmotionWithName:imageName];
        //如果图片为空 直接返回
        if (image == nil)  return emojiString;
        
        attachment.image = image;
        NSAttributedString *attrString = [NSAttributedString attributedStringWithAttachment:attachment];
        
        [emojiString replaceCharactersInRange:result.range withAttributedString:attrString];
        // 递归
        [self emojiStringWithString:emojiString];
    } else {
        return emojiString;
    }
    return emojiString;
}

@end
