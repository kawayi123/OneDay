//
//  personalDataViewController.h
//  OneDay
//
//  Created by 段志鑫 on 15/9/21.
//  Copyright (c) 2015年 Mr.ZhixinDuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface personalDataViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UITextField *nickName;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextView *peoSignTF;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btn;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;
- (IBAction)backAction:(UIBarButtonItem *)sender;

@end
