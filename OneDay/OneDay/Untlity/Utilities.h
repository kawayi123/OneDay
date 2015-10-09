//
//  Utilities.h
//  Utility
//
//  Created by ZIYAO YANG on 15/8/20.
//  Copyright (c) 2015年 Ziyao Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject

//根据key获取缓存userDefault
+ (id)getUserDefaults:(NSString *)key;
//根据key设置userDefault
+ (void)setUserDefaults:(NSString *)key content:(id)value;
//根据key删除缓存userDefault
+ (void)removeUserDefaults:(NSString *)key;
//根据identity获得页面控制器实例
+ (id)getStoryboardInstanceByIdentity:(NSString*)identity;
//弹出提示框
+ (void)popUpAlertViewWithMsg:(NSString *)msg andTitle:(NSString* )title;
//获得保护膜
+ (UIActivityIndicatorView *)getCoverOnView:(UIView *)view ;
//先去内存里去找图片，如果没有找到，就通过线程的url把图片下载并缓存，存到硬盘里
+ (UIImage *)imageUrl:(NSString *)url;
@end
