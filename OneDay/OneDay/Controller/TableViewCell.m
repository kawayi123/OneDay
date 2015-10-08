//
//  TableViewCell.m
//  OneDay
//
//  Created by feng on 15/9/28.
//  Copyright (c) 2015年 Mr.ZhixinDuan. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell
- (IBAction)agree:(id)sender forEvent:(UIEvent *)event
{
    if (_delegate&&[_delegate respondsToSelector:@selector(applyButtonPressed:)])//":"表示有参
    {
        [_delegate applyButtonPressed:self.indexPath];
    }
}
- (IBAction)jujue:(id)sender forEvent:(UIEvent *)event
{
    if (_delegate&&[_delegate respondsToSelector:@selector(jujueButtonPressed:)])//":"表示有参
    {
        [_delegate jujueButtonPressed:self.indexPath];
    }
}

@end
