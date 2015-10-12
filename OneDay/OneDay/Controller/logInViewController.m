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
    if (![[Utilities getUserDefaults:@"username"] isKindOfClass:[NSNull class]]) {
        _usernameTF.text = [Utilities getUserDefaults:@"username"];
    } //记住用户名
    [self setIsRemember];
    
}

- (void)setIsRemember {
    if (![[Utilities getUserDefaults:@"rp"] isKindOfClass:[NSNull class]]) {
        if ([[Utilities getUserDefaults:@"rp"] boolValue] == YES) {
            [_Rememberpwd setOn:YES animated:YES];
            if (![[Utilities getUserDefaults:@"password"] isKindOfClass:[NSNull class]]) {
                _passwordTF.text = [Utilities getUserDefaults:@"password"];
            }
        } else {
            [_Rememberpwd setOn:NO animated:YES];
            _passwordTF.text = @"";
        }
    } else {
        _passwordTF.text = @"";
    }
}
- (IBAction)rememberPwdAction:(UISwitch *)sender {
    
    if (_Rememberpwd.isOn) {
        [Utilities setUserDefaults:@"rp" content:@YES];
    } else {
        [Utilities setUserDefaults:@"rp" content:@NO];
    }
    [self setIsRemember];
}

- (IBAction)displayPwdAction:(UISwitch *)sender {
    
    if (_displaypwd.isOn) {
        if (_displaypwd) {
            
            _passwordTF.secureTextEntry = NO;
            
        }
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

//重设密码
- (IBAction)forgetpwd:(UIButton *)sender forEvent:(UIEvent *)event {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"请输入你要密码重置的邮箱"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    alert.alertViewStyle= UIAlertViewStylePlainTextInput;
    [alert show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        if ([textField.text isEqualToString:@""]) {
            [Utilities popUpAlertViewWithMsg:@"请您输入邮件地址" andTitle:nil];
            return;//终止该方法操作
        } else {
            NSString *email=textField.text;
            NSString *emailCheck = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
            //  转为正则表达式
            NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailCheck];
            
            if (![emailTest evaluateWithObject:email]) {
                [Utilities popUpAlertViewWithMsg:@"请输入合法的邮箱地址" andTitle:nil];
                return;//终止该方法操作
            } else {
                [PFUser requestPasswordResetForEmailInBackground:email];
            }
        }
        
    }
}
//登陆
- (IBAction)signupAction:(UIButton *)sender forEvent:(UIEvent *)event {
    
    NSString *username = _usernameTF.text;
    NSString *password = _passwordTF.text;
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