//
//  logInViewController.m
//  OneDay
//
//  Created by 段志鑫 on 15/9/21.
//  Copyright (c) 2015年 Mr.ZhixinDuan. All rights reserved.
//

#import "logInViewController.h"

@interface logInViewController ()

- (IBAction)forgetpwd:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)signupAction:(UIButton *)sender forEvent:(UIEvent *)event;


@end

@implementation logInViewController

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


- (IBAction)forgetpwd:(UIButton *)sender forEvent:(UIEvent *)event {
}

- (IBAction)signupAction:(UIButton *)sender forEvent:(UIEvent *)event {
    
}
@end
