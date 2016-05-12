//
//  MLPayViewController.m
//  Matro
//
//  Created by NN on 16/3/28.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLPayViewController.h"
#import "MLPayTableViewCell.h"
#import "AppDelegate.h"
#import "HFSConstants.h"
#import "UIColor+HeinQi.h"
#import "MLPayresultViewController.h"
#import "WXApi.h"
#import "UPPayPlugin.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AliPayOrder.h"
#import "HFSServiceClient.h"
#import "GTMNSString+URLArguments.h"
#import <PassKit/PassKit.h>

//#import <PassKit/PassKit.h>

@interface MLPayViewController ()<UITableViewDataSource,UITableViewDelegate,UPPayPluginDelegate
,PKPaymentAuthorizationViewControllerDelegate
>{
    NSMutableArray *_payTitleArray;
    NSMutableArray *_payImageArray;
}
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MLPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"收银台";
    
    UIBarButtonItem * button = [[UIBarButtonItem alloc]initWithTitle:@"我的订单" style:UIBarButtonItemStylePlain target:self action:@selector(productlistsAction)];
    button.tintColor = [UIColor colorWithHexString:@"AE8E5D"];
    self.navigationItem.rightBarButtonItem = button;
    
    
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f",_orderDetail.DDJE];
    

    _payImageArray = [NSMutableArray array];
    _payTitleArray = [NSMutableArray array];
    
    [_payTitleArray addObject:@"支付宝"];
    [_payImageArray addObject:@"zhifubao-1"];
    
//    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        [_payTitleArray addObject:@"微信支付"];
        [_payImageArray addObject:@"weixin"];
//    }
    
    [_payTitleArray addObject:@"银联支付"];
    [_payImageArray addObject:@"yinglian"];
    
    // 暂时隐藏
//    if([PKPaymentAuthorizationViewController canMakePayments]) {
//        [_payTitleArray addObject:@"Apple Pay"];
//        [_payImageArray addObject:@"applepay"];
//    }
    
    
    _tableView.tableFooterView = [[UIView alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)productlistsAction{
    
    if ([self getAppDelegate].tabBarController.selectedIndex == 3) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self getAppDelegate].tabBarController.selectedIndex = 3;
        [self.navigationController popToRootViewControllerAnimated:NO];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GOTO_ODRE_LISTS object:nil];
    }

}

#pragma mark- UITableViewDataSource And UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    return _payTitleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    
    static NSString *CellIdentifier = @"MLPayTableViewCell" ;
    MLPayTableViewCell *cell = (MLPayTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    cell.payImageView.image = [UIImage imageNamed:_payImageArray[indexPath.row]];
    cell.payLabel.text = _payTitleArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.row == 0) {
        [self alipayPost];
    }
    else{
        NSString *titleStr = [_payTitleArray objectAtIndex:indexPath.row];
        if ([titleStr isEqualToString:@"微信支付"]) {
            
//            if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
                [self wxPayPost];
//            }
//            else{
//                _hud.mode = MBProgressHUDModeText;
//                _hud.labelText = @"请安装微信";
//                [_hud hide:YES afterDelay:2];
//            }
            
        }
        else if ([titleStr isEqualToString:@"银联支付"]){
            [self upPayPost];
        }
        else if ([titleStr isEqualToString:@"Apple Pay"]){
            [self applepay];
        }
    }
    
}


-(void)alipayPost
{
    NSDictionary *dic = @{@"out_trade_no":_orderDetail.JLBH?:@"",
                          @"subject":@"美罗全球精品购",
                          @"body":@"美罗全球精品购",
                          @"total_fee":@"0.01"
//                          @"total_fee":[NSNumber numberWithFloat:_orderDetail.DDJE]?:@""
                          };
    
    
    [[HFSServiceClient sharedPayClient] POST:@"app/alipay" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *result = (NSDictionary *)responseObject;
        NSLog(@"result %@",result);
        
        if (result) {
            
            AliPayOrder *order = [[AliPayOrder alloc] init];
            order.partner = result[@"partner"];
            order.seller = result[@"seller_id"];
            order.tradeNO = result[@"out_trade_no"];
            order.productName = result[@"subject"];
            order.productDescription = result[@"body"];
            order.amount = @"0.01";
            order.notifyURL = result[@"notify_url"];
            order.service = result[@"service"];
            order.paymentType = result[@"payment_type"];
            order.inputCharset = result[@"_input_charset"];
            order.itBPay = result[@"it_b_pay"];
            
            
            
//            order.partner = @"2088121001447521";
//            order.seller = @"boshi@matrojp.com";
//            order.tradeNO = @"160021069";
//            order.productName = @"美罗全球精品购";
//            order.productDescription = @"美罗全球精品购";
//            order.amount = @"0.01";
//            order.notifyURL = @"http://app-test.matrojp.com/payment/AlipayResult.aspx";
//            order.service = result[@"service"];
//            order.paymentType = @"1";
//            order.inputCharset = @"utf-8";
//            order.itBPay = @"mobile.securitypay.pay";
            
            
            
            //将商品信息拼接成字符串
            NSString *orderSpec = [order description];
            NSString *signedString =result[@"sign"];
            //将签名成功字符串格式化为订单字符串,请严格按照该格式
            NSString *orderString = nil;
            NSString *appScheme = @"Matro";
            if (signedString != nil) {
                signedString = [signedString gtm_stringByEscapingForURLArgument];

                orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                               orderSpec, signedString, @"RSA"];
                NSLog(@"%@",orderString);
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    //【callback处理支付结果】
//                    [_hud show:YES];
//                    _hud.mode = MBProgressHUDModeText;
//                    _hud.labelText = resultDic[@"memo"];
//                    [_hud hide:YES afterDelay:2];
                    NSLog(@"reslut = %@",resultDic);
                }];
            }
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        NSLog(@"error kkkk %@",error);
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:2];
    }];
    
}

