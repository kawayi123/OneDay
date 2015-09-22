//
//  logInViewController.h
//  OneDay
//
//  Created by 段志鑫 on 15/9/21.
//  Copyright (c) 2015年 Mr.ZhixinDuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface logInViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *loginTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UISwitch *displayPwd;
@property (weak, nonatomic) IBOutlet UISwitch *rememberPwd;

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
- (IBAction)seePassWord:(UISwitch *)sender;
- (IBAction)remember:(UISwitch *)sender;
- (IBAction)logInAction:(UIButton *)sender;

@end
