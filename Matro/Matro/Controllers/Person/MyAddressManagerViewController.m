//
//  MyAddressManagerViewController.m
//  Matro
//
//  Created by 陈文娟 on 16/5/1.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MyAddressManagerViewController.h"
#import "AddressManagerCell.h"
#import "HFSServiceClient.h"
#import "HFSConstants.h"
#import "HFSUtility.h"
#import "MBProgressHUD.h"
#import "MLAddressInfoViewController.h"

@interface MyAddressManagerViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    NSMutableArray *addressAry;
    NSString *userid;
    MBProgressHUD *_hud;
    UIButton *lastselbtn;
}
@end

@implementation MyAddressManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收货地址管理";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userid = [userDefaults valueForKey:kUSERDEFAULT_USERID];
    addressAry = [[NSMutableArray alloc] init];
    _addressTBView.sectionFooterHeight = 0.1f;
    [self.addBtn setBackgroundColor:[HFSUtility hexStringToColor:@"AE8E5D"]];
    [self.addBtn addTarget:self action:@selector(addAddress:) forControlEvents:UIControlEventTouchUpInside];
    _hud = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:_hud];
}
-(void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
    [self loadDateAddressList];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- UITableViewDataSource And UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return addressAry.count;
}// Default is 1 if not implemented
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    
    static NSString *CellIdentifier = @"AddressManagerCell" ;
    AddressManagerCell *cell = (AddressManagerCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
        cell = [array objectAtIndex:0];
        cell.editBtn.layer.borderWidth = 0.5f;
        cell.delBtn.layer.borderWidth = 0.5f;
        [cell.checkBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [cell.checkBtn setTitleColor:[HFSUtility hexStringToColor:@"AE8E5D"] forState:UIControlStateSelected];
    }
    
    NSDictionary *dic = [addressAry objectAtIndex:indexPath.section];
    
    cell.usernameLabel.text = dic[@"SHRMC"];
    cell.phoneLabel.text = dic[@"SHRMPHONE"];
    cell.addressLabel.text = dic[@"SFNAME"];
    cell.checkBtn.tag = indexPath.section;
    [cell.checkBtn addTarget:self action:@selector(setSelAddress:) forControlEvents:UIControlEventTouchUpInside];
    if (lastselbtn) {
        if (indexPath.section==lastselbtn.tag) {
            cell.checkBtn.selected = YES;
        }
        else{
            cell.checkBtn.selected = NO;
        }
    }
    else{
        if ([@"1" isEqualToString:dic[@"MRSHRBJ"]] ) {
            cell.checkBtn.selected = YES;
        }
    }
    
    
    
    cell.editBtn.tag = indexPath.section;
    [cell.editBtn addTarget:self action:@selector(editButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.delBtn.tag = indexPath.section;
    [cell.delBtn addTarget:self action:@selector(delBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)delBtnAction:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    
    UIAlertView *alertview =[[UIAlertView alloc]initWithTitle:@"提示" message:@"您确定要删除此地址信息吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertview.tag = btn.tag;
    [alertview show];
    

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        NSDictionary *dic = addressAry[alertView.tag];
        NSString *urlStr = [NSString stringWithFormat:@"%@Ajax/member/glshdz.ashx?op=deladdr&inx=%@&userid=%@",SERVICE_GETBASE_URL,dic[@"INX"],userid];
        NSURL * URL = [NSURL URLWithString:urlStr];
        
        NSMutableURLRequest * request = [[NSMutableURLRequest alloc]init];
        [request setHTTPMethod:@"get"]; //指定请求方式
        [request setURL:URL]; //设置请求的地址
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error) {
                                          //NSData 转NSString
                                          if (data && data.length>0) {
                                              NSString *result  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                              if ([@"true" isEqualToString:result]) {
                                                  [self loadDateAddressList];
                                              }
                                              else
                                              {
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      
                                                      [_hud show:YES];
                                                      _hud.mode = MBProgressHUDModeText;
                                                      _hud.labelText = result;
                                                      _hud.labelFont = [UIFont systemFontOfSize:13];
                                                      [_hud hide:YES afterDelay:2];
                                                  });
                                                  
                                              }
                                          }
                                          
                                      }];
        
        [task resume];

    }
}

-(void)addAddress:(id)sender
{
    MLAddressInfoViewController *vc = [MLAddressInfoViewController new];
    vc.isNewAddress = YES;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
}

-(void)editButtonAction:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    NSInteger index = btn.tag;
    NSDictionary *dic = [addressAry objectAtIndex:index];
    MLAddressInfoViewController *vc = [MLAddressInfoViewController new];
    vc.paramdic = dic;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
}
-(void)setSelAddress:(id)sender
{
    NSLog(@"+++++++------测试按钮");
    UIButton *btn = (UIButton*)sender;
    btn.selected = !btn.selected;
    lastselbtn = btn;
    [_addressTBView reloadData];
//    selAddress = [_addressArray objectAtIndex:btn.tag];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark 获取收货地址清单
- (void)loadDateAddressList {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@Ajax/member/glshdz.ashx?op=getshdzlist&userid=%@",SERVICE_GETBASE_URL,userid];
    [[HFSServiceClient sharedJSONClient] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"请求成功");
        if(responseObject)
        {
            [addressAry removeAllObjects];
            NSArray *array = (NSArray *)responseObject;
            if (array && array.count>0) {
                [addressAry addObjectsFromArray:array];
            }
            
        }
        [_addressTBView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
}

#pragma mark 设置默认地址
-(void)setDefaultAddress
{
    NSString *urlStr = [NSString stringWithFormat:@"%@Ajax/member/glshdz.ashx?op=moren&inx=&userid=%@",SERVICE_GETBASE_URL,userid];
    NSURL * URL = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]init];
    [request setHTTPMethod:@"get"]; //指定请求方式
    [request setURL:URL]; //设置请求的地址
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      //NSData 转NSString
                                      if (data && data.length>0) {
                                          NSString *result  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                          NSLog(@"error %@",result);
                                          if ([@"true" isEqualToString:result]) {
                                              [self loadDateAddressList];
                                          }
                                          else
                                          {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  [_hud show:YES];
                                                  _hud.mode = MBProgressHUDModeText;
                                                  _hud.labelText = result;
                                                  _hud.labelFont = [UIFont systemFontOfSize:13];
                                                  [_hud hide:YES afterDelay:2];
                                              });
                                              
                                          }
                                      }
                                      
                                  }];
    
    [task resume];

}
@end
