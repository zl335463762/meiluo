//
//  MLOrderInfoViewController.m
//  Matro
//
//  Created by NN on 16/3/25.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLOrderInfoViewController.h"

#import "MLListViewController.h"
#import "MLPayViewController.h"
#import "MLZTTableViewCell.h"
#import "MLTisTableViewCell.h"
#import "MLAddTableViewCell.h"
#import "HFSOrderInfoTableViewCell.h"
#import "HFSProductTableViewCell.h"
#import "MLMoreTableViewCell.h"
#import "MLRPayTableViewCell.h"
#import "HFSConstants.h"
#import "HFSServiceClient.h"
#import "HFSUtility.h"
#import "MLProductModel.h"
#import "MLLogisticsViewController.h"
#import "HFSOrderListHeaderView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MJExtension.h"

#define HEADER_IDENTIFIER @"OrderListHeaderIdentifier"

@interface MLOrderInfoViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *titleArray;
    NSMutableArray *productList;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *daishouhuoBgView;
@property (strong, nonatomic) IBOutlet UIView *daifukuanBgView;
@property (strong, nonatomic) IBOutlet UIView *quxiaoBgView;
@property (strong, nonatomic) IBOutlet UIView *daifahuoBgView;
@property (strong, nonatomic) IBOutlet UIView *yiwanchengBgView;
@property (strong, nonatomic) IBOutlet UIView *tuikuanhuanhuoBgView;
@property (weak, nonatomic) IBOutlet UIView *bg_view;

@property (nonatomic,strong)MLOrderListModel *downOrder;


@end

@implementation MLOrderInfoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"订单详情";
    
    [_tableView registerNib:[UINib nibWithNibName:@"HFSOrderListHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:HEADER_IDENTIFIER];
//    NSString *typeStr = _detaDic[@"type"];
    
    
    
    productList = [NSMutableArray new];
    if (_order.PRODUCTLIST && _order.PRODUCTLIST.count>0) {
        [productList addObjectsFromArray:_order.PRODUCTLIST];
    }
    
    if ([_order.YHSTATUS isEqualToString:@"已完成"]) {
        _bg_view.hidden = YES;
    }
    
    [self downLoadOrderDetail];
}
- (void)downLoadOrderDetail {
    NSString *userId = [[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_USERID];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@Ajax/order/OrderDetail.ashx?op=orderdetail&jlbh=%@&tpgg=M&userid=%@",SERVICE_GETBASE_URL,_order.JLBH?:@"",userId?:@""];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[HFSServiceClient sharedClientNOT] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"订单详情 请求成功");
        _downOrder = [MLOrderListModel mj_objectWithKeyValues:responseObject];
        NSString *titleTis = @"";
        
        if ([_order.YHSTATUS isEqualToString:@"待付款"]) {
            titleTis = @"待付款";
            //增加付款倒计时
            NSString *ordertime = [NSString stringWithFormat:@"%@",_downOrder.DHRQ];
            NSDateFormatter*df = [[NSDateFormatter alloc]init];//格式化
            [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate* date = [df dateFromString:ordertime];
            NSDate *currentdate = [NSDate date];
            
            [self compareDate:date currentDate:currentdate];
            
            
            
        }
        else if ([_order.YHSTATUS isEqualToString:@"待收货"]){
            titleTis = @"待发货";
            _daifahuoBgView.hidden = NO;
        }else if ([_order.YHSTATUS isEqualToString:@"交易成功"]){
            titleTis = @"交易成功";
            _daifahuoBgView.hidden = NO;
        }else if ([_order.YHSTATUS isEqualToString:@"已取消"]){
            titleTis = @"交易关闭";
            _quxiaoBgView.hidden = NO;
        }else if([_order.YHSTATUS isEqualToString:@"待发货"]){
            titleTis = @"待发货";
            _daifahuoBgView.hidden = NO;
        }
        //订单信息绑定数据，可以通过⬇️下方数组来修改
        titleArray = @[
                       @[titleTis],
                       @[_order.FKQKMC,[NSString stringWithFormat:@"%@%@",_order.DZFJZSJ,_order.DZFSYSJ]],
                       @{
                           @"name":_downOrder.SHRMC?:@"",
                           @"phone":_downOrder.SHRMPHONE?:@"",
                           @"address":_downOrder.SHRADDRESS?:@""
                           },
                       @[],
                       @[@"支付方式",@"配送方式",@"发票信息",@"发票信息/抬    头：/内    容："],
                       @[@"商品总额：/优    惠：/运    费：",[NSString stringWithFormat:@"￥%.2f/-￥0/+%.2f",_downOrder.XSJE,_downOrder.PSJE]],
                       @[[NSString stringWithFormat:@"下单时间：/%@",[NSString stringWithFormat:@"%@",_downOrder.DHRQ]],[NSString stringWithFormat:@"订单编号：/%@",_downOrder.JLBH?:@""]]
                       ];
        [self.tableView reloadData];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"订单详情 请求失败");
    }];
}

