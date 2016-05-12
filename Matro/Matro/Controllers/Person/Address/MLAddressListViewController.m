//
//  MLAddressListViewController.m
//  Matro
//
//  Created by NN on 16/3/29.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLAddressListViewController.h"
#import "MLAddressListTableViewCell.h"
#import "MLAddressInfoViewController.h"
#import "HFSConstants.h"
#import "HFSServiceClient.h"
#import "HFSUtility.h"


@interface MLAddressListViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *_addressArray;//地址列表的数组
    NSString *userid;
    NSDictionary *selAddress;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *tisBgView;//无地址的时候显示的提示主视图
@property (strong, nonatomic) IBOutlet UIView *listBgView;//有地址显示tableview时候的主视图

@end

@implementation MLAddressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (_delegate) {
        self.title = @"选择收货地址";
    }else{
        self.title = @"收货地址管理";
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userid = [userDefaults valueForKey:kUSERDEFAULT_USERID];
    _addressArray = [[NSMutableArray alloc] init];
    
  
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self loadDateAddressList];

}
#pragma mark 获取收货地址清单
- (void)loadDateAddressList {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@Ajax/member/glshdz.ashx?op=getshdzlist&userid=%@",SERVICE_GETBASE_URL,userid];
    [[HFSServiceClient sharedJSONClient] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"请求成功");
        [_addressArray removeAllObjects];
        if(responseObject)
        {
            NSArray *array = (NSArray *)responseObject;
            if (array && array.count > 0) {
                NSLog(@"地址列表为：%@",array);
                [_addressArray addObjectsFromArray:array];
                self.tisBgView.hidden = YES;
                self.listBgView.hidden = NO;
            }
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    if (_addressArray.count == 0) {
        _tisBgView.hidden = NO;
        _listBgView.hidden = YES;
    }else{
        _tisBgView.hidden = YES;
        _listBgView.hidden = NO;
    }
}

- (IBAction)newAddress:(id)sender {
    MLAddressInfoViewController * vc = [[MLAddressInfoViewController alloc]init];
    vc.isNewAddress = YES;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)editButtonAction:(id)sender{
    UIButton * button = ((UIButton *)sender);
    NSLog(@"%ld",button.tag);
    MLAddressInfoViewController * vc = [[MLAddressInfoViewController alloc]init];
    vc.isNewAddress = NO;
    vc.paramdic = _addressArray[button.tag];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark- UITableViewDataSource And UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    return _addressArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    
    static NSString *CellIdentifier = @"MLAddressListTableViewCell" ;
    MLAddressListTableViewCell *cell = (MLAddressListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    
    NSDictionary *dic = [_addressArray objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = dic[@"SHRMC"];
    cell.phoneLabel.text = dic[@"SHRMPHONE"];
    cell.addressLabel.text = dic[@"SFNAME"];
    if (_hasCheck) {
        cell.selButton.tag = indexPath.row;
        [cell.selButton addTarget:self action:@selector(setSelAddress:) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        cell.selButton.hidden = YES;
    }
    cell.editButton.tag = indexPath.row;
    [cell.editButton addTarget:self action:@selector(editButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)setSelAddress:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    btn.selected = !btn.selected;
    selAddress = [_addressArray objectAtIndex:btn.tag];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_delegate) {
        NSDictionary *dic = [_addressArray objectAtIndex:indexPath.row];
        NSLog(@"管理收货地址中点击cell");
        if ([_delegate respondsToSelector:@selector(AddressDic:)]) {
            [_delegate AddressDic:dic];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
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
