//
//  MMBEmotionPageView.h
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/7.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import <UIKit/UIKit.h>
//一页中做多三行
#define MMBEmotionMaxRows 3
//一夜中最多7列
#define MMBEmotionMaxCols 7
#define MMBEmotionPageSize ((MMBEmotionMaxRows * MMBEmotionMaxCols) - 1)
                                                         
@interface MMBEmotionPageView : UIView

@property (nonatomic, strong) NSArray *emotions;
@end