-(void)compareDate:(NSDate*)startdate currentDate:(NSDate*)endDate
{
    float restm =  [endDate timeIntervalSinceDate:startdate ];
    if (restm/60/60>2) { //小时
        self.bottomView.hidden = YES;
        _daifukuanBgView.hidden = YES;
        self.bottomHeight.constant = 0;
    }
    else{
        self.bottomView.hidden = NO;
        _daifukuanBgView.hidden = NO;
        self.bottomHeight.constant = 45;
        [self startTime:restm];
    }
}
-(void)startTime:(float)resttime{
    __block int timeout=resttime; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.bottomView.hidden = YES;

            });
        }else{
            //format of hour
            NSString *str_hour = [NSString stringWithFormat:@"%02d",timeout/3600];
            //format of minute
            NSString *str_minute = [NSString stringWithFormat:@"%02d",(timeout%3600)/60];
            //format of second
            NSString *str_second = [NSString stringWithFormat:@"%02d",timeout%60];
            //format of time
            NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                
                self.restPaytime.text = format_time;
                [UIView commitAnimations];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)moreButtonAction:(id)sender{ //点击更多按钮事件
    
//    UIButton* button = ((UIButton *)sender);
//    NSString * moreStr = @"NO";
//    if (button.selected) {//展开状态的点击事件
//        moreStr = @"NO";
//    }else{//展开
//        moreStr = @"YES";
//    }
//    
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:_orderList[button.tag]];
//    [dic setObject:moreStr forKey:@"more"];
//    [_orderList replaceObjectAtIndex:button.tag withObject:dic];
//    [_tableView reloadData];
    MLListViewController *vc = [[MLListViewController alloc]init];
