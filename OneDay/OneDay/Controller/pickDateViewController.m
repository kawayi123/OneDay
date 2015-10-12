//
//  pickDateViewController.m
//  OneDay
//
//  Created by 段志鑫 on 15/9/21.
//  Copyright (c) 2015年 Mr.ZhixinDuan. All rights reserved.
//

#import "pickDateViewController.h"
#import "dayListViewController.h"
@interface pickDateViewController ()
- (IBAction)saveAction:(UIBarButtonItem *)sender;
@end
@implementation pickDateViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadInButtonTime];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    [_contentTF resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
- (void)loadInButtonTime{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    [_schTime setTitle:locationString forState:UIControlStateNormal];
    [_remindBtn setTitle:locationString forState:UIControlStateNormal];
    NSLog(@"locationString:%@",locationString);
}
- (IBAction)beginAction:(UIButton *)sender {
    _pickAlterView.hidden = NO;
    _beginToolBar.hidden = NO;
    _remindToolBar.hidden = YES;
}
- (IBAction)remindAction:(UIButton *)sender {
    _pickAlterView.hidden = NO;
    _beginToolBar.hidden = YES;
    _remindToolBar.hidden = NO;
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
    _schTime.titleLabel.text = dateAndTime;
}
- (IBAction)remCancel:(UIBarButtonItem *)sender {
    _pickAlterView.hidden = YES;
}
- (IBAction)remConfirm:(UIBarButtonItem *)sender {
    _pickAlterView.hidden = YES;
    NSDate *select = [_Datepicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    NSString *dateAndTime =  [dateFormatter stringFromDate:select];
    _remindBtn.titleLabel.text = dateAndTime;
}
- (IBAction)saveAction:(UIBarButtonItem *)sender {
    _savebtn.enabled = NO;
    PFUser *currentUser = [PFUser currentUser];//获取当前用户的实例
    if (currentUser) {
        NSString *schname=_schName.text;//获取日程名称
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
        NSDate *select =  [dateFormatter dateFromString:_schTime.titleLabel.text];//获取开始日程时间
        NSString *avtivityoften=_activityTime.text;//获取活动时长
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy年MM月dd日 HH:mm"];
        NSDate *remind =  [df dateFromString:_remindBtn.titleLabel.text];//获取提醒时间
//        NSString *s =  _schTime.titleLabel.text;
//        NSString *r =  _remindBtn.titleLabel.text;
//        NSLog(@"%@,%@",s,r);
        NSString *place=_placeTF.text;//获取地点
        NSString *content=_contentTF.text;//获取日程内容
        if ([avtivityoften isEqualToString:@""] || [place isEqualToString:@""]|| [content isEqualToString:@""]) {
            [Utilities popUpAlertViewWithMsg:@"请填写所有信息" andTitle:nil];
            _savebtn.enabled = YES;
            return;
        }
        PFObject *item = [PFObject objectWithClassName:@"Schedule"];
        item[@"Publisher"] = currentUser;
        item[@"Schedulename"]=schname;
        item[@"StartTime"] = select;
        item[@"activityTime"] = avtivityoften;
        item[@"ReminderTime"] =remind;
        item[@"Place"] =place;
        item[@"Event"] =content;
        item[@"StartDate"] = [select dateAtStartOfDay];
        UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
        [item saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [aiv stopAnimating];
            if (succeeded) {
                [self.navigationController popViewControllerAnimated:YES];//上传成功后返回上页
            } else {
                
                [Utilities popUpAlertViewWithMsg:nil andTitle:nil];
            }
            
        }];
    }else{
        [Utilities popUpAlertViewWithMsg:@"请先登录后在使用！" andTitle:nil];
    }
}

 #pragma mark - Navigation
 
//  In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     if ([segue.identifier isEqualToString:@"in"]) {
             PFObject *object = [PFObject objectWithClassName:@"Schedule"];
             dayListViewController *miVC = segue.destinationViewController;
             miVC.item=object;
             miVC.hidesBottomBarWhenPushed = YES;
     }
 }

@end
