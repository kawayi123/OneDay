//
//  logInViewController.m
//  OneDay
//
//  Created by 段志鑫 on 15/9/21.
//  Copyright (c) 2015年 Mr.ZhixinDuan. All rights reserved.
//

#import "logInViewController.h"
#import "leftViewController.h"
#import "TabBarController.h"

@interface logInViewController ()

- (IBAction)forgetpwd:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)signupAction:(UIButton *)sender forEvent:(UIEvent *)event;

@end

@implementation logInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (![[Utilities getUserDefaults:@"userName"] isKindOfClass:[NSNull class]]) {
        _usernameTF.text = [Utilities getUserDefaults:@"userName"];
    } //记住用户名
    
}

- (IBAction)rememberPwdAction:(UISwitch *)sender {
    
    if (_Rememberpwd) {
        if (![[Utilities getUserDefaults:@"passWord"] isKindOfClass:[NSNull class]]) {
            _passwordTF.text = [Utilities getUserDefaults:@"passWord"];
        }
    }
    else {
        
        _passwordTF.text = @"";
        
    }
}

- (IBAction)displayPwdAction:(UISwitch *)sender {
    
    if (_displaypwd) {
        
        _passwordTF.secureTextEntry = NO;
        
    }
    else {
        _passwordTF.secureTextEntry = YES;
    }

}

- (IBAction)backAction:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
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


- (IBAction)forgetpwd:(UIButton *)sender forEvent:(UIEvent *)event {
    
    [PFUser requestPasswordResetForEmailInBackground:@"932220954@qq.com"];
    [Utilities popUpAlertViewWithMsg:@"密码重置信息已发送至您的邮箱，请修改后在登陆！" andTitle:nil];
    
}
- (IBAction)signupAction:(UIButton *)sender forEvent:(UIEvent *)event {
    
    NSString *username = _usernameTF.text;
    NSString *password = _passwordTF.text;
    //NSString *email;
    
    if ([username isEqualToString:@""] || [password isEqualToString:@""]) {
        [Utilities popUpAlertViewWithMsg:@"请输入您的用户名或密码！" andTitle:nil];
        return;
    }
    
    UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    aiv.frame = self.view.bounds;
    [self.view addSubview:aiv];
    [aiv startAnimating];
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        [aiv stopAnimating];
        if (user) {
            [Utilities setUserDefaults:@"username" content:username];
            [Utilities setUserDefaults:@"password" content:password];
            //[self popUpHomePage];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else if (error.code == 101) {
            [Utilities popUpAlertViewWithMsg:@"用户名或密码错误" andTitle:nil];
        } else if (error.code == 100) {
            [Utilities popUpAlertViewWithMsg:@"网络不给力，请稍后再试" andTitle:nil];
        }else
        {
            [Utilities popUpAlertViewWithMsg:nil andTitle:nil];
        }
    }];
    
}

@end