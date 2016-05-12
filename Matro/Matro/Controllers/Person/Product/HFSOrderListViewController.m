//
//  HFSOrderListViewController.m
//  FashionShop
//
//  Created by 王闻昊 on 15/10/8.
//  Copyright © 2015年 HeinQi. All rights reserved.
//

#import "AppDelegate.h"

#import "HFSOrderListViewController.h"
#import "HFSOrderListTableViewCell.h"
#import "HFSProductTableViewCell.h"
#import "HFSOrderListHeaderView.h"
#import "HFSOrderListFooterView.h"
#import "MLMoreTableViewCell.h"
#import "MLPayViewController.h"
#import "MLLogisticsViewController.h"
//#import "HFSLogisticsViewController.h"
//#import "HFSPaymentSelectionViewController.h"
#import "MLOrderInfoViewController.h"
#import "HFSServiceClient.h"
#import "UIColor+HeinQi.h"
#import "MBProgressHUD.h"
//#import "HFSOrder.h"
//#import "HFSOrderItem.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "MLOrderListModel.h"
#import "MLProductModel.h"

#define CELL_IDENTIFIER @"OrderListCellIdentifier"
#define HEADER_IDENTIFIER @"OrderListHeaderIdentifier"
#define FOOTER_IDENTIFIER @"OrderListFooterIdentifier"

@interface HFSOrderListViewController () <UITableViewDelegate, UITableViewDataSource> {
#warning 这个订单类型的定义是根据螃蟹和韩电定义的，实际定义需要根据美罗接口来定！
    NSString *_statusStr;
    
    NSMutableArray *_orderList;
}
@property (strong, nonatomic) IBOutlet UIView *tisBgView;
@property (strong, nonatomic) IBOutlet UIImageView *tisImageView;
@property (strong, nonatomic) IBOutlet UILabel *tisLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


static NSInteger pageIndex = 1;

@implementation HFSOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Home_top_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(homeAction)];
    
    [_tableView registerNib:[UINib nibWithNibName:@"HFSProductTableViewCell" bundle:nil] forCellReuseIdentifier:CELL_IDENTIFIER];
    [_tableView registerNib:[UINib nibWithNibName:@"HFSOrderListHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:HEADER_IDENTIFIER];
    [_tableView registerNib:[UINib nibWithNibName:@"HFSOrderListFooterView" bundle:nil] forHeaderFooterViewReuseIdentifier:FOOTER_IDENTIFIER];
    
    
    _orderList = [NSMutableArray array];

    
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.tableView.header endRefreshing];
        pageIndex = 1;
        [self downLoadOrderList];
    
    }];
   
    
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self.tableView.footer endRefreshing];
        [self downLoadOrderList];
        
        //需要修改分页
    }];
     [_tableView.header beginRefreshing];
}
#pragma mark 获取我的订单数据
- (void)downLoadOrderList {
    NSString *userId = [[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_USERID];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSString *urlStr = [NSString stringWithFormat:@"%@Ajax/order/OrderForm.ashx?op=orderlist&pagesize=10&pageindex=%li&ddly=&status=%@&search=&fkqk=&yhstatus=0&tpgg=M&userid=%@",SERVICE_GETBASE_URL,(long)pageIndex,_statusStr,userId];
    [[HFSServiceClient sharedClient] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (pageIndex == 1) {
            [_orderList removeAllObjects];
        }
        pageIndex++;
        NSArray *resultArray = [responseObject objectForKey:@"ORDERLIST"];
        [_orderList addObjectsFromArray:[MLOrderListModel mj_objectArrayWithKeyValuesArray:resultArray]];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:2];
    }];
}
- (void)homeAction{
    [self getAppDelegate].tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    switch (_typeInteger) {
        case 0:
            self.title = @"我的订单";
            _statusStr = @"";
            _tisLabel.text = @"您目前还没有订单";
            break;
        case 1:
            self.title = @"待付款";
            _statusStr = @"wfk";
            _tisLabel.text = @"您目前还没有待付款订单";
            break;
        case 2:
            self.title = @"待发货";
            _statusStr = @"dfh";
            _tisLabel.text = @"您目前还没有待发货订单";
            break;
        case 3:
            self.title = @"待收货";
            _statusStr = @"dqr";
            _tisLabel.text = @"您目前还没有待收货订单";
        default:
            self.title = @"退款/换货";
            _statusStr = @"thd";
            _tisLabel.text = @"您目前还没有退款/换货订单";
            break;
    }
    
    //    [_hud show:YES];
    //    [[HFSServiceClient sharedClient]GET:[NSString stringWithFormat:@"order/list/%@", _statusStr] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //        NSDictionary *result = (NSDictionary *)responseObject;
    //        if ([result[@"status"] isEqualToNumber:@200]) {
    //
    //            if([result[@"data"] count] > 0){
    //
    //                _orderList = [MTLJSONAdapter modelsOfClass:[HFSOrder class] fromJSONArray:[result valueForKeyPath:@"data"] error:nil];
    //                [self.tableView reloadData];
    //                [_hud hide:YES];
    //            }else{
    //                [_hud show:YES];
    //                _hud.mode = MBProgressHUDModeText;
    //                _hud.labelText = @"暂无相关订单";
    //                [_hud hide:YES afterDelay:2];
    //
    //                _orderList = [NSMutableArray array];
    //                [_tableView reloadData];
    //            }
    //
    //        }else{
    //            [_hud show:YES];
    //            _hud.mode = MBProgressHUDModeText;
    //            _hud.labelText = @"获取订单列表失败";
    //            [_hud hide:YES afterDelay:2];
    //
    //            _orderList = [NSMutableArray array];
    //            [_tableView reloadData];
    //        }
    //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //        [_hud show:YES];
    //        _hud.mode = MBProgressHUDModeText;
    //        _hud.labelText = @"获取订单列表失败";
    //        [_hud hide:YES afterDelay:2];
    //
    //        _orderList = [NSMutableArray array];
    //        [_tableView reloadData];
    //    }];
    
}


