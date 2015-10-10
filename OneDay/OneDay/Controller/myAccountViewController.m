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

- (IBAction)logoutAction:(UIButton *)sender forEvent:(UIEvent *)event {
    [PFUser logOut];//退出parse
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (IBAction)backAction:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
