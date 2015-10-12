//
//  SplashscreenViewController.m
//  OneDay
//
//  Created by feng on 15/9/22.
//  Copyright (c) 2015年 Mr.ZhixinDuan. All rights reserved.
//

#import "SplashscreenViewController.h"
#import "UIView+FrameExpand.h"
#import "HMImageModel.h"
#import "TabBarController.h"
@interface SplashscreenViewController ()

@end

@implementation SplashscreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self img];
    [self setUpData];
    [self refreshScrollView];
    [self addTimer];
    [self addPageControl];
    [self btn];
}
-(void)btn
{
    WZFlashButton *btn = [[WZFlashButton alloc] initWithFrame:CGRectMake(100, 560, 165, 45)];
    btn.backgroundColor = [UIColor colorWithRed:50.0f/255.0f green:35.0f/255.0f blue:0.5f alpha:1.0f];
    
    [btn setText:@"进入体验" withTextColor:nil];
    btn.clickBlock = ^(void) {
       TabBarController *tabVC=[Utilities getStoryboardInstanceByIdentity:@"tab"];//获得Storyboardid的实例
       //[self presentViewController:tabVC animated:YES completion:nil];
        //[self presentViewController:tabVC animated:YES completion:nil];
        //[self dismissViewControllerAnimated:YES completion:nil];
      // [self performSegueWithIdentifier:@"tab" sender:self];
        //[self.navigationController popToViewController:tabVC animated:YES];
        [self.navigationController pushViewController:tabVC animated:YES];
    };
    [self.view addSubview:btn];
    
}
-(void)img
{
    //1 初始化数组数据(从服务器请求数据,请求回来的数据转换成HMImageModel)
    for (int i = 1 ; i < HMImageCount; i++) {
        
        NSString * imageName = [NSString stringWithFormat:@"%d.png",i];
        
        HMImageModel * imageModel = [[HMImageModel alloc] init];
        imageModel.imageName = imageName;
        
        [self.imagesArray addObject:imageModel];
        
    }
}
/**
 *  循环容器数组
 */
- (NSMutableArray *)curImages
{
    if (!_curImages) {
        _curImages = [[NSMutableArray alloc] init];
    }
    return _curImages;
}
/**
 *  图片模型数组
 */
