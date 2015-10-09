//
//  TableViewCell.m
//  OneDay
//
//  Created by feng on 15/9/28.
//  Copyright (c) 2015年 Mr.ZhixinDuan. All rights reserved.
//

#import "TableViewCell.h"
#import "issueViewController.h"
@implementation TableViewCell
-(void)layoutSubviews
{
    [super layoutSubviews];
    //创建第二个手势（点击手势）
    UITapGestureRecognizer *photoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTap:)];
    [self.image addGestureRecognizer:photoTap];
}
//判断点击手势被识别时候，执行photoTapAtIndexPath方法
- (void)photoTap:(UITapGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateRecognized) {
        if (_delegate && self.indexPath && [_delegate respondsToSelector:@selector(photoTapAtIndexPath:)]) {
            [_delegate photoTapAtIndexPath:_indexPath];
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (IBAction)agree:(id)sender forEvent:(UIEvent *)event {
    if (_delegate&&[_delegate respondsToSelector:@selector(applyButtonPressed:)])//":"表示有参
    {
        [_delegate applyButtonPressed:self.indexPath];
    }
}
- (IBAction)jujue:(id)sender forEvent:(UIEvent *)event {
    if (_delegate&&[_delegate respondsToSelector:@selector(jujueButtonPressed:)])//":"表示有参
    {
        [_delegate jujueButtonPressed:self.indexPath];
    }
}

@end
