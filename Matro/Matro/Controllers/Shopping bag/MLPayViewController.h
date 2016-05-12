//
//  MLPayViewController.h
//  Matro
//
//  Created by NN on 16/3/28.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"
#import "MLOrderListModel.h"

@interface MLPayViewController : MLBaseViewController
@property(nonatomic,retain) NSDictionary *paramDic;
//@property(nonatomic,retain) NSString *orderId;
@property (nonatomic,retain)MLOrderListModel *orderDetail;



@end
