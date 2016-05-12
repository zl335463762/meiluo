//
//  HFSProductCollectionViewCell.h
//  FashionShop
//
//  Created by 王闻昊 on 15/9/29.
//  Copyright © 2015年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HFSProductCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *productImgview;
@property (weak, nonatomic) IBOutlet UILabel *productnameLb;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;

@end
