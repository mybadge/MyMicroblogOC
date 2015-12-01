//
//  MMBNetworkTool.h
//  My-Microblog
//
//  Created by 赵志丹 on 15/11/30.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface MMBNetworkTool : AFHTTPRequestOperationManager

+ (instancetype)shareNetworkTool;
@end