- (NSMutableArray *)imagesArray
{
    if (_imagesArray == nil) {
        _imagesArray = [[NSMutableArray alloc] init];
    }
    return _imagesArray;
}
#pragma mark - 加载视图控件
- (void)setUpData
{
    //2 初始化其他相关的值
    _totalPages = _imagesArray.count;
    _curPage = 1;
    _index = 0;
    _curImages = [[NSMutableArray alloc] init];
    //3 初始化前面的scrollViewB
    UIScrollView * scrollViewB = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    self.scrollViewB = scrollViewB;
    
    //scrollViewB.backgroundColor = [UIColor greenColor];//purpleColor
    _scrollViewB.showsHorizontalScrollIndicator = NO;
    _scrollViewB.pagingEnabled = YES;
    _scrollViewB.delegate = self;
    _scrollViewB.contentSize = CGSizeMake(self.view.width * HMImageCount,0);
    [self.view addSubview:self.scrollViewB];
}
- (void)refreshScrollView
{
    
    //前面的轮播器
    NSArray *subViewsB = [self.scrollViewB subviews];
    if([subViewsB count] != 0) {
        [subViewsB makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    [self getDisplayImagesWithCurpage:self.curPage];
    
    for (int i = 0; i < 3; i++) {
#pragma mark - imageView换成按钮
        UIButton * scrBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString * imageName = [[self.curImages objectAtIndex:i] imageName];
        scrBtn.userInteractionEnabled = NO;
        [scrBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        scrBtn.frame = CGRectMake(i * self.view.width, 0, self.view.width, self.view.height);
        [self.scrollViewB addSubview:scrBtn];
    }
    for (int i = 0; i < 3; i++) {
#pragma mark - imageView换成按钮
        UIButton * scrBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString * imageName = [[self.curImages objectAtIndex:i] imageName];
        scrBtn.userInteractionEnabled = NO;
        [scrBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        scrBtn.frame = CGRectMake(i * self.view.width, 0, self.view.width, self.view.height);
        [self.scrollViewB addSubview:scrBtn];
    }
    [self.scrollViewB setContentOffset:CGPointMake(self.scrollViewB.width, 0)];
}

- (NSArray *)getDisplayImagesWithCurpage:(NSInteger)page
{
    
    NSInteger pre = [self validPageValue:self.curPage-1];
    NSInteger last = [self validPageValue:self.curPage+1];
    
    [self.curImages removeAllObjects];
    
    [self.curImages addObject:[self.imagesArray objectAtIndex:pre-1]];
    [self.curImages addObject:[self.imagesArray objectAtIndex:page-1]];
    [self.curImages addObject:[self.imagesArray objectAtIndex:last-1]];

    
#pragma  mark - 在这设置pageControl的currentPage
    self.pageControl.currentPage = self.curPage - 1;
    
    return self.curImages;
}
- (NSInteger)validPageValue:(NSInteger)value
{
    
    if(value == 0) value = self.totalPages;// value＝1为第一张，value = 0为前面一张
    if(value == self.totalPages + 1) value = 1;
    
    return value;
}
#pragma mark - 添加定时器
- (void)addTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    /**
     *  pragma mark - 将定时器添加到主消息循环中,即可在主线程中给NSTimer分配优先级,
     *  让它在主线程中同时运行(属于更新UI界面)
     */
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
#pragma mark - 添加pageControl
- (void)addPageControl
{
    UIPageControl * pageControl = [[UIPageControl alloc] init];
    CGFloat centerX = self.scrollViewB.frame.size.width * 0.5;
    CGFloat centerY = self.scrollViewB.frame.size.height * 0.96;
    pageControl.center = CGPointMake(centerX, centerY);
    
#pragma mark - 9 设置圆点的颜色
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    
#pragma mark - 10 设置分页总数为图片模型数组的长度
    pageControl.numberOfPages = self.imagesArray.count;
    
    //将pageControl添加到headView上
        [self.view addSubview:pageControl];
    self.pageControl = pageControl;
    
}
#pragma mark - 点击nextImage
- (void)nextImage
{
    //当前的offset的x值
    int x = self.scrollViewB.contentOffset.x;
    
#pragma mark - index++ ,让 _scrollView.contentOffset 的值发生变
    _index++;
    [self.scrollViewB setContentOffset:CGPointMake(x * _index, 0) animated:YES];
}
#pragma  mark - 正在拖拽
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
        self.statusView.hidden = NO;
        self.labelView.hidden = NO;
    
    NSInteger x = self.scrollViewB.contentOffset.x;
    
    if(x >= (2 * self.scrollViewB.frame.size.width)) {
        
        _curPage = [self validPageValue:_curPage + 1];
        
        [self refreshScrollView];
    }
    //上一张
    if(x <= 0) {
        _curPage = [self validPageValue:_curPage-1];
        
        [self refreshScrollView];
    }
#pragma mark - index = 0 ,让 _scrollView.contentOffset 的值重置
    _index = 0;
    
    
    //垂直方向上滚动微调(headView和后面轮播器y值偏移微调)
    CGRect viewF = self.scrollViewB.frame;
    //    NSLog(@"%@",NSStringFromCGRect(self.scrollViewB.frame));
    self.scrollViewB.frame = viewF;
    
    //水平方向上滚动约束条件(拖动时如果offset.x的值<=0 或者>= 最有一张.x图片会乱抖)
    CGPoint offset = self.scrollViewB.contentOffset;
    if (offset.x >0 && offset.x < self.view.width * (HMImageCount - 1)) {
        offset.x = self.scrollViewB.contentOffset.x;
        self.scrollViewB.contentOffset = offset;
        
    }
    
#pragma mark - 以下是决定组标题与导航栏相遇时标题文字更换的操作

    //获取导航栏透明度的值
    //    CGFloat al = self.navLabel.alpha;
    CGFloat al = self.labelView.alpha;
    //赋值给状态栏背景view的透明度(不要用直接计算的方式,直接计算与导航栏的透明度显示过程不对称)
       self.statusView.alpha = al;
        self.labelView.hidden = YES;
        //加上这句(可以控制轮播器移出顶部时状态栏的不见的情况)
        self.statusView.alpha = 1;

    
}

#pragma mark - 移除定时器
- (void)removeTimer
{
    [_timer invalidate];
    _timer = nil;
    
}

#pragma mark - 代理方法:开始拖拽时
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}

#pragma mark - 代理方法: 停止拖拽时
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
