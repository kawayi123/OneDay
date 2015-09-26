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
    /*NSDate *select = [_datePicker date];
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
     [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
     NSString *TM=_hoursTF.text;
     NSString *PM=_peopleTF.text;
     NSString *dateAndTime =  [dateFormatter stringFromDate:select];
     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"详情"message:[NSString stringWithFormat:@"活动名称:%@ 活动时间:%@ 活动时长:%@小时 活动人数:%@",self.item[@"Name"],dateAndTime,TM,PM ]delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",  nil];*/
//    CGRect frame = CGRectMake(225, self.view.frame.size.height, self.view.frame.size.width, 125);
//    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:frame];
//    datePicker = [[UIDatePicker alloc] init];
//    datePicker.datePickerMode = UIDatePickerModeDate;
//    
//    [datePicker setDate:[NSDate date]];
//    
//    UIAlertView *alert;
//    alert = [[UIAlertView alloc] initWithTitle:@"Enter the Code Date" message:@"Sample message" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Update", nil];
//    alert.delegate = self;
//    [alert addSubview:datePicker];
//    [alert show];
}
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex==1) {
//    }
//}
- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    
    _pickAlterView.hidden = YES;
    
}

- (IBAction)confirmAction:(UIBarButtonItem *)sender {
    
    _pickAlterView.hidden = YES;
    NSDate *select = [_Datepicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    NSString *dateAndTime =  [dateFormatter stringFromDate:select];
    _schTime.titleLabel.text = dateAndTime;
}
- (IBAction)saveAction:(UIBarButtonItem *)sender {
     NSString *schname=_schName.text;
    NSString *schtime=_schTime.titleLabel.text;
    NSString *avtivityoften=_activityTime.text;
    NSNumber * nums = @([avtivityoften integerValue]);
    NSString *remind=_remindBtn.titleLabel.text;
    NSString *place=_placeTF.text;
    NSString *content=_contentTF.text;
    
    PFObject *item = [PFObject objectWithClassName:@"Schedule"];
    PFUser *currentUser = [PFUser currentUser];//获取当前用户的实例
    item[@"Publisher"] = currentUser;
    item[@"Schedulename"]=schname;
    item[@"StartTime"] = schtime;
    item[@"activityTime"] = nums;
    item[@"ReminderTime"]=remind;
    item[@"Place"]=place;
    item[@"Event"] =content;
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    [item saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [aiv stopAnimating];
        if (succeeded) {
            [self.navigationController popViewControllerAnimated:YES];//上传成功后返回上页
        } else {
            
            [Utilities popUpAlertViewWithMsg:nil andTitle:nil];
        }
        
    }];
}
@end
