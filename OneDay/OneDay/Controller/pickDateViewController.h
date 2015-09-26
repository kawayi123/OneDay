//
//  pickDateViewController.h
//  OneDay
//
//  Created by 段志鑫 on 15/9/21.
//  Copyright (c) 2015年 Mr.ZhixinDuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pickDateViewController : UIViewController
{
    NSInteger hour;
    NSInteger minute;
    NSInteger second;
}
@property (weak, nonatomic) IBOutlet UIButton *remindBtn;
@property (weak, nonatomic) IBOutlet UIButton *schTime;
@property (weak, nonatomic) IBOutlet UITextField *schName;
@property (weak, nonatomic) IBOutlet UITextField *activityTime;
@property (weak, nonatomic) IBOutlet UITextField *placeTF;
@property (weak, nonatomic) IBOutlet UITextView *contentTF;

@property (weak, nonatomic) IBOutlet UIView *pickAlterView;
@property (weak, nonatomic) IBOutlet UIDatePicker *Datepicker;
@property (weak, nonatomic) IBOutlet UIToolbar *remindToolBar;
@property (weak, nonatomic) IBOutlet UIToolbar *beginToolBar;




- (IBAction)beginAction:(UIButton *)sender;
- (IBAction)remindAction:(UIButton *)sender;

- (IBAction)cancelAction:(UIBarButtonItem *)sender;

- (IBAction)confirmAction:(UIBarButtonItem *)sender;

- (IBAction)remCancel:(UIBarButtonItem *)sender;
- (IBAction)remConfirm:(UIBarButtonItem *)sender;
@property (strong, nonatomic)NSArray *objectsForShow;

@end
