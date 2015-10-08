//
//  issueViewController.m
//  OneDay
//
//  Created by 段志鑫 on 15/9/21.
//  Copyright (c) 2015年 Mr.ZhixinDuan. All rights reserved.
//

#import "issueViewController.h"

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

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
}

-(void)req:(NSString *)searchText
{
    NSLog(@"IN");
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"PhoneNum" containsString:searchText];
    [query selectKeys:@[@"PhoneNum"]];
    
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    [query findObjectsInBackgroundWithBlock:^(NSArray *returnedObjects, NSError *error) {
        [aiv stopAnimating];
        //[rc endRefreshing];
        if (!error) {
            filterData = returnedObjects;
            NSLog(@"%@",filterData);
            [searchDisplayController.searchResultsTableView reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];;
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"你确定加此人为好友"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
//    [alert show];
//}
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (buttonIndex == 1) {
//        
//        PFObject *item = [PFObject objectWithClassName:@"friends"];
//        PFUser *currentUser = [PFUser currentUser];
//        item[@"owner"] = currentUser;
//        item[@"friendUser"] = currentUser;
//        UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
//        [item saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//            [aiv stopAnimating];
//            if (succeeded) {
//                [self.navigationController popViewControllerAnimated:YES];
                //if (state==YES) {
                    
                    //                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"你是否同意添加此人为好友？"] delegate:self cancelButtonTitle:@"拒绝" otherButtonTitles:@"同意",nil];
                    //                    [alert show];
                    //                     if (buttonIndex == 1) {
                    //                         PFObject *item = [PFObject objectWithClassName:@"friends"];
                    //                         PFUser *curr=[PFUser currentUser];
                    //                         item[@"owner"]=curr;
                    //                         item[@"friendUser"] = curr;
                    //                         item[@"State"] = curr;
                    //                         UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
                    //                         [item saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    //                             [aiv stopAnimating];
                    //                             if (succeeded) {
                    //                                 [self.navigationController popViewControllerAnimated:YES];
                    //                             }
                    //                         }];
                    
             //   }
                // }else{
                
                //  }
                //[self.navigationController popViewControllerAnimated:YES];
                //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotifyFriendsSliding) name:@"NotifyFriends" object:nil];
//            }else if (error.code == 101) {
//                [Utilities popUpAlertViewWithMsg:@"你的信息有误" andTitle:nil];
//            } else if (error.code == 100) {
//                [Utilities popUpAlertViewWithMsg:@"网络不给力，请稍后再试" andTitle:nil];
//            }
//            else {
//                [Utilities popUpAlertViewWithMsg:nil andTitle:nil];
//            }
//        }];
//        
//    }
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableview) {
        return data.count;
    }else{
        // 谓词搜索
        //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@",searchDisplayController.searchBar.text];
        //filterData =  [[NSArray alloc] initWithArray:[data filteredArrayUsingPredicate:predicate]];
        return filterData.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    if (tableView == _tableview) {
        cell.textLabel.text = data[indexPath.row];
    }else{
        NSLog(@"Did");
        PFObject *obj = filterData[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", obj[@"PhoneNum"]];
    }
    
    return cell;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


- (IBAction)menuAction:(UIBarButtonItem *)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSwitch" object:self];
}
@end
