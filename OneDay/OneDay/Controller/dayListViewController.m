//
//  dayListViewController.m
//  OneDay
//
//  Created by 段志鑫 on 15/9/21.
//  Copyright (c) 2015年 Mr.ZhixinDuan. All rights reserved.
//

#import "dayListViewController.h"
#import "weekDaysViewController.h"
#import "logInViewController.h"
#import "introduceViewController.h"
#import "TableViewCell.h"
@interface dayListViewController ()

@end

@implementation dayListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _objectsForShow = [NSMutableArray new];
    [self.segmented addTarget:self action:@selector(segmentAction) forControlEvents:UIControlEventValueChanged];
    [self uiConfiguration];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)po{
    introduceViewController *sp = [Utilities getStoryboardInstanceByIdentity:@"splash"];
    [self presentViewController:sp animated:YES completion:nil];
}
- (void)segmentAction
{
    NSInteger index = self.segmented.selectedSegmentIndex;
    PFUser *curr=[PFUser currentUser];
    if (curr) {
        switch (index) {
            case 0: {
                [self requestDataForMe];
            }
                break;
            case 1: {
                [self requestDataForAnother];
            }
                break;
            default:
                break;
        }
        [self.tableView reloadData];
    }else{
        [Utilities popUpAlertViewWithMsg:@"请先登录后在使用！" andTitle:nil];
    }
    
}
- (void)requestDataForAnother{
    PFQuery *query = [PFQuery queryWithClassName:@"Schedule"];
    [query selectKeys:@[@"Schedulename",@"StartTime",@"Publisher"]];
    [query includeKey:@"Publisher"];
    
    PFUser *currentUser = [PFUser currentUser];
    PFQuery *friends = [PFQuery queryWithClassName:@"friends"];
    [friends whereKey:@"owner" equalTo:currentUser];
    [friends whereKey:@"State" equalTo:@YES];
    [friends includeKey:@"friendUser"];
    
    //查询Schedule表中Publisher值与friends表中friendUser值相同的项目
    [query whereKey:@"Publisher" matchesKey:@"friendUser" inQuery:friends];
    [query findObjectsInBackgroundWithBlock:^(NSArray *returnedObjects, NSError *error) {
        if (!error) {
            _objectsForShow = [NSMutableArray arrayWithArray:returnedObjects];
            [_tableView reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}
- (void)requestDataForMe{
    
    PFUser *currentUser = [PFUser currentUser];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Publisher == %@", currentUser];

    PFQuery *query = [PFQuery queryWithClassName:@"Schedule" predicate:predicate];
    [query selectKeys:@[@"Schedulename",@"StartTime",@"Publisher"]];
    [query includeKey:@"Publisher"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *returnedObjects, NSError *error) {
        if (!error) {
            _objectsForShow = returnedObjects;
            [_tableView reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(void)uiConfiguration
{
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];//在可以滚动视图中添加RefreshControl下拉即可刷新视图
    NSString *title = [NSString stringWithFormat:@"下拉即可刷新"];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentCenter];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    NSDictionary *attrsDictionary = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody],NSParagraphStyleAttributeName:style,NSForegroundColorAttributeName:[UIColor orangeColor]};
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
    refreshControl.attributedTitle = attributedTitle;
    refreshControl.tintColor = [UIColor orangeColor];
    refreshControl.backgroundColor = [UIColor clearColor];
    [refreshControl addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];//当变化时刷新列表数据
    [_tableView addSubview:refreshControl];
    _tableView.tableFooterView=[[UIView alloc]init];
}
- (void)refreshData:(UIRefreshControl *)rc {
    [self segmentAction];
    [_tableView reloadData];//重新加载数据
    [self performSelector:@selector(endRefreshing:) withObject:rc afterDelay:1.f];//让方法延迟1秒,在执行endRefreshing方法
}
- (void)endRefreshing:(UIRefreshControl *)rc {
    [rc endRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _objectsForShow.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *object = [_objectsForShow objectAtIndex:indexPath.row];

    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    PFUser *currentuser=[PFUser currentUser];
    PFUser *activity = object[@"Publisher"];
    if (currentuser) {
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];//设定时间格式
        NSString *dateString = [dateFormat stringFromDate:object[@"StartTime"]]; //求出当天的时间字符串，当更改时间格式时，时间字符串也能随之改变
        NSString *act = [NSString stringWithFormat:@"发布人:%@",activity[@"NickName"]];
        cell.calendarName.text =object[@"Schedulename"];
        cell.beginTime.text = dateString;
        cell.issuer.text = act;
    }
  return cell;
}

//下面两段代码二级页面不在能进行左滑操作
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"enablePanGes" object:self];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"disablePanGes" object:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    if ([segue.identifier isEqualToString:@"show"]) {
        PFObject *object = [_objectsForShow objectAtIndex:[_tableView indexPathForSelectedRow].row];
        weekDaysViewController *miVC = segue.destinationViewController;
        miVC.item=object;
        miVC.hidesBottomBarWhenPushed = YES;
    }
}
- (IBAction)menuAction:(UIBarButtonItem *)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSwitch" object:self];
}
-(void)dealloc
{
    
}
@end
