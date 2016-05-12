//
//  HFSProductTableViewCell.h
//  FashionShop
//
//  Created by 王闻昊 on 15/9/29.
//  Copyright © 2015年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLProductModel.h"

@interface HFSProductTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *tisLabel;
@property (strong, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;

@property (nonatomic,strong)MLProductModel *product;



@end
