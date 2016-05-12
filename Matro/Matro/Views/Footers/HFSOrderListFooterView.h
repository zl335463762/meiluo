//
//  HFSOrderListFooterView.h
//  FashionShop
//
//  Created by 王闻昊 on 15/10/8.
//  Copyright © 2015年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HFSOrderListFooterView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UIButton *mainButton;
@property (weak, nonatomic) IBOutlet UIButton *otherButton;

@property (copy, nonatomic) NSNumber *paidAmount;
@end
