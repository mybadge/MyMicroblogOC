//
//  MMBStatusFrame.h
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/1.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

//  一个MMBStatusFrame模型里面包含的信息
//  1.存放着一个cell内部所有子控件的frame数据
//  2.存放一个cell的高度
//  3.存放着一个数据模型HWStatus

#import <UIKit/UIKit.h>
/** 昵称字体 */
#define MMBStatusCellNameFont [UIFont systemFontOfSize:15]
/** 时间字体 */
#define MMBStatusCellTimeFont [UIFont systemFontOfSize:12]
/** 来源字体 */
#define MMBStatusCellSourceFont MMBStatusCellTimeFont
/** 正文字体 */
#define MMBStatusCellContentFont [UIFont systemFontOfSize:14]

/** 被转发微博的正文字体 */
#define MMBStatusCellRetweetContentFont [UIFont systemFontOfSize:13]

@class MMBStatus;

@interface MMBStatusFrame : NSObject
@property (nonatomic,strong) MMBStatus *status;
/** 原创微博 */
/** 原创微博整体 */
@property (nonatomic,assign) CGRect originalViewF;
/** 头像 */
@property (nonatomic,assign) CGRect iconViewF;
/** 会员图标 */
@property (nonatomic,assign) CGRect vipViewF;
/** 配图 */
@property (nonatomic,assign) CGRect photoViewF;
/** 昵称 */
@property (nonatomic,assign) CGRect nameLabelF;
/** 时间 */
@property (nonatomic,assign) CGRect timeLabelF;
/** 来源 */
@property (nonatomic,assign) CGRect sourceLabelF;
/** 正文 */
@property (nonatomic,assign) CGRect contentLabelF;


/** 转发微博 */
/** 转发微博整体 */
@property (nonatomic, assign) CGRect retweetViewF;
/** 转发微博正文和昵称 */
@property (nonatomic, assign) CGRect retweetContentLabelF;
/** 转发配图 */
@property (nonatomic, assign) CGRect retweetPhotoViewF;
/** 底部工具条 */
@property (nonatomic, assign) CGRect toolbarF;



/** cell的高度 */
@property (nonatomic,assign) CGFloat cellHeight;



@end
