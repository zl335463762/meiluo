//
//  MNNManagementViewController.m
//  Matro
//
//  Created by benssen on 16/3/28.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MNNManagementViewController.h"
#import "MNNModifyNameViewController.h"
#import "MNNModifyPasswordViewController.h"
#import "MLAddressListViewController.h"
#import "HFSUtility.h"
#import "HFSConstants.h"
#import "HFSServiceClient.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+HeinQi.h"
#import "SBJSON.h"
#import "GTMNSString+URLArguments.h"


@interface MNNManagementViewController ()<UITableViewDataSource,UITableViewDelegate,MNNModifyNameViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    UITableView *_tableView;
    UILabel *_lable;
    UIImageView *_imageView;
    NSString *loginid ;
    NSString *avatorurl;
    NSUserDefaults *userDefaults;
    UIAlertController *alertController;

}

@end

@implementation MNNManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账户信息设置";
    [self createTableView];
    userDefaults = [NSUserDefaults standardUserDefaults];
    loginid = [userDefaults objectForKey:kUSERDEFAULT_USERID];
    avatorurl = [userDefaults objectForKey:kUSERDEFAULT_USERAVATOR];
    [self showAlert];

    // Do any additional setup after loading the view.
}
//创建tableView
- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"头像";
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width-20, 10, 60, 60)];
        if (avatorurl) {
            [_imageView sd_setImageWithURL:[NSURL URLWithString:avatorurl] placeholderImage:[UIImage imageNamed:@"weidenglu_touxiang"]];
        }
        [cell.contentView addSubview:_imageView];
    }else if (indexPath.row == 1) {
        cell.textLabel.text = @"昵称";
        _lable = [[UILabel alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width-200, 10, 200, 20)];
        _lable.text = [userDefaults objectForKey:kUSERDEFAULT_USERNAME];
        _lable.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:_lable];
    }else if (indexPath.row == 2) {
        cell.textLabel.text = @"用户名";
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width-150, 10, 150, 20)];
        lable.text = [userDefaults objectForKey:kUSERDEFAULT_USERPHONE];;
        lable.textAlignment = NSTextAlignmentRight;
        cell.accessoryView = lable;
    }else if (indexPath.row == 3) {
        cell.textLabel.text = @"收货地址";
    }else if (indexPath.row == 4) {
        cell.textLabel.text = @"修改密码";
    }
    if (indexPath.row != 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}
- (void)MNNModifyNameViewController:(MNNModifyNameViewController *)ViewControlle userName:(NSString *)userName {
    _lable.text = userName;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 80;
    }
    else {
        return 40;
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //头像
    if (indexPath.row == 0) {
        [self presentViewController:alertController animated:YES completion:nil];

    }
    //昵称
    if (indexPath.row == 1) {
        self.hidesBottomBarWhenPushed = YES;
        MNNModifyNameViewController *modifyNameVC = [MNNModifyNameViewController new];
        modifyNameVC.delegate = self;
        [self.navigationController pushViewController:modifyNameVC animated:YES];
    }
    //收货地址
    if (indexPath.row == 3) {
        MLAddressListViewController *vc = [[MLAddressListViewController alloc]init];
        vc.delegate = nil;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    //修改密码
    if (indexPath.row == 4) {
        self.hidesBottomBarWhenPushed = YES;
        MNNModifyPasswordViewController *modifyPasswordVC = [MNNModifyPasswordViewController new];
        [self.navigationController pushViewController:modifyPasswordVC animated:YES];
    }
}
- (BOOL) isCameraAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}
-(void)showImagePickerView:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = sourceType;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)showAlert {
    
    NSString *cancelButtonTitle = @"取消";
    NSString *otherButtonTitle01 = @"拍照";
    NSString *otherButtonTitle02 = @"从手机相册选择";
    
    alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    __weak __typeof(&*self)weakSelf =self;
    

    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        
    }];
    
    UIAlertAction *otherAction01 = [UIAlertAction actionWithTitle:otherButtonTitle01 style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        if ([weakSelf isCameraAvailable]) {
            [weakSelf showImagePickerView:UIImagePickerControllerSourceTypeCamera];
        }else{
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"该设备不支持相机拍照";
            [_hud hide:YES afterDelay:2];
        }
        
    }];
    
    UIAlertAction *otherAction02 = [UIAlertAction actionWithTitle:otherButtonTitle02 style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [weakSelf showImagePickerView:UIImagePickerControllerSourceTypePhotoLibrary];
        
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction01];
    [alertController addAction:otherAction02];
    
}


#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if ([info[UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        
        
        NSData *imageData = UIImageJPEGRepresentation([info[UIImagePickerControllerEditedImage] scaleToSize:CGSizeMake(256.0f, 256.0f)], 1);
        UIImage *avatorimg = [UIImage imageWithData:imageData];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"avator.jpg"]];
        //NSLog(@"头像存放的地址：%@",filePath);
        
        BOOL result = [UIImagePNGRepresentation(avatorimg)writeToFile: filePath    atomically:YES]; // 保存成功会返回YES
        //[UIImagePNGRepresentation(avatorimg) write];
        _imageView.image = [UIImage imageWithData:imageData];

        if (result) {
            NSData *imgdata = [NSData dataWithContentsOfFile:filePath];
            
            NSString *_encodedImageStr =[NSString stringWithFormat:@"data:image/jpeg;base64,%@",[imgdata base64EncodedStringWithOptions:0]];
//            _encodedImageStr=[_encodedImageStr gtm_stringByEscapingForURLArgument];
            NSDictionary *persondic = @{@"imgFileName":@"avator.jpg",@"imgType":@"ReduceResolution",@"imgContent":_encodedImageStr};
            
            SBJSON *sbjson = [SBJSON new];
            NSString *sbstr = [sbjson stringWithObject:persondic error:nil];
            
            
            [[HFSServiceClient sharedClientwithUrl:@"http://app-test.matrojp.com/P2MLinkCenter/"] POST:@"image/upload" parameters:sbstr success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"%@",responseObject);
                if (responseObject) {
                    NSDictionary *result = (NSDictionary *)responseObject;
                    if(result) {
                        NSString *imgrurl = result[@"imgUrl"];
                        if (imgrurl) {
                            [userDefaults setObject:imgrurl forKey:kUSERDEFAULT_USERAVATOR];
                            [userDefaults synchronize];
                        }
                    }
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [_hud show:YES];
                _hud.mode = MBProgressHUDModeText;
                _hud.labelText = @"请求失败";
                [_hud hide:YES afterDelay:2];
            }];
            
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


-(NSString *)StringNDic:(NSDictionary *)dic{
    
    
    NSMutableString *orderSpec = [NSMutableString string];
    NSArray *sortedKeys = [dic.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 caseInsensitiveCompare:obj2];
    }];
    for (NSString *key in sortedKeys) {
        [orderSpec appendFormat:@"%@=%@&", key, [dic objectForKey:key]];
    }
    
    return orderSpec;
    
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
