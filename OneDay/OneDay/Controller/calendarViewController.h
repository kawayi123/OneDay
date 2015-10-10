//
//  calendarViewController.h
//  OneDay
//
//  Created by 段志鑫 on 15/9/21.
//  Copyright (c) 2015年 Mr.ZhixinDuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCTagListView.h"

@interface calendarViewController : UIViewController<JTCalendarDelegate>
@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;
@property (strong, nonatomic) JTCalendarManager *calendarManager;
@property (nonatomic, weak) IBOutlet JCTagListView *tagListView;
@property (weak, nonatomic) IBOutlet UIView *tagView;
@property (strong, nonatomic) NSArray *objectsForShow;
@property (strong, nonatomic) NSMutableArray *targetArray;
@property (strong, nonatomic) NSMutableArray *rawArray;
@property (strong, nonatomic) PFObject *item;
@property (strong, nonatomic) NSString *date;
- (IBAction)ToView:(UIButton *)sender;
- (IBAction)deleteTagCloud:(UIButton *)sender;
- (IBAction)cancel:(UIButton *)sender;

- (IBAction)menuAction:(UIBarButtonItem *)sender;

@end
