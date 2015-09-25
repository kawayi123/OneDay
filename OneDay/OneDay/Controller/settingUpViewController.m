//
//  settingUpViewController.m
//  OneDay
//
//  Created by 段志鑫 on 15/9/21.
//  Copyright (c) 2015年 Mr.ZhixinDuan. All rights reserved.
//

#import "settingUpViewController.h"
#import "myAccountViewController.h"

@interface settingUpViewController ()

@end

@implementation settingUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self btns];

}
-(void)btns
{
    PFUser *currentUser=[PFUser currentUser];
    if (currentUser) {
        NSString *username = currentUser.username;
        PFUser *currentUser=[PFUser currentUser];
        currentUser[@"username"] = username;
        [_myAccountBtn setTitle:currentUser.username forState:UIControlStateNormal];
        _myAccountBtn.enabled = YES;
    }else{
        [_myAccountBtn setTitle:@"请先登陆账号" forState:UIControlStateNormal];
        _myAccountBtn.enabled = NO;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([[[storageMgr singletonStorageMgr] objectForKey:@"logout"] integerValue] == 1) {
        [[storageMgr singletonStorageMgr] removeObjectForKey:@"logout"];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backAction:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)myAccount:(UIButton *)sender {
    
    PFUser *currentUser=[PFUser currentUser];
    if (currentUser) {
        
        myAccountViewController *account = [self.storyboard instantiateViewControllerWithIdentifier:@"account"];
        //初始化导航控制器
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:account];
        //动画效果
        nc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        //导航条隐藏掉
        nc.navigationBarHidden = NO;
        //类似那个箭头 跳转到第二个界面
        [self presentViewController:nc animated:YES completion:nil];
        
        
    }else{
        [Utilities popUpAlertViewWithMsg:@"账号信息需要登陆后才能查看呦~" andTitle:@"贴心小提示"];
    }
}
@end
