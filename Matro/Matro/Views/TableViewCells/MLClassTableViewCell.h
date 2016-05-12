//
//  MLClassTableViewCell.h
//  Matro
//
//  Created by NN on 16/3/23.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLClassTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *CH;
@end
