//
//  MLAddressListTableViewCell.h
//  Matro
//
//  Created by NN on 16/3/29.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLAddressListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *selButton;
@property (strong, nonatomic) IBOutlet UILabel *tisLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lw;// 12 65

@end
