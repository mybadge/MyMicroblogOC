//
//  MMBStatusFrame.m
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/1.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "MMBStatusFrame.h"
#import "MMBStatus.h"
#import "MMBUser.h"

// cell的边框宽度
#define MMBStatusCellBorderW 10

@implementation MMBStatusFrame

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font{
    return [self sizeWithText:text font:font maxW:MAXFLOAT];
}

- (void)setStatus:(MMBStatus *)status{
    _status = status;
    
    MMBUser *user = status.user;
    
    //cell的宽度
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    
    /** 原创微博 */
    /** 头像 */
    CGFloat iconWH = 35;
    CGFloat iconX = MMBStatusCellBorderW;
    CGFloat iconY = iconX;
    self.iconViewF = CGRectMake(iconX, iconY, iconWH, iconWH);
    
    /** 昵称 */
    CGFloat nameX = CGRectGetMaxX(self.iconViewF) + MMBStatusCellBorderW;
    CGFloat nameY = iconY;
    CGSize nameSize = [self sizeWithText:user.name font:MMBStatusCellNameFont];
    self.nameLabelF = (CGRect){{ nameX, nameY }, nameSize };
    
    /** 会员图标 */
    CGFloat vipX = CGRectGetMaxX(self.nameLabelF) + MMBStatusCellBorderW;
    CGFloat vipY = nameY;
    CGFloat vipWH = 14;
    self.vipViewF = CGRectMake(vipX, vipY, vipWH, vipWH);
    
    /** 时间 */
    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(self.nameLabelF) + MMBStatusCellBorderW;
    CGSize timeSize = [self sizeWithText:status.created_at font:MMBStatusCellTimeFont];
    self.timeLabelF = (CGRect){{ timeX, timeY }, timeSize };
    
    /** 来源 */
    CGFloat sourceX = CGRectGetMaxX(self.timeLabelF) + MMBStatusCellBorderW;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [self sizeWithText:status.source font:MMBStatusCellSourceFont];
    self.sourceLabelF = (CGRect){{ sourceX, sourceY }, sourceSize };
    
    /** 正文 */
    CGFloat contentX = iconX;
    CGFloat contentY = MAX(CGRectGetMaxY(self.iconViewF), CGRectGetMaxY(self.timeLabelF)) + MMBStatusCellBorderW;
    CGFloat maxW = cellW - 2*contentX;
    CGSize contentSize = [self sizeWithText:status.text font:MMBStatusCellContentFont maxW:maxW];
    self.contentLabelF = (CGRect){{ contentX, contentY }, contentSize };

    /** 配图 */
    CGFloat originalH = 0;
    if (status.pic_urls.count){
        CGFloat photoWH = 80;
        CGFloat photoX = contentX;
        CGFloat photoY = CGRectGetMaxY(self.contentLabelF) + MMBStatusCellBorderW;
        self.photoViewF = CGRectMake(photoX, photoY, photoWH, photoWH);
        originalH = CGRectGetMaxY(self.photoViewF) + MMBStatusCellBorderW;
    }else{
        originalH = CGRectGetMaxY(self.contentLabelF) + MMBStatusCellBorderW;
    }
    
    /** 原创微博整体 */
    CGFloat originalX = 0;
    CGFloat originalY = 0;
    CGFloat originalW = cellW;
    self.originalViewF = CGRectMake(originalX, originalY, originalW, originalH);

    self.cellHeight = CGRectGetMaxY(self.originalViewF);
}















@end
