//
//  MLAddressListViewController.h
//  Matro
//
//  Created by NN on 16/3/29.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"

@protocol AddressDelegate <NSObject>
- (void)AddressDic:(NSDictionary *)dic;
@end

@interface MLAddressListViewController : MLBaseViewController

@property (assign,nonatomic,readwrite)id <AddressDelegate>delegate;//通过是否有代理来确定是选择还是管理
@property (nonatomic,assign) BOOL hasCheck;
@end
