//
//  pickDateViewController.h
//  OneDay
//
//  Created by 段志鑫 on 15/9/21.
//  Copyright (c) 2015年 Mr.ZhixinDuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pickDateViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *pickAlterView;
@property (weak, nonatomic) IBOutlet UIDatePicker *Datepicker;
@property (weak, nonatomic) IBOutlet UIButton *beginBtn;
@property (weak, nonatomic) IBOutlet UIButton *remindBtn;


- (IBAction)beginAction:(UIButton *)sender;
- (IBAction)remindAction:(UIButton *)sender;

- (IBAction)cancelAction:(UIBarButtonItem *)sender;

- (IBAction)confirmAction:(UIBarButtonItem *)sender;

@end
