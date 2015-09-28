//
//  ChangePasswordViewController.h
//  OneDay
//
//  Created by 段志鑫 on 15/9/28.
//  Copyright (c) 2015年 Mr.ZhixinDuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *oldPassWord;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UITextField *aginPassWord;

- (IBAction)changeAction:(UIBarButtonItem *)sender;

@end
