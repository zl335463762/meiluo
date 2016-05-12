//
//  HFSOrderListTableViewCell.m
//  FashionShop
//
//  Created by 王闻昊 on 15/10/9.
//  Copyright © 2015年 HeinQi. All rights reserved.
//

#import "HFSOrderListTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HFSConstants.h"

@interface HFSOrderListTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *productCountLabel;

@end

@implementation HFSOrderListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setProductImageURL:(NSURL *)productImageURL {
    _productImageURL = productImageURL;
    if (productImageURL) {
        [self.productImageView sd_setImageWithURL:productImageURL placeholderImage:PLACEHOLDER_IMAGE];
    }
}

-(void)setProductName:(NSString *)productName {
    _productName = productName;
    if (productName) {
        self.productNameLabel.text = productName;
    } else {
        self.productNameLabel.text = @"";
    }
}

-(void)setProductPrice:(NSNumber *)productPrice {
    _productPrice = productPrice;
    if (productPrice) {
        self.productPriceLabel.text = [NSString stringWithFormat:@"¥%.2f", productPrice.floatValue];
    } else {
        self.productPriceLabel.text = @"";
    }
}

-(void)setProductCount:(NSNumber *)productCount {
    _productCount = productCount;
    if (productCount) {
        self.productCountLabel.text = [NSString stringWithFormat:@"x%@", productCount];
    } else {
        self.productCountLabel.text = @"";
    }
}

@end
