//
//  myAccountViewController.h
//  OneDay
//
//  Created by 段志鑫 on 15/9/21.
//  Copyright (c) 2015年 Mr.ZhixinDuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myAccountViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *username;

- (IBAction)backAction:(UIBarButtonItem *)sender;

@end
