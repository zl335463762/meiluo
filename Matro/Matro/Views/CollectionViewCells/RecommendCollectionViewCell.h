//
//  RecommendCollectionViewCell.h
//  CrabPrince
//
//  Created by GK-Mac on 15/8/13.
//  Copyright (c) 2015年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;
@end
