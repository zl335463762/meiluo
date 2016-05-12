//
//  MLLogisticsTableViewCell.h
//  Matro
//
//  Created by NN on 16/4/5.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SkyRadiusView;

@interface MLLogisticsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *topLine;
@property (strong, nonatomic) IBOutlet UIView *bottomLine;
@property (strong, nonatomic) IBOutlet SkyRadiusView *point;
@property (strong, nonatomic) IBOutlet SkyRadiusView *point2;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@end