#pragma mark apple pay delegate
- (void)applepay
{
    // [Crittercism beginTransaction:@"checkout"];
    
    if([PKPaymentAuthorizationViewController canMakePayments]) {
        
        NSLog(@"Woo! Can make payments!");
        
        PKPaymentRequest *request = [[PKPaymentRequest alloc] init];
        
//        PKPaymentSummaryItem *widget1 = [PKPaymentSummaryItem summaryItemWithLabel:@"Widget 1"
//                                                                            amount:[NSDecimalNumber decimalNumberWithString:@"0.99"]];
//        
//        PKPaymentSummaryItem *widget2 = [PKPaymentSummaryItem summaryItemWithLabel:@"Widget 2"
//                                                                            amount:[NSDecimalNumber decimalNumberWithString:@"1.00"]];
        
        PKPaymentSummaryItem *total = [PKPaymentSummaryItem summaryItemWithLabel:@"总价"
                                                                          amount:[NSDecimalNumber decimalNumberWithString:@"0.01"]];
        
        request.paymentSummaryItems = @[ total];
        request.countryCode = @"CN";
        request.currencyCode = @"CHW";
        request.supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa];
        request.merchantIdentifier = @"merchant.MatroApplePay";
        request.merchantCapabilities = PKMerchantCapabilityEMV;
        
        PKPaymentAuthorizationViewController *paymentPane = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
        paymentPane.delegate = self;
        if (paymentPane) {
            [self presentViewController:paymentPane animated:TRUE completion:nil];

        }
        else{
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"请先绑定您的银行卡";
            [_hud hide:YES afterDelay:2];
        }
        
    } else {
        NSLog(@"This device cannot make payments");
    }
}

#pragma mark apple pay delegate
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus status))completion
{
    NSLog(@"Payment was authorized: %@", payment);
    
    // do an async call to the server to complete the payment.
    // See PKPayment class reference for object parameters that can be passed
    BOOL asyncSuccessful = FALSE;
    
    // When the async call is done, send the callback.
    // Available cases are:
    //    PKPaymentAuthorizationStatusSuccess, // Merchant auth'd (or expects to auth) the transaction successfully.
    //    PKPaymentAuthorizationStatusFailure, // Merchant failed to auth the transaction.
    //
    //    PKPaymentAuthorizationStatusInvalidBillingPostalAddress,  // Merchant refuses service to this billing address.
    //    PKPaymentAuthorizationStatusInvalidShippingPostalAddress, // Merchant refuses service to this shipping address.
    //    PKPaymentAuthorizationStatusInvalidShippingContact        // Supplied contact information is insufficient.
    
    if(asyncSuccessful) {
        completion(PKPaymentAuthorizationStatusSuccess);
        
        // do something to let the user know the status
        
        NSLog(@"Payment was successful");
        
        //        [Crittercism endTransaction:@"checkout"];
        
    } else {
        completion(PKPaymentAuthorizationStatusFailure);
        
        // do something to let the user know the status
        
        NSLog(@"Payment was unsuccessful");
        
        //        [Crittercism failTransaction:@"checkout"];
    }
    
}

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
    NSLog(@"Finishing payment view controller");
    
    // hide the payment window
    [controller dismissViewControllerAnimated:TRUE completion:nil];
}



#pragma mark wxPay

- (void)wxPayPost{
    NSDictionary *dict = @{@"orderid":_orderDetail.JLBH?:@"",@"goods_name":@"美罗全球购",@"totalfee":[NSNumber numberWithFloat:_orderDetail.DDJE]?:@"",@"ip":@"",@"wxid":@"6"};
    NSLog(@"%@",dict);
    
    
    [[HFSServiceClient sharedPayClient] POST:@"app/wxpay" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *data = (NSDictionary *)responseObject;
        NSString *noncestr = [data objectForKey:@"noncestr"];
        NSString *partnerid = [data objectForKey:@"partnerid"];
        NSString *prepayid = [data objectForKey:@"prepayid"];
        NSString *timestamp = [data objectForKey:@"timestamp"];
        NSString *sign = [data objectForKey:@"sign"];
        NSString *package = [data objectForKey:@"package"];
        
        PayReq *req             = [[PayReq alloc] init];
        req.partnerId           = partnerid;
        req.prepayId            = prepayid;
        req.nonceStr            = noncestr;
        req.timeStamp           = [timestamp intValue];
        req.package             = package;
        req.sign                = sign;
        [WXApi sendReq:req];

        NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        NSLog(@"error kkkk %@",error);
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:2];
    }];
    
}


#pragma mark 银联支付
- (void)upPayPost{
    NSDictionary *dict = @{@"txnAmt":@"0.01",@"orderId":@"12321312",@"orderDesc":@"美罗全球购"};
    [[HFSServiceClient sharedPayClient]POST:@"app/unionpay" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *tn = [responseObject objectForKey:@"tn"];
        [UPPayPlugin startPay:tn mode:@"00" viewController:self delegate:self];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        NSLog(@"error kkkk %@",error);
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:2];
    }];

}




#pragma mark - UPPayPluginDelegate
-(void)UPPayPluginResult:(NSString *)result {
    NSLog(@"%@", result);
    
    if ([result isEqualToString:@"success"]) {
        
    } else if ([result isEqualToString:@"fail"]) {
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"付款失败";
        [_hud show:YES];
        [_hud hide:YES afterDelay:1];
    } else if ([result isEqualToString:@"cancel"]) {
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"付款被取消";
        [_hud show:YES];
        [_hud hide:YES afterDelay:1];
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
