//
//  APPSettingViewController.m
//  Matro
//
//  Created by 陈文娟 on 16/5/2.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "APPSettingViewController.h"
#import "APPSettingCell.h"
#import "HFSUtility.h"
#import "MNNAboutUsViewController.h"

@interface APPSettingViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation APPSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"应用设置";
    self.logoutBtn.layer.borderWidth = 0.5;
    self.logoutBtn.backgroundColor = [HFSUtility hexStringToColor:@"AE8E5D"];
    [self.logoutBtn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)logout:(id)sender
{
    // 存储用户信息
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:kUSERDEFAULT_USERCARDNO];
    [userDefaults removeObjectForKey:kUSERDEFAULT_USERAVATOR];
    [userDefaults removeObjectForKey:kUSERDEFAULT_USERID];

    [userDefaults removeObjectForKey:kUSERDEFAULT_USERPHONE];

    [userDefaults removeObjectForKey:kUSERDEFAULT_USERNAME];

    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark- UITableViewDataSource And UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    return 4;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==3) {
        MNNAboutUsViewController *VC = [MNNAboutUsViewController new];
        [self.navigationController pushViewController:VC animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==1) {
        return 80;
    }
    else{
        return 40;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    
    static NSString *CellIdentifier = @"APPSettingCell" ;
    APPSettingCell *cell = (APPSettingCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
        cell = [array objectAtIndex:0];
        
    }
    switch (indexPath.row) {
        case 0:
            cell.lbname.text = @"版本";
            cell.valueLB.text = @"1.0.0";
            cell.descLB.hidden = YES;
            break;
        case 2:
            cell.lbname.text = @"清除缓存";
            cell.valueLB.text = @"16MB";
            cell.descLB.hidden = YES;

            break;
        case 3:
            cell.lbname.text = @"关于我们";
            cell.descLB.hidden = YES;
            cell.valueLB.hidden = YES;
            break;
        case 1:
            cell.lbname.text = @"接收通知";
            cell.valueLB.text = @"已开启";
            cell.valueLB.textColor = [HFSUtility hexStringToColor:@"AE8E5D"];
            cell.descLB.hidden = NO;

            break;
        default:
            break;
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

@end
