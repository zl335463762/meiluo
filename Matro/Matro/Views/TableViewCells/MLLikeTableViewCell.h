//
//  MLLikeTableViewCell.h
//  Matro
//
//  Created by NN on 16/3/28.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLLikeTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageView01;
@property (strong, nonatomic) IBOutlet UIImageView *imageView02;
//名字
@property (strong, nonatomic) IBOutlet UILabel *nameLabel01;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel02;
//价格
@property (strong, nonatomic) IBOutlet UILabel *priceLabel01;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel02;
//价格2
@property (strong, nonatomic) IBOutlet UILabel *rpriceLabel01;
@property (strong, nonatomic) IBOutlet UILabel *rpriceLabel02;
@property (strong, nonatomic) IBOutlet UIControl *lBgView;
@property (strong, nonatomic) IBOutlet UIControl *rBgView;

@end
