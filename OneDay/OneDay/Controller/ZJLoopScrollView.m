//
//  ZJLoopScrollView.m
//  ZJLoopScrollView
//
//  Created by mac on 13-10-17.
//  Copyright (c) 2013年 zhang jian. All rights reserved.
//

#import "ZJLoopScrollView.h"

@interface ZJLoopScrollView ()<UIScrollViewDelegate>
{
    NSTimer *_myTimer;
    
    UIImageView *_preImageView;
    UIImageView *_lastImageView;
    NSMutableArray *_imageViewArray;
    
    void(^_action)(UIImageView *imageView, int index);
}
@end

@implementation ZJLoopScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//每张添加点击处理 - block
-(void)setClickAction:(void(^)(UIImageView *imageView, int index) )action
{
    _action = action;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self refreshUI];
}

-(void)setPageCount:(int)pageCount
{
    _pageCount = pageCount;
    [self refreshUI];
}
//设置某个位置处的图片
-(void)setImage:(UIImage *)image atIndex:(int)index
{
    if(index<0 || index >_pageCount - 1)
    {
        return;
    }
    if(index == _pageCount - 1)
    {
        _preImageView.image = image;
    }
    if(index == 0)
    {
        _lastImageView.image = image;
    }
    
    UIImageView *view = _imageViewArray[index];
    view.image = image;
    
}
-(void)setImageWithUrlString:(NSString *)urlString atIndex:(int)index
{
    if(index<0 || index >_pageCount - 1)
    {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //下载图片
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]];
        
        //下载完成设置图片
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            if(index == _pageCount - 1)
            {
                _preImageView.image = [UIImage imageWithData:data];
            }
            if(index == 0)
            {
                _lastImageView.image = [UIImage imageWithData:data];
            }
            
            UIImageView *view = _imageViewArray[index];
            view.image = [UIImage imageWithData:data];

        });
        
        
    });
    
    
  
}

-(void)refreshUI
{
    if(_pageCount == 0)
    {
        return;
    }
    
    //先移除以前的视图
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    //创建滚动视图
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:_scrollView];
    _scrollView.bounces = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    

    //add the last image first
    //  [UIImage imageNamed:[_imageArray objectAtIndex:([_imageArray count]-1)]]
    _preImageView = [[UIImageView alloc] initWithImage:nil];
    
    _preImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [_scrollView addSubview:_preImageView];

    _preImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *preTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dealTap:)];
    _preImageView.tag = -1;
    [_preImageView addGestureRecognizer:preTap];
    
    
    //[UIImage imageNamed:[_imageArray objectAtIndex:i]]
    _imageViewArray = [[NSMutableArray alloc] init];
    for (int i = 0;i<_pageCount;i++) {
        //loop this bit
        UIImageView *imageView = [[UIImageView alloc] initWithImage:nil];
        imageView.frame = CGRectMake((self.frame.size.width * i) + 0 + 320, 0, self.frame.size.width, self.frame.size.height);
        [_scrollView addSubview:imageView];
        [_imageViewArray addObject:imageView];
        
        //添加手势
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dealTap:)];
        imageView.tag = i;
        [imageView addGestureRecognizer:tap];
    }
    
    //add the first image at the end
    //  [UIImage imageNamed:[_imageArray objectAtIndex:0]]
    _lastImageView = [[UIImageView alloc] initWithImage:nil];
    _lastImageView.frame = CGRectMake((self.frame.size.width * (_pageCount + 1)) + 0, 0, self.frame.size.width, self.frame.size.height);
    _lastImageView.tag = _pageCount;
    [_scrollView addSubview:_lastImageView];
    
    _lastImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *lastTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dealTap:)];
    [_preImageView addGestureRecognizer:lastTap];
    
    
    
    [_scrollView setContentSize:CGSizeMake(self.frame.size.width * (_pageCount + 2), self.frame.size.height)];
    [_scrollView setContentOffset:CGPointMake(0, 0)];

    [_scrollView scrollRectToVisible:CGRectMake(self.frame.size.width,0,self.frame.size.width,self.frame.size.height) animated:NO];

    

    //添加页面控制
    //创建pageControl
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    _pageControl.center = CGPointMake(self.frame.size.width/2, self.frame.size.height - 20);
    [self addSubview:_pageControl];
    _pageControl.numberOfPages = _pageCount;
    //设置选中page的颜色
    _pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    
    //默认隐藏
    _pageControl.hidden = YES;

    
    
    //添加自动滚动
    [self performSelector:@selector(updateScrollView) withObject:nil afterDelay:0.0f];

}

-(void)dealTap:(UITapGestureRecognizer *)tap
{
    if(_action)
    {
        _action((UIImageView *)tap.view,tap.view.tag);
    }
}

#pragma mark - 循环滚动

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int currentPage = floor((scrollView.contentOffset.x - scrollView.frame.size.width / (_pageCount+2)) / scrollView.frame.size.width) + 1;
    if (currentPage==0) {
        //go last but 1 page
        [scrollView scrollRectToVisible:CGRectMake(self.frame.size.width * _pageCount,0,self.frame.size.width,self.frame.size.height) animated:NO];
    } else if (currentPage==(_pageCount+1)) { //如果是最后+1,也就是要开始循环的第一个
        [scrollView scrollRectToVisible:CGRectMake(self.frame.size.width,0,self.frame.size.width,self.frame.size.height) animated:NO];
    }
    
    [self updatePageControl];
}

-(void)updatePageControl
{
    if(_scrollView.frame.size.width == 0)
    {
        return;
    }
    int index = _scrollView.contentOffset.x / _scrollView.frame.size.width;
    //NSLog(@"index = %d",index);
    _pageControl.currentPage = index-1;
}

#pragma mark - 是否自动隐藏
-(void)setShowPageControl:(BOOL)showPageControl
{
    _showPageControl = showPageControl;
    _pageControl.hidden = !showPageControl;
}

#pragma mark - 自动滚动

- (void) updateScrollView
{
    [_myTimer invalidate];
    _myTimer = nil;
    //time duration
    NSTimeInterval timeInterval = 3;
    //timer
    _myTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(handleMaxShowTimer:) userInfo:nil repeats:YES];
}

- (void)handleMaxShowTimer:(NSTimer*)theTimer
{
    //控制是否自动滚动
    if(_autoScroll == NO)
    {
        return;
    }
    
    CGPoint pt = _scrollView.contentOffset;
    int count = _pageCount;
    if(pt.x == _scrollView.frame.size.width * count){
        [_scrollView setContentOffset:CGPointMake(0, 0)];
        [_scrollView scrollRectToVisible:CGRectMake(_scrollView.frame.size.width,0,_scrollView.frame.size.width,_scrollView.frame.size.height) animated:YES];
    }else{
        [_scrollView scrollRectToVisible:CGRectMake(pt.x+_scrollView.frame.size.width,0,_scrollView.frame.size.width,_scrollView.frame.size.height) animated:YES];
    }
    
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self updatePageControl];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
