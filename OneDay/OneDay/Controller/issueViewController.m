//
//  issueViewController.m
//  OneDay
//
//  Created by 段志鑫 on 15/9/21.
//  Copyright (c) 2015年 Mr.ZhixinDuan. All rights reserved.
//

#import "issueViewController.h"

#import "Utilities.h"

#import "UIImageView+WebCache.h"
@interface issueViewController ()
{
    NSArray *data;
    NSArray *filterData;
    UISearchDisplayController *searchDisplayController;
}
@end

@implementation issueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    searchBar.placeholder = @"搜索";
    
    // 添加 searchbar 到 headerview
    self.tableview.tableHeaderView = searchBar;
    
    // 用 searchbar 初始化 SearchDisplayController
    // 并把 searchDisplayController 和当前 controller 关联起来
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchDisplayController.searchBar.delegate = self;
    // searchResultsDataSource 就是 UITableViewDataSource
    searchDisplayController.searchResultsDataSource = self;
    // searchResultsDelegate 就是 UITableViewDelegate
    searchDisplayController.searchResultsDelegate = self;
    
    [self dataPreparation];
    [self uiConfiguration];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
//点击搜索框时调用

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self req:searchText];
}
- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView {
}
- (void)updateSearchResultsForSearchController:(UISearchController *)searchControlle{
}
//在搜索框查找用户的手机号
-(void)req:(NSString *)searchText
{
    PFUser *currentUser=[PFUser currentUser];
    if (currentUser) {
        PFQuery *query = [PFQuery queryWithClassName:@"_User"];
        [query whereKey:@"PhoneNum" containsString:searchText];
        [query whereKey:@"PhoneNum" notEqualTo:currentUser[@"PhoneNum"]];
        [query selectKeys:@[@"PhoneNum"]];
        UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
        [query findObjectsInBackgroundWithBlock:^(NSArray *returnedObjects, NSError *error) {
            [aiv stopAnimating];
            if (!error) {
                filterData = returnedObjects;
                [searchDisplayController.searchResultsTableView reloadData];
            } else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];

    }else
    {
        [Utilities popUpAlertViewWithMsg:@"请先登录后在使用！" andTitle:nil];
    }
    
}

-(void)loadDataBegin
{
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"owner == %@ OR friendUser == %@", currentUser, currentUser];
        PFQuery *query = [PFQuery queryWithClassName:@"friends"];
        [query whereKey:@"owner" equalTo:currentUser];
        [query whereKey:@"State" equalTo:@YES];
        [query includeKey:@"friendUser"];
        [query includeKey:@"owner"];
        [query selectKeys:@[@"owner", @"friendUser"]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *returnedObjects, NSError *error) {
            [_aiv stopAnimating];
            UIRefreshControl *rc = (UIRefreshControl *)[_tableview viewWithTag:8001];
            [rc endRefreshing];
            if (!error) {
                data = returnedObjects;
                [_tableview reloadData];
            }else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    } else {
        UIRefreshControl *rc = (UIRefreshControl *)[_tableview viewWithTag:8001];
        [rc endRefreshing];
        [_aiv stopAnimating];
        data = [NSArray new];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView != _tableview) {
        _item=nil;
        _item= filterData[indexPath.row];
            //获得当前点击的tableviewcell对应的数据
            PFObject *obj = filterData[indexPath.row];
            PFUser *user = [PFUser currentUser];
            PFQuery *query = [PFQuery queryWithClassName:@"friends"];
            [query whereKey:@"owner" equalTo:user];
            [query whereKey:@"friendUser" equalTo:obj];
            [query countObjectsInBackgroundWithBlock:^(int number, NSError *error)
             {
                 if (!error)
                 {
                     if (number == 0)
                     {
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"你确定加此人为好友"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
                         [alert show];
                     } else
                     {
                         [Utilities popUpAlertViewWithMsg:@"你已添加过该好友！" andTitle:nil];
                     }
                 }
             }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        PFObject *item = [PFObject objectWithClassName:@"friends"];
        PFUser *currentUser = [PFUser currentUser];
        item[@"owner"] = currentUser;
        item[@"friendUser"] = _item;
        item[@"State"] = @NO;
        UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
        [item saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [aiv stopAnimating];
            if (succeeded)
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else if (error.code == 101) {
                [Utilities popUpAlertViewWithMsg:@"你的信息有误" andTitle:nil];
            } else if (error.code == 100) {
                [Utilities popUpAlertViewWithMsg:@"网络不给力，请稍后再试" andTitle:nil];
            }else {
                [Utilities popUpAlertViewWithMsg:nil andTitle:nil];
            }
        }];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableview) {
        return data.count;
    }else{
        return filterData.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableview) {
        TableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        cell1.delegate=self;
        cell1.indexPath=indexPath;
        //PFUser *user = [PFUser currentUser];
        PFObject *obj = data[indexPath.row];
        //PFUser *user1 = obj[@"owner"];
        PFUser *user2 = obj[@"friendUser"];
        cell1.nickname.text=[NSString stringWithFormat:@"昵称：%@", user2[@"NickName"]];
        cell1.phonenum.text =[NSString stringWithFormat:@"手机号：%@", user2[@"PhoneNum"]];
        PFFile *file = user2[@"HeadImg"];
        [file getDataInBackgroundWithBlock:^(NSData *photoData, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:photoData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //把图片放到cell上的imageview上
                    cell1.image.image = image;
                });
            }
        }];
