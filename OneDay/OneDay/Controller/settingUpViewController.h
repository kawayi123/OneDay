//
//  settingUpViewController.h
//  OneDay
//
//  Created by 段志鑫 on 15/9/21.
//  Copyright (c) 2015年 Mr.ZhixinDuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface settingUpViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *myAccountBtn;

- (IBAction)backAction:(UIBarButtonItem *)sender;
- (IBAction)myAccount:(UIButton *)sender;

@end
