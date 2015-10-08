//
//  weekDaysViewController.h
//  OneDay
//
//  Created by 段志鑫 on 15/9/21.
//  Copyright (c) 2015年 Mr.ZhixinDuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface weekDaysViewController : UIViewController<JTCalendarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;

@property (strong, nonatomic) JTCalendarManager *calendarManager;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarContentViewHeight;
@property (strong, nonatomic) PFObject *item;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)menuAction:(UIBarButtonItem *)sender;
@property(strong,nonatomic)NSMutableArray *rawArray;
@property(strong,nonatomic)NSArray *objectsForShow;
@end
