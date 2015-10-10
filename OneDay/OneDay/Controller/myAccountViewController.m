//
//  myAccountViewController.m
//  OneDay
//
//  Created by 段志鑫 on 15/9/21.
//  Copyright (c) 2015年 Mr.ZhixinDuan. All rights reserved.
//

#import "myAccountViewController.h"
#import "dayListViewController.h"

@interface myAccountViewController ()
- (IBAction)changphonenum:(UIButton *)sender forEvent:(UIEvent *)event;

- (IBAction)logoutAction:(UIButton *)sender forEvent:(UIEvent *)event;

@end

@implementation myAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadDataBegin
{       NSLog(@"IN");
    PFUser *currentUser=[PFUser currentUser];
    PFFile *file=currentUser[@"HeadImg"];
    [file getDataInBackgroundWithBlock:^(NSData *photoData, NSError *error)
     {
         if (!error) {
             UIImage *image=[UIImage imageWithData:photoData];
             dispatch_async(dispatch_get_main_queue(), ^{
                 //把图片放到imageview上
                 _image.image=image;
             });
         }
     }];
    _username.text=[NSString stringWithFormat:@"用户名：%@", currentUser[@"username"]];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)changphonenum:(UIButton *)sender forEvent:(UIEvent *)event {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"请输入你的新的手机号"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    alert.alertViewStyle= UIAlertViewStylePlainTextInput;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        if ([textField.text isEqualToString:@""]) {
            [Utilities popUpAlertViewWithMsg:@"请输入你的新的手机号" andTitle:nil];
            return;//终止该方法操作
        }
        
        PFUser *user=[PFUser currentUser];
        user[@"PhoneNum"] = textField.text;
        
        [user saveInBackgroundWithBlock:^(BOOL succeeded,NSError *error) {
            if (succeeded) {
                [Utilities popUpAlertViewWithMsg:@"你已成功修改!" andTitle:nil];
            }else
            {
                [Utilities popUpAlertViewWithMsg:nil andTitle:nil];
            }
        }];
    }
}

- (IBAction)logoutAction:(UIButton *)sender forEvent:(UIEvent *)event {
    [PFUser logOut];//退出parse
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (IBAction)backAction:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
