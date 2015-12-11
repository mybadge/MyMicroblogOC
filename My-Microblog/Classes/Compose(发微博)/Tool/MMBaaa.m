//
//  MMBaaa.m
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/11.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "MMBaaa.h"

@implementation MMBaaa

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    
    return self;
}

+ (instancetype)aaaWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

+ (NSMutableArray *)aa{
    NSArray *array=[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"<#fileName#>.plist" ofType:nil]];
    NSMutableArray *arrayM=[NSMutableArray arrayWithCapacity:array.count];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[self <#name#>WithDict:dict]];
    }
    return arrayM;
    
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p> {<#field1#>: %@, <#field2#>: %@ }", self.class, self, self.<#field1#>, self.<#field2#>];
}
@end
