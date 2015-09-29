//
//  ZJLoopScrollView.h
//  ZJLoopScrollView
//
//  Created by mac on 13-10-17.
//  Copyright (c) 2013年 zhang jian. All rights reserved.
//

#import <UIKit/UIKit.h>

//========用法============
/*
    //1.先包含头文件
    //#import "ZJLoopScrollView.h"
 
 
 //创建循环滚动视图
 ZJLoopScrollView *loopScrollView = [[ZJLoopScrollView alloc] init];
 loopScrollView.frame = CGRectMake(0, 20, 320, 460);
 loopScrollView.pageCount = 4;
 
 //设置本地图片
 

//设置网络图片
_imageArray = @[@"http://mp.manzuo.com/pic/act/wap.jpg",
                @"http://mp.manzuo.com/pic/act/banner_20141110154630.jpg",
                @"http://mp.manzuo.com/pic/act/banner_20141106115308.jpg",
                @"http://mp.manzuo.com/pic/act/hlbanner.jpg"];
for (int i=0; i<_imageArray.count; i++) {
    [loopScrollView setImageWithUrlString:_imageArray[i] atIndex:i];
}

loopScrollView.autoScroll = YES;
[self.view addSubview:loopScrollView];

*/


//功能: 自动循环滚动显示多张图片
@interface ZJLoopScrollView : UIView

//需要显示的页数
@property (nonatomic) int pageCount;

//设置某个位置处的图片
-(void)setImage:(UIImage *)image atIndex:(int)index;
-(void)setImageWithUrlString:(NSString *)urlString atIndex:(int)index;

//是否自动滚动
@property (nonatomic) BOOL autoScroll;

//是否显示pageControl
@property (nonatomic) BOOL showPageControl;

@property (strong,nonatomic) UIScrollView *scrollView;
@property (strong,nonatomic) UIPageControl *pageControl;

//每张添加点击处理 - block
-(void)setClickAction:(void(^)(UIImageView *imageView, int index) )action;

@end
