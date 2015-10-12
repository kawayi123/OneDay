//
//  registerViewController.m
//  OneDay
//
//  Created by 段志鑫 on 15/9/21.
//  Copyright (c) 2015年 Mr.ZhixinDuan. All rights reserved.
//

#import "registerViewController.h"

@interface registerViewController ()
- (IBAction)signupAction:(UIButton *)sender forEvent:(UIEvent *)event;
@end

@implementation registerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//注册
- (IBAction)signupAction:(UIButton *)sender forEvent:(UIEvent *)event {
    NSString *username = _usernameTF.text;
    NSString *password = _EnterpwdAction.text;
    NSString *email = _email.text;
    NSString *nickName=_nickname.text;
    NSString *phoneNUmber=_phonenum.text;
    NSString *Personalsignature=_Personalitysignature.text;
    NSString *confirmPwd = _confrimpwd.text;
    if ([username isEqualToString:@""]||[email isEqualToString:@""]||[password isEqualToString:@""]||[confirmPwd isEqualToString:@""]||[nickName isEqualToString:@""]||[phoneNUmber isEqualToString:@""]
        ) {
        [Utilities popUpAlertViewWithMsg:@"请填写所有信息" andTitle:nil];
        return;
    }if (![password isEqualToString:confirmPwd]) {
        [Utilities popUpAlertViewWithMsg:@"请确认密码必须与原密码保持一致" andTitle:nil];
        return;
    }
    PFUser *user = [PFUser user];
    user.username = username;
    user.password = password;
    user.email = email;
    user[@"NickName"] = nickName;
    user[@"PhoneNum"] = phoneNUmber;
    user[@"PeoSignature"] = Personalsignature;

    //设置ActivityIndicatorView保护膜
    UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    aiv.frame = self.view.bounds;
    [self.view addSubview:aiv];
    [aiv startAnimating];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         [aiv stopAnimating];
         if (!error) {
             [[storageMgr singletonStorageMgr] addKeyAndValue:@"signup" And:@1];//在单例化全局变量里插入变量
             [self.navigationController popViewControllerAnimated:YES];//注册成功后跳转到登陆界面
         } else if (error.code == 202) {
             [Utilities popUpAlertViewWithMsg:@"该用户名已被使用，请尝试其它名称" andTitle:nil];
         } else if (error.code == 203) {
             [Utilities popUpAlertViewWithMsg:@"该电子邮箱已被使用，请尝试其它名称" andTitle:nil];
         } else if (error.code == 100) {
             [Utilities popUpAlertViewWithMsg:@"网络不给力，请稍后再试" andTitle:nil];
         }else if (error.code == 125) {
             [Utilities popUpAlertViewWithMsg:@"该邮箱地址为非法地址" andTitle:nil];
         }
         else
         {
             [Utilities popUpAlertViewWithMsg:nil andTitle:nil];
         }
     }];
}

@end
