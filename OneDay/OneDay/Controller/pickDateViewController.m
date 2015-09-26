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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        NSString *place=_placeTF.text;//获取地点
        NSString *content=_contentTF.text;//获取日程内容
        if ([avtivityoften isEqualToString:@""] || [place isEqualToString:@""]|| [content isEqualToString:@""]) {
            [Utilities popUpAlertViewWithMsg:@"请填写所有信息" andTitle:nil];
            return;
        }
        PFObject *item = [PFObject objectWithClassName:@"Schedule"];
        item[@"Publisher"] = currentUser;
        item[@"Schedulename"]=schname;
        item[@"StartTime"] = select;
        item[@"activityTime"] = avtivityoften;
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
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请你登录在添加日程！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        [alert show];
    }
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
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
