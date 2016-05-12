//
//  MLListViewController.m
//  Matro
//
//  Created by NN on 16/3/26.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLListViewController.h"

#import "HFSUtility.h"
#import "HFSConstants.h"
#import "HFSServiceClient.h"

#import "HFSProductTableViewCell.h"
#import "MLGoodsDetailsViewController.h"

#import "MLProductModel.h"


#define HFSProductTableViewCellIdentifier @"HFSProductTableViewCellIdentifier"

@interface MLListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation MLListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"商品清单";
    NSString *rightBarButtonStr = [NSString stringWithFormat:@"共%ld件",_orderDetail.PRODUCTLIST.count];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:rightBarButtonStr style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [_tableView registerNib:[UINib nibWithNibName:@"HFSProductTableViewCell" bundle:nil] forCellReuseIdentifier:HFSProductTableViewCellIdentifier];
//    [self downLoadOrderList];
}
#pragma mark 获取订单清单
//- (void)downLoadOrderList {
//    NSString *urlStr = [NSString stringWithFormat:@"%@Ajax/order/OrderForm.ashx?op=orderlist&pagesize=10&pageindex=1&ddly=&status=&search=&fkqk=&yhstatus=0&tpgg=m&userid=1502649",SERVICE_GETBASE_URL];
//    [[HFSServiceClient sharedClient] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"请求成功");
//        NSDictionary *dic = (NSDictionary *)responseObject;
//        NSLog(@"%@",dic);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"请求失败");
//    }];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate and  UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 95.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     MLProductModel *order = [_orderDetail.PRODUCTLIST objectAtIndex:indexPath.section];
    MLGoodsDetailsViewController * vc = [[MLGoodsDetailsViewController alloc]init];
    NSDictionary *params = @{@"JMSP_ID":order.JMSP_ID?:@"",@"ZCSP":order.ZCSP?:@""};
    vc.paramDic = params;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _orderDetail.PRODUCTLIST.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HFSProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HFSProductTableViewCellIdentifier];
    
    if (!cell) {
        cell = [[HFSProductTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HFSProductTableViewCellIdentifier];
    }
    MLProductModel *order = [_orderDetail.PRODUCTLIST objectAtIndex:indexPath.section];
    cell.product = order;
    return cell;
}



@end
