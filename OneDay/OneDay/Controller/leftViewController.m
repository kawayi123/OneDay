//
//  leftViewController.m
//  OneDay
//
//  Created by 段志鑫 on 15/9/21.
//  Copyright (c) 2015年 Mr.ZhixinDuan. All rights reserved.
//

#import "leftViewController.h"
#import "logInViewController.h"
#import "personalDataViewController.h"
#import "dayListViewController.h"
@interface leftViewController ()
- (IBAction)loginAction:(UIButton *)sender forEvent:(UIEvent *)event;
@end
@implementation leftViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _objectsForShow=nil;
    _objectsForShow=[NSArray new];
    _btn.hidden = NO;
    _perBtn.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    PFUser *currentUser=[PFUser currentUser];
    if (!currentUser) {
        [self pToLogin];
        _objectsForShow = nil;
        _objectsForShow = [NSMutableArray new];
        [_tableview reloadData];
        _btn.hidden = NO;
        _perBtn.hidden = YES;
    }else{
        [self loadingData];
        [self requestData];
        _btn.hidden = YES;
        _perBtn.hidden = NO;
    }
}

- (void)requestData
{
    PFUser *currentUser = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"friends"];
    [query whereKey:@"friendUser" equalTo:currentUser];
    [query whereKey:@"State" equalTo:@NO];
    [query includeKey:@"owner"];
    [query selectKeys:@[@"owner"]];
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    [query findObjectsInBackgroundWithBlock:^(NSArray *returnedObjects, NSError *error) {
        [aiv stopAnimating];
        if (!error) {
            _objectsForShow = returnedObjects;
            [_tableview reloadData];
        }else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objectsForShow.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *object = [_objectsForShow objectAtIndex:indexPath.row];
    PFObject *user = object[@"owner"];
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.delegate=self;
    cell.indexPath=indexPath;
    PFUser *currentuser=[PFUser currentUser];
    if (currentuser) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", user[@"PhoneNum"]];
    }
    return cell;
}
-(void)applyButtonPressed:(NSIndexPath *)indexPath
{
    ip = indexPath;
    PFObject *item = [_objectsForShow objectAtIndex:indexPath.row];
    item[@"State"] = @YES;
    [item saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (succeeded) {
            [Utilities popUpAlertViewWithMsg:@"你已成功加此人为好友！" andTitle:nil];
            [self requestData];
        }
    }];
}
- (void)jujueButtonPressed:(NSIndexPath *)indexPath
{
    ip = indexPath;
    PFObject *item = [_objectsForShow objectAtIndex:indexPath.row];
    [item deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (succeeded) {
            [Utilities popUpAlertViewWithMsg:@"你已成功拒绝加此人为好友！" andTitle:nil];
            [self requestData];
        }
    }];
}
- (IBAction)loginAction:(UIButton *)sender forEvent:(UIEvent *)event
{
    
}
- (void)loadingData{
    
    PFUser *User = [PFUser currentUser];
    _nickName.text = User[@"NickName"];
    _IndividualitySignature.text = User[@"PeoSignature"];
    
    [User[@"HeadImg"] getDataInBackgroundWithBlock:^(NSData *photoData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:photoData];
            dispatch_async(dispatch_get_main_queue(), ^{
                _headImg.image = image;
            });
        }
    }];
}
- (void)pToLogin{
    _nickName.text = @"请登录";
    _IndividualitySignature.text = @"";
    _headImg.image = [UIImage imageNamed:@"dragon"];
}

- (IBAction)perAction:(UIButton *)sender {
    
    PFUser *currentUser=[PFUser currentUser];
    if (currentUser) {
        personalDataViewController *person = [self.storyboard instantiateViewControllerWithIdentifier:@"person"];
        //初始化导航控制器
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:person];
        //动画效果
        nc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        //导航条隐藏掉
        nc.navigationBarHidden = NO;
        //类似那个箭头 跳转到第二个界面
        [self presentViewController:nc animated:YES completion:nil];
        
    }else{
        [Utilities popUpAlertViewWithMsg:@"个人信息需要登陆后才能查看呦~" andTitle:@"贴心小提示"];
    }
}
-(void)dealloc
{
    
}
@end