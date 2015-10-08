//
//  issueViewController.h
//  OneDay
//
//  Created by 段志鑫 on 15/9/21.
//  Copyright (c) 2015年 Mr.ZhixinDuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface issueViewController : UIViewController<UISearchBarDelegate,UISearchDisplayDelegate,UISearchResultsUpdating,UITableViewDelegate,UITableViewDataSource>
{
    Boolean state;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) UISearchBar *searchBar;
- (IBAction)menuAction:(UIBarButtonItem *)sender;
@property(strong,nonatomic)PFObject *item;
@end
