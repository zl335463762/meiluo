//
//  MLBagFootView.h
//  Matro
//
//  Created by 陈文娟 on 16/5/1.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLBagFootView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLB;
@property (weak, nonatomic) IBOutlet UIButton *countToPay;
@property (weak, nonatomic) IBOutlet UILabel *totalShopCount;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
