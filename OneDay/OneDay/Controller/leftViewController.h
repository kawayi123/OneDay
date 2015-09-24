//
//  leftViewController.h
//  OneDay
//
//  Created by 段志鑫 on 15/9/21.
//  Copyright (c) 2015年 Mr.ZhixinDuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface leftViewController : UIViewController
@property(weak,nonatomic)IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIButton *perBtn;

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *IndividualitySignature;
- (IBAction)perAction:(UIButton *)sender;

@end
