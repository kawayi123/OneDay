//
//  registerViewController.h
//  OneDay
//
//  Created by 段志鑫 on 15/9/21.
//  Copyright (c) 2015年 Mr.ZhixinDuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface registerViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneNUmberTF;
@property (weak, nonatomic) IBOutlet UITextField *PersonalsignatureTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdTF;

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UITextField *passWordAging;
@property (weak, nonatomic) IBOutlet UITextField *EmailWord;
@property (weak, nonatomic) IBOutlet UITextField *perName;
@property (weak, nonatomic) IBOutlet UITextField *telPhone;
@property (weak, nonatomic) IBOutlet UITextField *DIYsignature;

@end
