//
//  SplashscreenViewController.h
//  OneDay
//
//  Created by feng on 15/9/22.
//  Copyright (c) 2015年 Mr.ZhixinDuan. All rights reserved.
//

@interface SplashscreenViewController : UIViewController<UIScrollViewDelegate>
@property (weak , nonatomic) UIView * statusView;

/**
 *  前面的scrollViewF
 */
@property (strong, nonatomic) UIScrollView *scrollViewF;
@property (assign , nonatomic) NSInteger curPage;
@property (assign , nonatomic) NSInteger totalPages;
/**
 *  后面的scrollView
 */
@property (weak , nonatomic) UIScrollView * scrollViewB;
/**
 *  导航栏view
 */
@property (weak , nonatomic) UIView * labelView;
/**
 *  存放所有图片模型的数组
 */
@property (strong , nonatomic) NSMutableArray * imagesArray;
/**
 *  缓冲数组(存放图片)
 */
@property (strong , nonatomic) NSMutableArray * curImages;
/**
 *  添加定时器
 */
@property (strong , nonatomic) NSTimer * timer;

@property (strong , nonatomic) UIPageControl * pageControl;
/**
 *  索引,用来在调用nextImage方法时使图片滚到下一张
 */
@property (assign , nonatomic) int index;
@property (nonatomic, copy) WZFlashButtonDidClickBlock clickBlock;
@end
