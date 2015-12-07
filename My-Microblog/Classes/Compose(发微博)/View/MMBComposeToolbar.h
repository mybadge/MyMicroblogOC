//
//  MMBComposeToolbar.h
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/5.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MMBComposeToolbar;

@protocol MMBComposeToolbarDelegate <NSObject>
@optional
- (void)composeToolbar:(MMBComposeToolbar *)composeToolbar didClickButton:(NSUInteger)buttonType;
@end

/** 工具栏中的按钮类型 */
typedef enum MMBComposeToolbarButtonType{
    /** 拍照 */
    MMBComposeToolbarButtonTypeCamera,
    /** 相册 */
    MMBComposeToolbarButtonTypePicture,
    /** @  提到,提及 */
    MMBComposeToolbarButtonTypeMention,
    /** # 趋势,热门话题 潮流 */
    MMBComposeToolbarButtonTypeTrend,
    /** 表情 */
    MMBComposeToolbarButtonTypeEmotion
} MMBComposeToolbarButtonType;

@interface MMBComposeToolbar : UIView
@property (nonatomic, weak) id<MMBComposeToolbarDelegate> delegate;
/** 是否显示键盘按钮 否则显示表情按钮 */
@property (nonatomic, assign, getter=isShowKeyboardButton) BOOL showKeyboardButton;
+ (instancetype)toolbar;

@end
