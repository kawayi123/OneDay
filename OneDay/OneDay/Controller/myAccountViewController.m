//
//  myAccountViewController.m
//  OneDay
//
//  Created by 段志鑫 on 15/9/21.
//  Copyright (c) 2015年 Mr.ZhixinDuan. All rights reserved.
//

#import "myAccountViewController.h"

@interface myAccountViewController ()
- (IBAction)logoutAction:(UIButton *)sender forEvent:(UIEvent *)event;

@end

@implementation myAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)logoutAction:(UIButton *)sender forEvent:(UIEvent *)event {
    [PFUser logOut];//退出parse
//    dayListViewController *day = [self.storyboard instantiateViewControllerWithIdentifier:@"day"];
//    //初始化导航控制器
//    navigationController *nc = [[navigationController alloc]initWithRootViewController:day];
//    //动画效果
//    nc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    //导航条隐藏掉
//    nc.navigationBarHidden = YES;
//    //类似那个箭头 跳转到第二个界面
    //[self presentViewController:nc animated:YES completion:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (IBAction)backAction:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
