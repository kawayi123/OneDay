//
//  HMImageModel.m
//  修改无限循环
//
//  Created by leo on 14-12-7.
//  Copyright (c) 2014年 itheima. All rights reserved.
//

#import "HMImageModel.h"

@implementation HMImageModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)imageModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}
@end
