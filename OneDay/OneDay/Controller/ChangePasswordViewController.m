//
//  ChangePasswordViewController.m
//  OneDay
//
//  Created by 段志鑫 on 15/9/28.
//  Copyright (c) 2015年 Mr.ZhixinDuan. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

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
- (IBAction)changeAction:(UIBarButtonItem *)sender{
    
    NSLog(@"%@",[Utilities getUserDefaults:@"password"]);
    NSLog(@"%@,%@,%@",_oldPassWord.text,_passWord.text,_aginPassWord.text);
    if ([_oldPassWord.text isEqualToString:[Utilities getUserDefaults:@"password"]]) {
        if ([_passWord.text isEqualToString:_aginPassWord.text]) {
            PFUser *currUser=[PFUser currentUser];
            currUser.password=_passWord.text;
            UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
            
            
            [currUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [aiv stopAnimating];
                if (succeeded) {
                    [Utilities setUserDefaults:@"password" content:_passWord.text];
                    [Utilities popUpAlertViewWithMsg:@"成功修改！请重新登录！" andTitle:nil];
                    
                    [PFUser logOut];//退出Parse
                    [self dismissViewControllerAnimated:YES completion:nil];
                    [aiv startAnimating];
                    //重新登录
                    [PFUser logInWithUsernameInBackground:currUser.username password:_passWord.text block:^(PFUser *user, NSError *error) {
                        
                        [aiv stopAnimating];
                        if (user) {
                            [self dismissViewControllerAnimated:YES completion:nil];
                        } else if (error.code == 101) {
                            [Utilities popUpAlertViewWithMsg:@"用户名或密码错误" andTitle:nil];
                        } else if (error.code == 100) {
                            [Utilities popUpAlertViewWithMsg:@"网络不给力，请稍后再试" andTitle:nil];
                        }else{
                            [Utilities popUpAlertViewWithMsg:nil andTitle:nil];
                        }
                    }];
                    
                    
                    //[self.navigationController popViewControllerAnimated:YES];
                } else {
                    [Utilities popUpAlertViewWithMsg:nil andTitle:nil];
                }
            }];
        }else{
            [Utilities popUpAlertViewWithMsg:@"俩次密码不一致，请重新输入" andTitle:nil];
        }
        
    }else{
        [Utilities popUpAlertViewWithMsg:@"与原密码不同，请重新输入" andTitle:nil];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
@end
