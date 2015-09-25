//
//  pickDateViewController.m
//  OneDay
//
//  Created by 段志鑫 on 15/9/21.
//  Copyright (c) 2015年 Mr.ZhixinDuan. All rights reserved.
//

#import "pickDateViewController.h"

@interface pickDateViewController ()
- (IBAction)saveAction:(UIBarButtonItem *)sender;

@end

@implementation pickDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)beginAction:(UIButton *)sender {
    
    _pickAlterView.hidden = NO;
    
}

- (IBAction)remindAction:(UIButton *)sender {
    
    _pickAlterView.hidden = NO;
}

- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    
    _pickAlterView.hidden = YES;
    
}

- (IBAction)confirmAction:(UIBarButtonItem *)sender {
    
    _pickAlterView.hidden = YES;
    NSDate *select = [_Datepicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    NSString *dateAndTime =  [dateFormatter stringFromDate:select];
    _beginBtn.titleLabel.text = dateAndTime;
}
- (IBAction)saveAction:(UIBarButtonItem *)sender {
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags =  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    hour = [dateComponent hour];
    minute = [dateComponent minute];
    second = [dateComponent second];
    
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"%ld时%ld分%ld秒", hour,minute,second);

}
@end
