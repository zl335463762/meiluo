//
//  MLClassTableViewCell.m
//  Matro
//
//  Created by NN on 16/3/23.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLClassTableViewCell.h"

#import "HFSConstants.h"

@implementation MLClassTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _collectionView.bounces = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    float width = (((MAIN_SCREEN_WIDTH)  - (10 * 5))/4);
    float height = width * 3/2;
    _CH.constant = height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
