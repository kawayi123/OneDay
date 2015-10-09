//
//  TableViewCell.h
//  OneDay
//
//  Created by feng on 15/9/28.
//  Copyright (c) 2015年 Mr.ZhixinDuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TableViewCellDelegate;//协议的声明
@protocol TableViewCellDelegate <NSObject>
- (void)applyButtonPressed:(NSIndexPath *)indexPath;
- (void)jujueButtonPressed:(NSIndexPath *)indexPath;
- (void)photoTapAtIndexPath:(NSIndexPath *)indexPath;
@end
@interface TableViewCell : UITableViewCell
//以下左滑通知cell
@property (strong, nonatomic) NSIndexPath *indexPath;
//创建声明协议的实例
@property (weak, nonatomic) id<TableViewCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *calendarName;
@property (weak, nonatomic) IBOutlet UILabel *beginTime;
@property (weak, nonatomic) IBOutlet UILabel *issuer;

@property (weak, nonatomic) IBOutlet UILabel *Schedulename;
@property (weak, nonatomic) IBOutlet UILabel *Event;

@property (weak, nonatomic) IBOutlet UILabel *StartTime;
@property (weak, nonatomic) IBOutlet UIButton *applyButton;


@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UILabel *phonenum;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@end
