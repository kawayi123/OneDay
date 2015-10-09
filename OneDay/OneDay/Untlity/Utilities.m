//
//  Utilities.m
//  Utility
//
//  Created by ZIYAO YANG on 15/8/20.
//  Copyright (c) 2015年 Zhong Rui. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

+ (id)getUserDefaults:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (void)setUserDefaults:(NSString *)key content:(id)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removeUserDefaults:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (id)getStoryboardInstanceByIdentity:(NSString*)identity
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    return [storyboard instantiateViewControllerWithIdentifier:identity];
}
+ (void)popUpAlertViewWithMsg:(NSString *)msg andTitle:(NSString* )title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title == nil ? @"提示" : title message:msg == nil ? @"操作失败" : msg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
    [alertView show];
}
+ (UIActivityIndicatorView *)getCoverOnView:(UIView *)view {
    UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    aiv.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.4];
    aiv.frame = view.bounds;
    [view addSubview:aiv];
    [aiv startAnimating];
    return aiv;
}
//先去内存里去找图片，如果没有找到，就通过线程的url把图片下载并缓存，存到硬盘里
+ (UIImage *)imageUrl:(NSString *)url {
    if ([url isKindOfClass:[NSNull class]]||url==nil) {
        return nil;
    }
    
    static dispatch_queue_t backgroundQueue;
    if (backgroundQueue == nil) {
        backgroundQueue = dispatch_queue_create("com.beilyton.queue", NULL);
    }
    
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);//在app沙盒中，获得了所有的文件路径的列表
    NSString *documentDirectory = [directories objectAtIndex:0];
    __block NSString *filePath = nil;//返回根目录
    filePath = [documentDirectory stringByAppendingPathComponent:[url lastPathComponent]];//获得文件路径
    UIImage *imageInFile = [UIImage imageWithContentsOfFile:filePath];//如果存在图片，就把图片给到imageInFile
    if (imageInFile) {
        return imageInFile;
    }
    
    __block NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];//通过NSData转换成数据流
    if (!data) {
        NSLog(@"Error retrieving %@", url);
        return nil;
    }
    UIImage *imageDownloaded = [[UIImage alloc] initWithData:data];//把数据流重新翻译成图片
    dispatch_async(backgroundQueue, ^(void) {
        [data writeToFile:filePath atomically:YES];//把图片写入文件filePath里
        NSLog(@"Wrote to: %@", filePath);
    });
    return imageDownloaded;
}

@end
