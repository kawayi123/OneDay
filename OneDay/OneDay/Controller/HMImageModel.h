//
//  HMImageModel.h
//  修改无限循环
//
//  Created by leo on 14-12-7.
//  Copyright (c) 2014年 itheima. All rights reserved.
//

@interface HMImageModel : NSObject
/**
 *  图片名
 */
@property (copy , nonatomic) NSString * imageName;
/**
 *  url
 */
@property (copy , nonatomic) NSString * url;
/**
 *  描述
 */
@property (copy , nonatomic) NSString * desc;
/**
 *  数据数组
 */
@property (strong , nonatomic) NSArray * scrDataArray;

+ (instancetype)imageModelWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
