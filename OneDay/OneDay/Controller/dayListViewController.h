//
//  dayListViewController.h
//  OneDay
//
//  Created by 段志鑫 on 15/9/21.
//  Copyright (c) 2015年 Mr.ZhixinDuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface dayListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)menuAction:(UIBarButtonItem *)sender;
@property (strong, nonatomic)NSArray *objectsForShow;
@property (strong, nonatomic) PFObject *item;
@end
