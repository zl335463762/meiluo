//
//  AliPayOrder.m
//  CrabPrince
//
//  Created by 王闻昊 on 15/8/25.
//  Copyright (c) 2015年 HeinQi. All rights reserved.
//

#import "AliPayOrder.h"

@implementation AliPayOrder

- (NSString *)description {
    NSMutableString * discription = [NSMutableString string];
    if (self.inputCharset) {
        [discription appendFormat:@"_input_charset=\"%@\"",self.inputCharset];//utf-8
    }
    if (self.productDescription) {
        [discription appendFormat:@"&body=\"%@\"", self.productDescription];
    }
    
    if (self.itBPay) {
        [discription appendFormat:@"&it_b_pay=\"%@\"",self.itBPay];//30m
    }
    if (self.notifyURL) {
        [discription appendFormat:@"&notify_url=\"%@\"", self.notifyURL];
    }
    if (self.tradeNO) {
        [discription appendFormat:@"&out_trade_no=\"%@\"", self.tradeNO];
    }
    if (self.partner) {
        [discription appendFormat:@"&partner=\"%@\"", self.partner];
    }
    if (self.paymentType) {
        [discription appendFormat:@"&payment_type=\"%@\"",self.paymentType];//1
    }
    if (self.seller) {
        [discription appendFormat:@"&seller_id=\"%@\"", self.seller];
    }
    if (self.service) {
        [discription appendFormat:@"&service=\"%@\"",self.service];//mobile.securitypay.pay
    }
    if (self.productName) {
        [discription appendFormat:@"&subject=\"%@\"", self.productName];
    }
    if (self.amount) {
        [discription appendFormat:@"&total_fee=\"%@\"", self.amount];
    }
    
    
   
   
   
    
   
    
   
    
    
   
    
   
    if (self.showUrl) {
        [discription appendFormat:@"&show_url=\"%@\"",self.showUrl];//m.alipay.com
    }
    if (self.rsaDate) {
        [discription appendFormat:@"&sign_date=\"%@\"",self.rsaDate];
    }
    if (self.appID) {
        [discription appendFormat:@"&app_id=\"%@\"",self.appID];
    }
    for (NSString * key in [self.extraParams allKeys]) {
        [discription appendFormat:@"&%@=\"%@\"", key, [self.extraParams objectForKey:key]];
    }
    return discription;
}

- (NSDictionary *)descriptionDict {
    NSMutableDictionary *descriptionDict = [NSMutableDictionary dictionary];
    if (self.partner) {
        [descriptionDict setValue:self.partner forKey:@"partner"];
    }
    if (self.seller) {
        [descriptionDict setValue:self.seller forKey:@"seller_id"];
    }
    if (self.tradeNO) {
        [descriptionDict setValue:self.tradeNO forKey:@"out_trade_no"];
    }
    if (self.productName) {
        [descriptionDict setValue:self.productName forKey:@"subject"];
    }
    if (self.productDescription) {
        [descriptionDict setValue:self.productDescription forKey:@"body"];
    }
    if (self.amount) {
        [descriptionDict setValue:self.amount forKey:@"total_fee"];
    }
    if (self.notifyURL) {
        [descriptionDict setValue:self.notifyURL forKey:@"notify_url"];
    }
    if (self.service) {
        [descriptionDict setValue:self.service forKey:@"service"];
    }
    if (self.paymentType) {
        [descriptionDict setValue:self.paymentType forKey:@"payment_type"];
    }
    if (self.inputCharset) {
        [descriptionDict setValue:self.inputCharset forKey:@"_input_charset"];
    }
    if (self.itBPay) {
        [descriptionDict setValue:self.itBPay forKey:@"it_b_pay"];
    }
    if (self.showUrl) {
        [descriptionDict setValue:self.showUrl forKey:@"show_url"];
    }
    if (self.rsaDate) {
        [descriptionDict setValue:self.rsaDate forKey:@"sign_date"];
    }
    if (self.appID) {
        [descriptionDict setValue:self.appID forKey:@"app_id"];
    }
    for (NSString *key in self.extraParams.allKeys) {
        [descriptionDict setValue:[self.extraParams objectForKey:key] forKey:key];
    }
    
    return descriptionDict;
}

@end
