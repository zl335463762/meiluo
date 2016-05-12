//
//  MLAddressListTableViewCell.m
//  Matro
//
//  Created by NN on 16/3/29.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLAddressListTableViewCell.h"

#import "UIButton+HeinQi.h"

@implementation MLAddressListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [_selButton invoiceselButtonType];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
