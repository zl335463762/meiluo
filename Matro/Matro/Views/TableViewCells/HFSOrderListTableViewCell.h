//
//  HFSOrderListTableViewCell.h
//  FashionShop
//
//  Created by 王闻昊 on 15/10/9.
//  Copyright © 2015年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HFSOrderListTableViewCell : UITableViewCell

@property (copy, nonatomic) NSURL *productImageURL;
@property (copy, nonatomic) NSString *productName;
@property (copy, nonatomic) NSNumber *productPrice;
@property (copy, nonatomic) NSNumber *productCount;

@end
