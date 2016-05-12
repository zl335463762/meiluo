//
//  MLOrderInfoViewController.h
//  Matro
//
//  Created by NN on 16/3/25.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"
#import "MLOrderListModel.h"

typedef void(^OrderInfoBlock)();
@interface MLOrderInfoViewController : MLBaseViewController

@property (nonatomic) MLOrderListModel * order;
@property (nonatomic,copy)OrderInfoBlock orderInfoBlock;

@property (weak, nonatomic) IBOutlet UILabel *restPaytime;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;

@end
