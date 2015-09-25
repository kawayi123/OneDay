//
//  leftViewController.m
//  OneDay
//
//  Created by 段志鑫 on 15/9/21.
//  Copyright (c) 2015年 Mr.ZhixinDuan. All rights reserved.
//

#import "leftViewController.h"
#import "logInViewController.h"
#import "personalDataViewController.h"
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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    PFUser *currentUser=[PFUser currentUser];
    if (!currentUser) {
        [self pToLogin];
        _btn.enabled=YES;
    }else{
        [self loadingData];
        _btn.enabled=NO;
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

- (void)loadingData{
    
    PFUser *User = [PFUser currentUser];
    _nickName.text = User[@"NickName"];
    _IndividualitySignature.text = User[@"PeoSignature"];
    
    [User[@"HeadImg"] getDataInBackgroundWithBlock:^(NSData *photoData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:photoData];
            dispatch_async(dispatch_get_main_queue(), ^{
                _headImg.image = image;
            });
        }
    }];
}
- (void)pToLogin{
    
    _nickName.text = @"请登录";
    _IndividualitySignature.text = @"";
    _headImg.image = [UIImage imageNamed:@"dragon"];
}

- (IBAction)perAction:(UIButton *)sender {
    
    PFUser *currentUser=[PFUser currentUser];
    if (currentUser) {
        
        personalDataViewController *person = [self.storyboard instantiateViewControllerWithIdentifier:@"person"];
        //初始化导航控制器
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:person];
        //动画效果
        nc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        //导航条隐藏掉
        nc.navigationBarHidden = NO;
        //类似那个箭头 跳转到第二个界面
        [self presentViewController:nc animated:YES completion:nil];
        
    }else{
        [Utilities popUpAlertViewWithMsg:@"个人信息需要登陆后才能查看呦~" andTitle:@"贴心小提示"];
    }
}
@end