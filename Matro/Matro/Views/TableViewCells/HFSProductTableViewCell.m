//
//  HFSProductTableViewCell.m
//  FashionShop
//
//  Created by 王闻昊 on 15/9/29.
//  Copyright © 2015年 HeinQi. All rights reserved.
//

#import "HFSProductTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HFSConstants.h"
#import "HFSUtility.h"

@interface HFSProductTableViewCell ()

@end

@implementation HFSProductTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.productImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//-(void)setImageURL:(NSURL *)imageURL {
//    if (imageURL) {
//        [self.productImageView sd_setImageWithURL:imageURL placeholderImage:PLACEHOLDER_IMAGE];
//    }
//}
//
//-(void)setProductName:(NSString *)productName {
//    if (productName) {
//        self.productNameLabel.text = productName;
//    }
//}
//
//
//
//-(void)setCurrentPrice:(NSNumber *)currentPrice {
//    if (currentPrice) {
//        self.currentPriceLabel.text = [NSString stringWithFormat:@"¥%.2f", currentPrice.floatValue];
//    } else {
//        self.currentPriceLabel.text = @"";
//    }
//}


- (void)setProduct:(MLProductModel *)product{
    if (_product != product) {
        _product = product;
        [self.productImageView sd_setImageWithURL:[NSURL URLWithString:_product.IMGURL] placeholderImage:PLACEHOLDER_IMAGE];
        self.productNameLabel.text = _product.SPNAME;
        self.currentPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",_product.XSJE];
        self.numLabel.text = [NSString stringWithFormat:@"×%@",_product.XSSL];
    }
}


@end
