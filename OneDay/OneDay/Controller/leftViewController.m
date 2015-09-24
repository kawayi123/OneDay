//
//  leftViewController.m
//  OneDay
//
//  Created by 段志鑫 on 15/9/21.
//  Copyright (c) 2015年 Mr.ZhixinDuan. All rights reserved.
//

#import "leftViewController.h"
#import "logInViewController.h"
@interface leftViewController ()
- (IBAction)loginAction:(UIButton *)sender forEvent:(UIEvent *)event;

@end

@implementation leftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _btn.enabled=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loginAction:(UIButton *)sender forEvent:(UIEvent *)event
{
    //_btn.enabled=NO;
//    logInViewController *change = [self.storyboard instantiateViewControllerWithIdentifier:@"show"];
//    //初始化导航控制器
//    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:change];
//    //动画效果
//    nc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    //导航条隐藏掉
//    nc.navigationBarHidden = YES;
//    //类似那个箭头 跳转到第二个界面
//    [self presentViewController:nc animated:YES completion:nil];
//    _btn.enabled=YES;
}
@end