- (IBAction)guangguangAction:(id)sender {
    [self getAppDelegate].tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)footerButtonClick:(UIButton *)button{
    NSString * titleStr = button.titleLabel.text;
    //    HFSOrder * selOrder = _orderList[button.tag - 1];
    
    if ([titleStr isEqualToString:@"取消"]) { //取消订单操作
        NSLog(@"取消订单%ld",button.tag - 1);
        MLOrderListModel *order = [_orderList objectAtIndex:button.tag - 1];
        
        UIAlertController *cancelVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定取消该订单吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *doneAct = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *userId = [[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_USERID];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            NSString *url = [NSString stringWithFormat:@"%@Ajax/order/OrderForm.ashx?op=cancle&jlbh=%@&userid=%@",SERVICE_GETBASE_URL,order.JLBH?:@"",userId?:@""];
            
            [[HFSServiceClient sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSNumber *result = [responseObject objectForKey:@"SuccFlag"];
                if ([result isKindOfClass:[NSNumber class]]&&[result isEqualToNumber:@1]) { //取消成功
                    [_tableView.header beginRefreshing];
                }else{//取消失败
                    NSString *ErrorMsg = [responseObject objectForKey:@"ErrorMsg"]?:@"";
                    [_hud show:YES];
                    _hud.mode = MBProgressHUDModeText;
                    _hud.labelText = ErrorMsg;
                    [_hud hide:YES afterDelay:2];
                }
                

            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [_hud show:YES];
                _hud.mode = MBProgressHUDModeText;
                _hud.labelText = @"请求失败";
                [_hud hide:YES afterDelay:2];
            }];
        }];
        UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [cancelVc addAction:doneAct];
        [cancelVc addAction:cancelAct];
        [self presentViewController:cancelVc animated:YES completion:nil];

        
    } else if ([titleStr isEqualToString:@"订单跟踪"]){
//        NSLog(@"订单跟踪%ld",button.tag - 1);
//        MLLogisticsViewController * vc = [[MLLogisticsViewController alloc]init];
////                vc.orderId = selOrder.orderId;
////                vc.orderDelivery = selOrder.orderDelivery;
//        self.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
    } else if ([titleStr isEqualToString:@"确认收货"]){
        
        MLOrderListModel *order = [_orderList objectAtIndex:button.tag - 1];
        
        UIAlertController *cancelVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定收货？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *doneAct = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *userId = [[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_USERID];
            [[NSUserDefaults standardUserDefaults]synchronize];
            NSString *url = [NSString stringWithFormat:@"%@Ajax/order/OrderForm.ashx?op=qrsh&userid=%@&jlbh=%@",SERVICE_GETBASE_URL,userId,order.JLBH];
            [[HFSServiceClient sharedClient]GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSLog(@"%@",responseObject);
                NSNumber *result = [responseObject objectForKey:@"SuccFlag"];
                
                if ([result isKindOfClass:[NSNumber class]]&&[result isEqualToNumber:@1]) { //收货成功
                    [_hud show:YES];
                    _hud.mode = MBProgressHUDModeText;
                    _hud.labelText = @"操作成功";
                    [_hud hide:YES afterDelay:2];
                    [_tableView.header beginRefreshing];
                }
                else{
                    [_hud show:YES];
                    _hud.mode = MBProgressHUDModeText;
                    _hud.labelText = @"删除失败";
                    [_hud hide:YES afterDelay:2];
                }

            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [_hud show:YES];
                _hud.mode = MBProgressHUDModeText;
                _hud.labelText = @"请求失败";
                [_hud hide:YES afterDelay:2];
            }];
            
        }];
        UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [cancelVc addAction:doneAct];
        [cancelVc addAction:cancelAct];
        [self presentViewController:cancelVc animated:YES completion:nil];
        
        
        
        
    }else if ([titleStr isEqualToString:@"付款"]){ //付款
        
        MLOrderListModel *order = [_orderList objectAtIndex:button.tag - 1];
        MLPayViewController *vc = [[MLPayViewController alloc]init];
        vc.orderDetail = order;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([titleStr isEqualToString:@"删除订单"]){//删除订单
        MLOrderListModel *order = [_orderList objectAtIndex:button.tag - 1];
        
        UIAlertController *cancelVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定删除该订单吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *doneAct = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *userId = [[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_USERID];
            [[NSUserDefaults standardUserDefaults]synchronize];
            NSString *url = [NSString stringWithFormat:@"%@Ajax/order/OrderForm.ashx?op=delete&jlbh=%@&userid=%@",SERVICE_GETBASE_URL,order.JLBH,userId?:@""];
            
            NSLog(@"%@",url);
            [[HFSServiceClient sharedClient]GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSNumber *result = [responseObject objectForKey:@"SuccFlag"];
                
                if ([result isKindOfClass:[NSNumber class]]&&[result isEqualToNumber:@1]) { //删除成功
                    [_tableView.header beginRefreshing];
                }
                else{
                    [_hud show:YES];
                    _hud.mode = MBProgressHUDModeText;
                    _hud.labelText = @"删除失败";
                    [_hud hide:YES afterDelay:2];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [_hud show:YES];
                _hud.mode = MBProgressHUDModeText;
                _hud.labelText = @"请求失败";
                [_hud hide:YES afterDelay:2];
            }];

            }];
        UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [cancelVc addAction:doneAct];
        [cancelVc addAction:cancelAct];
        [self presentViewController:cancelVc animated:YES completion:nil];

        
        
    }
}


