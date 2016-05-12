//
//  MLBagGoodsTableViewCell.h
//  Matro
//
//  Created by hyk on 16/3/24.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPStepper.h"

@interface MLBagGoodsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *productImgView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *selBtn;
@property (weak, nonatomic) IBOutlet CPStepper *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;

@end
