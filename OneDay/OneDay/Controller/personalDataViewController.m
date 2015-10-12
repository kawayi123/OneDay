//
//  personalDataViewController.m
//  OneDay
//
//  Created by 段志鑫 on 15/9/21.
//  Copyright (c) 2015年 Mr.ZhixinDuan. All rights reserved.
//

#import "personalDataViewController.h"

@interface personalDataViewController ()
- (IBAction)saveAction:(UIBarButtonItem *)sender;
- (IBAction)pickAction:(UITapGestureRecognizer *)sender;

@end

@implementation personalDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[[storageMgr singletonStorageMgr]objectForKey:@"signup"] integerValue] == 1) {
        [[storageMgr singletonStorageMgr]removeObjectForKey:@"signup"];
    }
    [self loadingData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (IBAction)backAction:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)saveAction:(UIBarButtonItem *)sender {
  
    NSString *nickname = _nickName.text;
    NSString *peosign = _peoSignTF.text;
    NSString *email = _emailTF.text;
    NSString *phonenum = _phoneNum.text;
    if (_headImage.image == nil) {
        [Utilities popUpAlertViewWithMsg:@"请选择一张照片" andTitle:nil];
        return;
    }
    if ([nickname isEqualToString:@""] ||
        [email isEqualToString:@""]|| [phonenum isEqualToString:@""]) {
        [Utilities popUpAlertViewWithMsg:@"请填写所有信息" andTitle:nil];
        return;
    }
    //PFObject *item = [PFObject objectWithClassName:@"User"];
    PFUser *item = [PFUser currentUser];
    item[@"NickName"] = nickname;
    item[@"PeoSignature"] = peosign;
    item[@"email"] = email;
    item[@"PhoneNum"] = phonenum;
    
    NSData *photoData = UIImagePNGRepresentation(_headImage.image);
    PFFile *photoFile = [PFFile fileWithName:@"photo.png" data:photoData];
    item[@"HeadImg"] = photoFile;//给上传的图片起个名字
    PFUser *currentUser = [PFUser currentUser];//获取当前用户的实例
    item[@"owner"] = currentUser;
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    _btn.enabled=NO;
    [item saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [aiv stopAnimating];
        _btn.enabled=YES;
        if (succeeded) {
              [self.navigationController popViewControllerAnimated:YES];//结合线程触发通知，通过通知更新列表，上传成功后返回上页
            
        }else if (error.code == 101) {
            [Utilities popUpAlertViewWithMsg:@"你的信息有误" andTitle:nil];
        } else if (error.code == 100) {
            [Utilities popUpAlertViewWithMsg:@"网络不给力，请稍后再试" andTitle:nil];
        }
        else {
            [Utilities popUpAlertViewWithMsg:nil andTitle:nil];
        }
    }];
}
//设置imagePickerController的UIActionSheet的事件
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 2)
        return;
    
    UIImagePickerControllerSourceType temp;
    if (buttonIndex == 0) {
        temp = UIImagePickerControllerSourceTypeCamera;
    } else if (buttonIndex == 1) {
        temp = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    if ([UIImagePickerController isSourceTypeAvailable:temp]) {
        _imagePickerController = nil;
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.allowsEditing = YES;
        _imagePickerController.sourceType = temp;
        [self presentViewController:_imagePickerController animated:YES completion:nil];
    } else {
        if (temp == UIImagePickerControllerSourceTypeCamera) {
            [Utilities popUpAlertViewWithMsg:@"当前设备无照相功能" andTitle:nil];
        }
    }
}
- (IBAction)pickAction:(UITapGestureRecognizer *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    [actionSheet setExclusiveTouch:YES];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
}
//拿到已经编辑的图片，放到imagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    _headImage.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)loadingData{
    //在界面中显示用户信息。
    PFUser *User = [PFUser currentUser];
    _nickName.text = User[@"NickName"];
    _userName.text = User.username;
    _emailTF.text = User.email;
    _phoneNum.text = User[@"PhoneNum"];
    _peoSignTF.text = User[@"PeoSignature"];
    //将数据转换成二进制数据流进而转换成界面用户头像。
    [User[@"HeadImg"] getDataInBackgroundWithBlock:^(NSData *photoData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:photoData];
            dispatch_async(dispatch_get_main_queue(), ^{
                _headImage.image = image;
            });
        }
    }];
}
-(void)dealloc
{
    
}
@end
