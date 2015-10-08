//
//  leftViewController.h
//  OneDay
//
//  Created by 段志鑫 on 15/9/21.
//  Copyright (c) 2015年 Mr.ZhixinDuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewCell.h"
@interface leftViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,TableViewCellDelegate>
{
        Boolean state;
        NSIndexPath *ip;
}
@property(strong,nonatomic)NSArray *objectsForShow;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(weak,nonatomic)IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIButton *perBtn;

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *IndividualitySignature;
- (IBAction)perAction:(UIButton *)sender;

@end
