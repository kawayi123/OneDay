//
//  introduceViewController.m
//  OneDay
//
//  Created by 段志鑫 on 15/9/21.
//  Copyright (c) 2015年 Mr.ZhixinDuan. All rights reserved.
//

#import "introduceViewController.h"
#import "TabBarController.h"

@interface introduceViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong)UIScrollView * scrollView;
@property (nonatomic,strong)UIPageControl * pageControl;
@property (nonatomic,strong)UIButton * button;
@property (nonatomic) int currentPage;
@end

@implementation introduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
    [self createScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 启动页面
-(void)createScrollView{
    
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(screenWidth * 5, screenHeight);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.alwaysBounceVertical = NO;
    _scrollView.alwaysBounceHorizontal = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:_scrollView];
    
    
    //创建图片加载到scrollView中
    NSArray * imageArray = @[@"1.png",@"2.png",@"3.png",@"4.png",@"5.png"];
    for (int i = 0; i < 5; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(i*screenWidth, 0, screenWidth, screenHeight);
        imageView.image = [UIImage imageNamed:[imageArray objectAtIndex:i]];
        [self.scrollView addSubview:imageView];
    }
    //设置pageControl
    self.pageControl = [[UIPageControl alloc]init];
    self.pageControl.frame = CGRectMake(screenWidth/2 - 200/2, screenHeight-100, 200, 50);
    self.pageControl.numberOfPages = 5 ;
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self.pageControl];
    
    _button = [UIButton buttonWithType:UIButtonTypeSystem];
    _button.frame = CGRectMake(screenWidth-40, 30, 30, 30);
    [_button setTitle:@"进入" forState:UIControlStateNormal];
    //[_button setBackgroundColor:[UIColor orangeColor]];
    [_button setTintColor:[UIColor orangeColor]];
    //[self performSelector:@selector(buttonAction) withObject:nil afterDelay:1];
    [[UIApplication sharedApplication].keyWindow addSubview:_button];
    [_button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];

}
#pragma mark - scrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.currentPage = scrollView.contentOffset.x/screenWidth;
    //赋值
    self.pageControl.currentPage = self.currentPage ;

}
-(void)buttonAction{
    FRelease(_button);
    FRelease(_scrollView);
    FRelease(_pageControl);
    [self dismissViewControllerAnimated:NO completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