//        if (user == user1) {
//            cell1.nickname.text=[NSString stringWithFormat:@"昵称：%@", user2[@"NickName"]];
//            cell1.phonenum.text =[NSString stringWithFormat:@"手机号：%@", user2[@"PhoneNum"]];
//            PFFile *file = user2[@"HeadImg"];
//            [file getDataInBackgroundWithBlock:^(NSData *photoData, NSError *error) {
//                if (!error) {
//                    UIImage *image = [UIImage imageWithData:photoData];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        //把图片放到cell上的imageview上
//                        cell1.image.image = image;
//                    });
//                }
//            }];
//        } else {
//            cell1.nickname.text=[NSString stringWithFormat:@"昵称：%@", user1[@"NickName"]];
//            cell1.phonenum.text =[NSString stringWithFormat:@"手机号：%@", user1[@"PhoneNum"]];
//            PFFile *file = user1[@"HeadImg"];
//            [file getDataInBackgroundWithBlock:^(NSData *photoData, NSError *error) {
//                if (!error) {
//                    UIImage *image = [UIImage imageWithData:photoData];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        //把图片放到cell上的imageview上
//                        cell1.image.image = image;
//                    });
//                }
//            }];
//        }
        return cell1;
    } else {
        static NSString *cellId = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        PFObject *obj = filterData[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"手机号：%@", obj[@"PhoneNum"]];
        
        return cell;
    }
}

- (IBAction)menuAction:(UIBarButtonItem *)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSwitch" object:self];
}

//对界面进行操作
-(void)uiConfiguration
{
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];//在可以滚动视图中添加RefreshControl下拉即可刷新视图
    NSString *title = [NSString stringWithFormat:@"下拉即可刷新"];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentCenter];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    NSDictionary *attrsDictionary = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody],NSParagraphStyleAttributeName:style,NSForegroundColorAttributeName:[UIColor brownColor]};
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
    refreshControl.attributedTitle = attributedTitle;
    refreshControl.tintColor = [UIColor brownColor];
    refreshControl.backgroundColor = [UIColor groupTableViewBackgroundColor];
    refreshControl.tag=8001;
    [refreshControl addTarget:self action:@selector(initializeData) forControlEvents:UIControlEventValueChanged];//当变化时刷新列表数据
    [self.tableview addSubview:refreshControl];
    self.tableview.tableFooterView=[[UIView alloc]init];
}

- (void)refreshData:(UIRefreshControl *)rc {
    [self.tableview reloadData];//重新加载数据
    [self performSelector:@selector(endRefreshing:) withObject:rc afterDelay:1.f];//让方法延迟1秒,在执行endRefreshing方法
}
- (void)endRefreshing:(UIRefreshControl *)rc {
    [rc endRefreshing];
}
//对数据初始化
-(void)dataPreparation//进入页面,菊花膜＋初始数据（第一页数据）
{
    _objectsForShow=nil;
    _objectsForShow=[NSMutableArray new];
    _aiv=[Utilities getCoverOnView:[[UIApplication sharedApplication]keyWindow]];//整个屏幕上转菊花
    [self initializeData];//下拉刷新调用initializeData
}
-(void)initializeData//下拉刷新，刷新器＋初始数据（第一页数据）
{
    [self loadDataBegin];
    [_tableview reloadData];
}
//点击图片时执行的方法
- (void)photoTapAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *obj = data[indexPath.row];
    PFUser *user= obj[@"friendUser"];
    _zoomIV = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _zoomIV.userInteractionEnabled = YES;
    PFFile *file = user[@"HeadImg"];
    [file getDataInBackgroundWithBlock:^(NSData *photoData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:photoData];
            dispatch_async(dispatch_get_main_queue(), ^{
                //把图片放到cell上的imageview上
                _zoomIV.image = image;
            });
        }
    }];
    _zoomIV.contentMode = UIViewContentModeScaleAspectFit;//UIViewContentModeScaleAspectFit达到屏幕一样长的边
    _zoomIV.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *ivTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ivTap:)];
    [_zoomIV addGestureRecognizer:ivTap];
    [[[UIApplication sharedApplication] keyWindow] addSubview:_zoomIV];
}

-(void)ivTap:(UITapGestureRecognizer *)tap{
    if (tap.state==UIGestureRecognizerStateRecognized) {
        [_zoomIV removeFromSuperview];
        _zoomIV=nil;//将zoomIV内存释放掉
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentSize.height>scrollView.frame.size.height) {
        if (!scrollView.contentOffset.y>(scrollView.contentSize.height-scrollView.frame.size.height)) {//当scrollView的y轴大于scrollView内容高度减去scrollView本身的高度时执行下拉刷新
            [self loadDataBegin];
        }
    }
}
//结束加载数据
-(void)loadDataEnd
{
    self.tableview.tableFooterView = [[UIView alloc] init];
}
-(void)dealloc
{
}
@end
