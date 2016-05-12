//
//  MLClassCollectionViewCell.h
//  Matro
//
//  Created by NN on 16/3/23.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLClassCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *classImageView;
@property (strong, nonatomic) IBOutlet UILabel *CNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *ENameLabel;

@end
