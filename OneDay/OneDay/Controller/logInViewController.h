//
//  logInViewController.h
//  OneDay
//
//  Created by 段志鑫 on 15/9/21.
//  Copyright (c) 2015年 Mr.ZhixinDuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface logInViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UISwitch *displaypwd;
@property (weak, nonatomic) IBOutlet UISwitch *Rememberpwd;

- (IBAction)rememberPwdAction:(UISwitch *)sender;
- (IBAction)displayPwdAction:(UISwitch *)sender;

- (IBAction)backAction:(UIBarButtonItem *)sender;

@end
