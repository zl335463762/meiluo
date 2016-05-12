//
//  MLInvoiceViewController.h
//  Matro
//
//  Created by NN on 16/3/29.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"

@protocol InvoiceDelegate <NSObject>
- (void)InvoiceDic:(NSDictionary *)dic;
@end

@interface MLInvoiceViewController : MLBaseViewController

@property (nonatomic) BOOL isNeed;

@property (assign,nonatomic,readwrite)id <InvoiceDelegate>delegate;

@end