//    vc.postListArray = @[@"",@"",@"",@"",@"",@"",@"",];
    vc.orderDetail = self.order;
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark 订单处理操作
- (IBAction)toolButtonAction:(id)sender {
    
    NSString *typeStr = ((UIButton *)sender).titleLabel.text;
    NSString *urlStr;
    if ([typeStr isEqualToString:@"确认收货"]) {//确认收货
        UIAlertController *cancelVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定收货？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *doneAct = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *userId = [[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_USERID];
            [[NSUserDefaults standardUserDefaults]synchronize];
            NSString *url = [NSString stringWithFormat:@"%@Ajax/order/OrderForm.ashx?op=qrsh&userid=%@&jlbh=%@",SERVICE_GETBASE_URL,userId,_order.JLBH?:@""];
            [[HFSServiceClient sharedClient]GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSLog(@"%@",responseObject);
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
    }else if ([typeStr isEqualToString:@"订单跟踪"]){//订单追踪
//        MLLogisticsViewController *vc = [[MLLogisticsViewController alloc]init];
//        self.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
//        return;
    }else if ([typeStr isEqualToString:@"付款"]){//付款
        urlStr = [NSString stringWithFormat:@""];
        MLPayViewController *vc = [[MLPayViewController alloc]init];
        vc.orderDetail = self.order;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }else if ([typeStr isEqualToString:@"取消"]){//取消
        UIAlertController *cancelVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定取消该订单吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *doneAct = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *userId = [[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_USERID];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            NSString *url = [NSString stringWithFormat:@"%@Ajax/order/OrderForm.ashx?op=cancle&jlbh=%@&userid=%@",SERVICE_GETBASE_URL,_order.JLBH?:@"",userId?:@""];
            NSLog(@"%@",url);
            
            [[HFSServiceClient sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSNumber *result = [responseObject objectForKey:@"SuccFlag"];
                if ([result isKindOfClass:[NSNumber class]]&&[result isEqualToNumber:@1]) { //取消成功
                    [_hud show:YES];
                    _hud.mode = MBProgressHUDModeText;
                    _hud.labelText = @"取消成功";
                    [_hud hide:YES afterDelay:2];
                    self.orderInfoBlock();
                    [self.navigationController popViewControllerAnimated:YES];
                    
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
        
    }
    else if ([typeStr isEqualToString:@"删除"]){ //订单删除 接口有问题
        
        UIAlertController *cancelVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定删除该订单吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *doneAct = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *userId = [[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_USERID];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            NSString *url = [NSString stringWithFormat:@"%@Ajax/order/OrderForm.ashx?op=delete&jlbh=%@&userid=%@",SERVICE_GETBASE_URL,_order.JLBH,userId];
            [[HFSServiceClient sharedClient]GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                self.orderInfoBlock();
                [self.navigationController popViewControllerAnimated:YES];
                
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
       
        
        
    }else if ([typeStr isEqualToString:@"评价"]){
        urlStr = [NSString stringWithFormat:@""];
    }else if ([typeStr isEqualToString:@"退货"]){
        urlStr = [NSString stringWithFormat:@""];
    }
    
}



#pragma mark - UITableViewDataSource and UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 3) {
        return 30;
    }else{
        return 5;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 6) {
        return 45;
    }else if (section == 2){
        return 5;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return 30;
            break;
        case 1:
            return 60;
            break;
        case 2:
            return 80;
            break;
        case 3:
            if (indexPath.row == 2) {
                return 30;
            }else{
                return 95;
            }
            break;
        case 4:
            if (indexPath.row == 3) {
                return 80;
            }else{
                return 30;
            }
            break;
        case 5:
            if (indexPath.row == 0) {
                return 80;
            }else{
                return 30;
            }
            break;
        default:
            return 30;
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    if (section < 3) {
        return 1;
    }else if (section == 3){
        return productList.count;
    }else if (section == 4){
        return 4;
    }else{
        return 2;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 3) {
        HFSOrderListHeaderView *headerView = [[HFSOrderListHeaderView alloc]initWithReuseIdentifier:HEADER_IDENTIFIER];
        headerView.orderStatusLabel.hidden = YES;
        headerView.nameLabel.text = @"商品清单";
        return headerView;
    }else{
        return [[UIView alloc]init];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    
    switch (indexPath.section) {
        case 0:{//订单状态
            static NSString *CellIdentifier = @"MLZTTableViewCell" ;
            MLZTTableViewCell *cell = (MLZTTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
                cell = [array objectAtIndex:0];
            }
            cell.ztLabel.text = [titleArray[indexPath.section] firstObject];
            return cell;
        }
            break;
        case 1:{//订单追踪
            static NSString *CellIdentifier = @"MLTisTableViewCell" ;
            MLTisTableViewCell *cell = (MLTisTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
                cell = [array objectAtIndex:0];
            }
            cell.tisLabel.text = [titleArray[indexPath.section] firstObject];
            cell.timeLabel.text = [titleArray[indexPath.section] lastObject];
            return cell;
        }
            break;
        case 2:{//地址
            static NSString *CellIdentifier = @"MLAddTableViewCell" ;
            MLAddTableViewCell *cell = (MLAddTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
                cell = [array objectAtIndex:0];
            }
            NSDictionary *dic = titleArray[indexPath.section];
            cell.nameLabel.text = dic[@"name"];
            cell.phoneLabel.text = dic[@"phone"];
            cell.addressLabel.text = dic[@"address"];
            
            return cell;
        }
            break;
        case 3:{//清单
            
            if (indexPath.row == 2) {
                static NSString *CellIdentifier = @"MLMoreTableViewCell" ;
                MLMoreTableViewCell *cell = (MLMoreTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
                    cell = [array objectAtIndex:0];
                }
                    cell.moreButton.selected = NO;
                NSUInteger restcount = productList.count-2;
                    [cell.moreButton setTitle:[NSString stringWithFormat:@"还有%lu件  ",(unsigned long)restcount] forState:UIControlStateNormal];
                [cell.moreButton addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                
                return cell;

            }else{
                MLProductModel *dic = productList[indexPath.row];
                static NSString *CellIdentifier = @"HFSProductTableViewCell" ;
                HFSProductTableViewCell *cell = (HFSProductTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
                    cell = [array objectAtIndex:0];
                }
                [cell.productImageView sd_setImageWithURL:[NSURL URLWithString:dic.IMGURL] placeholderImage:[UIImage imageNamed:@""]];
                cell.productNameLabel.text = dic.SPNAME;
                cell.currentPriceLabel.text =[NSString stringWithFormat:@"￥%.2f",dic.LSDJ] ;
                cell.tisLabel.hidden = YES;
                return cell;
            }
            
        }
            break;
        case 4:{//方式
            static NSString *CellIdentifier = @"HFSOrderInfoTableViewCell" ;
            HFSOrderInfoTableViewCell *cell = (HFSOrderInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
                cell = [array objectAtIndex:0];
            }
            
            //设置行间距
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineSpacing = 5;
            paragraphStyle.alignment = NSTextAlignmentLeft;
            NSDictionary *attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:paragraphStyle,};
            
            NSString *temStr = titleArray[indexPath.section][indexPath.row];
            
            if(indexPath.row == 3){
                NSArray *tempArr = [temStr pathComponents];
                cell.lLabel.attributedText = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n%@\n%@",tempArr[0],tempArr[1],tempArr[2]] attributes:attributes];
                cell.rLabel.attributedText = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@" \n%@\n%@",_order.FPTT?:@"",_order.FPNR?:@""] attributes:attributes];

            }else{
                cell.lLabel.text = temStr;
                if (indexPath.row == 0) {
                    cell.rLabel.text = _order.FKFSMC?:@"";
                }
                else if (indexPath.row== 1){
                    cell.rLabel.text = _downOrder.PSFSMC?
                    :@"";
                }
                else if (indexPath.row == 2){
                    cell.rLabel.text = @"";
                }
            }
            
            return cell;
        }
            break;
        case 5:{//钱
            
            if(indexPath.row == 0){
                static NSString *CellIdentifier = @"HFSOrderInfoTableViewCell" ;
                HFSOrderInfoTableViewCell *cell = (HFSOrderInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
                    cell = [array objectAtIndex:0];
                }
                //设置行间距
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                paragraphStyle.lineSpacing = 5;
                paragraphStyle.alignment = NSTextAlignmentLeft;
                NSDictionary *attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:paragraphStyle,};
                
                NSString *temStr01 = [titleArray[indexPath.section] firstObject];
                NSArray *tempArr01 = [temStr01 pathComponents];
                
                NSString *temStr02 = [titleArray[indexPath.section] lastObject];
                NSArray *tempArr02 = [temStr02 pathComponents];
                
                cell.lLabel.attributedText = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n%@\n%@",tempArr01[0],tempArr01[1],tempArr01[2]] attributes:attributes];
                
                paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                paragraphStyle.alignment = NSTextAlignmentRight;
                paragraphStyle.lineSpacing = 5;
                attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:paragraphStyle,};
                
                cell.rLabel.attributedText = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n%@\n%@",tempArr02[0],tempArr02[1],tempArr02[2]] attributes:attributes];
                
                return cell;
            }else{
                static NSString *CellIdentifier = @"MLRPayTableViewCell" ;
                MLRPayTableViewCell *cell = (MLRPayTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
                    cell = [array objectAtIndex:0];
                }
                cell.rpayLabel.text = [NSString stringWithFormat:@"%.2f",_downOrder.TOTLEJE];
                return cell;
            }
        }
            break;
        default:{//时间和编号
            static NSString *CellIdentifier = @"HFSOrderInfoTableViewCell" ;
            HFSOrderInfoTableViewCell *cell = (HFSOrderInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
                cell = [array objectAtIndex:0];
            }
            
            NSString *tempStr = titleArray[indexPath.section][indexPath.row];
            NSArray *temArr = [tempStr pathComponents];
        
            cell.lLabel.text = temArr[0];
            cell.rLabel.text = temArr[1];
            return cell;
        }
            break;
    }
    
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
