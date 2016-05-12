//
//  HFSProductCollectionViewCell.m
//  FashionShop
//
//  Created by 王闻昊 on 15/9/29.
//  Copyright © 2015年 HeinQi. All rights reserved.
//

#import "HFSProductCollectionViewCell.h"
#import "HFSConstants.h"
#import "HFSUtility.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIColor+HeinQi.h"

@interface HFSProductCollectionViewCell ()


@end

@implementation HFSProductCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.productImgview.layer.masksToBounds = YES;
    self.layer.borderColor = [UIColor colorWithHexString:@"F0F0F0"].CGColor;
    self.layer.borderWidth = 1.0f;
}



@end
