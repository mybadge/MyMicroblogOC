//
//  MMBNetworkTool.m
//  My-Microblog
//
//  Created by 赵志丹 on 15/11/30.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "MMBNetworkTool.h"

@implementation MMBNetworkTool
static MMBNetworkTool *_instance;
+ (instancetype)shareNetworkTool{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance= [[self alloc] initWithBaseURL:[NSURL URLWithString:@""]];
        
        _instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"text/plain",nil];
        
    });
    
    return _instance;
}

@end