#pragma mark - UITableViewDataSource and UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _orderList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    MLOrderListModel *order = [_orderList objectAtIndex:section];
    if (order.isMore) {//如果有更多数据
        //已经展开和非展开状态
        return order.isOpen?order.PRODUCTLIST.count+1:3;
    }
    return order.PRODUCTLIST.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MLOrderListModel *order = _orderList[indexPath.section];
    if (order.isMore && !order.isOpen) {
        //        return 3;
        if (indexPath.row == 2) {//最后一行显示更多的cell
            return [self morecellFrom:tableView AndIndexPath:indexPath];
        }else{
            return [self cellFrom:tableView AndIndexPath:indexPath];
        }
        
    }
    else if (order.isOpen&& order.isMore){
        //        return [dic[@"list"] count] + 1;
        if (indexPath.row == order.PRODUCTLIST.count) {//最后一行显示隐藏的cell
            return [self morecellFrom:tableView AndIndexPath:indexPath];
        }else{
            return [self cellFrom:tableView AndIndexPath:indexPath];
        }
    }else{//没有更多
        return [self cellFrom:tableView AndIndexPath:indexPath];
    }
    
}

- (UITableViewCell *)cellFrom:(UITableView *)tableView AndIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = CELL_IDENTIFIER;
    HFSProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[HFSProductTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    MLOrderListModel *order = _orderList[indexPath.section];
    cell.product = [order.PRODUCTLIST objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.numLabel.hidden = NO;
    cell.tisLabel.hidden = YES;
    return cell;
}

- (UITableViewCell *)morecellFrom:(UITableView *)tableView AndIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"MLMoreTableViewCell" ;
    MLMoreTableViewCell *cell = (MLMoreTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    MLOrderListModel *order = _orderList[indexPath.section];
    if (!order.isOpen) {
//        cell.moreButton.selected = NO;
        [cell.moreButton setTitle:[NSString stringWithFormat:@"还有%ld件  ",order.PRODUCTLIST.count - 2] forState:UIControlStateNormal];
        [cell.moreButton setImage:[UIImage imageNamed:@"Left_Arrow_yuan2"] forState:UIControlStateNormal];
        [cell.moreButton setImage:[UIImage imageNamed:@"Left_Arrow_yuan2"] forState:UIControlStateHighlighted];
    }
    else{
        [cell.moreButton setTitle:@"点击收回" forState:UIControlStateNormal];
        [cell.moreButton setImage:[UIImage imageNamed:@"Left_Arrow_yuan"] forState:UIControlStateNormal];
        [cell.moreButton setImage:[UIImage imageNamed:@"Left_Arrow_yuan"] forState:UIControlStateHighlighted];
    }
    cell.moreButton.tag = indexPath.section;
    [cell.moreButton addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)moreButtonAction:(id)sender{
    
    UIButton* button = ((UIButton *)sender);
//    NSString * moreStr = @"NO";
    MLOrderListModel *order = _orderList[button.tag];
    order.isOpen = !order.isOpen;
//    if (order.isOpen) {
//        [button setImage:[UIImage imageNamed:@"Left_Arrow_yuan"] forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:@"Left_Arrow_yuan"] forState:UIControlStateHighlighted];
//        
//    }
//    else{
//        [button setImage:[UIImage imageNamed:@"Left_Arrow_yuan2"] forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:@"Left_Arrow_yuan2"] forState:UIControlStateHighlighted];
//    }
//  
    [_orderList replaceObjectAtIndex:button.tag withObject:order];
    [_tableView reloadData];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MLOrderListModel *order = _orderList[indexPath.section];
    
    if (order.isMore && !order.isOpen) {
        if (indexPath.row == 2) {//最后一行显示更多的cell
            return 30.0f;
        }else{
            return 95.0f;
        }
        
    }else if (order.isMore && order.isOpen){
        
        if (indexPath.row == order.PRODUCTLIST.count) {//最后一行显示隐藏的cell
            return 30.0f;
        }else{
            return 95.0f;
        }
    }else{//没有更多
        return 95.0f;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 36.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 46.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    HFSOrderListHeaderView *headerView = [[HFSOrderListHeaderView alloc]initWithReuseIdentifier:HEADER_IDENTIFIER];
    //    HFSOrder *order = _orderList[section];
    MLOrderListModel *order = _orderList[section];
    headerView.orderStatusLabel.text = order.YHSTATUS;
    
//    NSString *typeStr = dic[@"type"];
//    
//    if ([@"UNPAID" isEqualToString:typeStr]) {
//        headerView.orderStatusLabel.text = @"待付款";
//    }else if([@"ONSHIP" isEqualToString:typeStr]) {
//        headerView.orderStatusLabel.text = @"待发货";
//    }else if([@"SIPN" isEqualToString:typeStr]) {
//        headerView.orderStatusLabel.text = @"待收货";
//    }else if([@"ACCEPT" isEqualToString:typeStr]){
//        headerView.orderStatusLabel.text = @"交易成功";
//    }else if([@"CLOSE" isEqualToString:typeStr]){
//        headerView.orderStatusLabel.text = @"交易关闭";
//    }else if([@"DELETE" isEqualToString:typeStr]){
//        headerView.orderStatusLabel.text = @"退款/换货";
//    }
    
    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    HFSOrderListFooterView *footerView = [[HFSOrderListFooterView alloc]initWithReuseIdentifier:FOOTER_IDENTIFIER];
    
    footerView.mainButton.layer.cornerRadius = 3;
    footerView.mainButton.layer.borderColor = [UIColor colorWithHexString:@"#C9C9C9"].CGColor;
    footerView.mainButton.layer.borderWidth = 1;
    footerView.mainButton.tag = section + 1;
    [footerView.mainButton addTarget:self action:@selector(footerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    footerView.otherButton.layer.cornerRadius = 3;
    footerView.otherButton.layer.borderWidth = 1;
    footerView.otherButton.layer.borderColor = [UIColor colorWithHexString:@"#C9C9C9"].CGColor;
    footerView.otherButton.tag = section + 1;
    [footerView.otherButton addTarget:self action:@selector(footerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    MLOrderListModel *order = _orderList[section];
    footerView.paidAmount = [NSNumber numberWithFloat:order.DDJE];
    
    if ([order.YHSTATUS isEqualToString:@"待付款"]) {
        footerView.mainButton.hidden = NO;
        footerView.otherButton.hidden = NO;
        [footerView.mainButton setTitle:@"付款" forState:UIControlStateNormal];
        [footerView.otherButton setTitle:@"取消" forState:UIControlStateNormal];
    }
    else if ([order.YHSTATUS isEqualToString:@"待收货"]){
        footerView.mainButton.hidden = NO;
        footerView.otherButton.hidden = YES;
        [footerView.mainButton setTitle:@"确认收货" forState:UIControlStateNormal];
        
    }else if ([order.YHSTATUS isEqualToString:@"交易成功"]){
        footerView.mainButton.hidden = NO;
        footerView.otherButton.hidden = NO;
        [footerView.mainButton setTitle:@"评价" forState:UIControlStateNormal];
        [footerView.otherButton setTitle:@"退货" forState:UIControlStateNormal];
    }else if ([order.YHSTATUS isEqualToString:@"交易关闭"]){
        [footerView.mainButton setTitle:@"删除订单" forState:UIControlStateNormal];
        footerView.otherButton.hidden = YES;
    }else if([order.YHSTATUS isEqualToString:@"待发货"]){
        [footerView.mainButton setTitle:@"取消" forState:UIControlStateNormal];
        footerView.otherButton.hidden = YES;
    }else if ([order.YHSTATUS isEqualToString:@"已取消"]){
         [footerView.mainButton setTitle:@"删除订单" forState:UIControlStateNormal];
        footerView.otherButton.hidden = YES;
    }else if ([order.YHSTATUS isEqualToString:@"已完成"]){
        footerView.mainButton.hidden = YES;
        footerView.otherButton.hidden = YES;
    }
    
    return footerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MLOrderInfoViewController*vc = [[MLOrderInfoViewController alloc]init];
    vc.order = _orderList[indexPath.section];
    __weak typeof(self) weakself = self;
    vc.orderInfoBlock = ^(){
        [weakself.tableView.header beginRefreshing];
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"操作成功";
        [_hud hide:YES afterDelay:2];
    };
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}





@end
