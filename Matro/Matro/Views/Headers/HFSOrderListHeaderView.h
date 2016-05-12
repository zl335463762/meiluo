//
//  HFSOrderListHeaderView.h
//  FashionShop
//
//  Created by 王闻昊 on 15/10/8.
//  Copyright © 2015年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HFSOrderListHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@end
