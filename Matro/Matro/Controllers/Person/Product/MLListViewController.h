//
//  MLListViewController.h
//  Matro
//
//  Created by NN on 16/3/26.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"
#import "MLOrderListModel.h"


@interface MLListViewController : MLBaseViewController

@property (nonatomic,strong) NSArray *postListArray;

@property (nonatomic,strong)MLOrderListModel *orderDetail;


@end
