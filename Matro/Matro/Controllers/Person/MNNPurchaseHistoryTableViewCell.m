//
//  MNNPurchaseHistoryTableViewCell.m
//  Matro
//
//  Created by benssen on 16/3/30.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MNNPurchaseHistoryTableViewCell.h"

@implementation MNNPurchaseHistoryTableViewCell {
    UILabel *_time;
    UILabel *_timeLabel;
    UILabel *_money;
    UILabel *_moneyLabel;
    UILabel *_integral;
    UILabel *_integralLabel;
    UILabel *_address;
    UILabel *_addressLabel;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createViews];
        [self reloadCell];
    }
    return self;
}
- (void)createViews {
    _time          = [UILabel new];
    _timeLabel     = [UILabel new];
    _money         = [UILabel new];
    _moneyLabel    = [UILabel new];
    _integral      = [UILabel new];
    _integralLabel = [UILabel new];
    _address       = [UILabel new];
    _addressLabel  = [UILabel new];
    [self.contentView addSubview:_time];
    [self.contentView addSubview:_timeLabel];
    [self.contentView addSubview:_money];
    [self.contentView addSubview:_moneyLabel];
    [self.contentView addSubview:_integral];
    [self.contentView addSubview:_integralLabel];
    [self.contentView addSubview:_address];
    [self.contentView addSubview:_addressLabel];
}
- (void)reloadCell {
    _time.text           = @"消费时间";
    _time.font           = [UIFont systemFontOfSize:14];
    _money.text          = @"消费金额";
    _money.font          = [UIFont systemFontOfSize:14];
    _integral.text       = @"消费积分";
    _integral.font       = [UIFont systemFontOfSize:14];
    _address.text        = @"消费门店";
    _address.font        = [UIFont systemFontOfSize:14];
    _timeLabel.text      = @"2016-03-01 12:00:00";
    _timeLabel.font      = [UIFont systemFontOfSize:14];
    _timeLabel.alpha     = 0.7;
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _moneyLabel.text     = @"￥12543.00";
    _moneyLabel.font     = [UIFont systemFontOfSize:14];
    _moneyLabel.alpha    = 0.7;
    _moneyLabel.textAlignment = NSTextAlignmentRight;
    _integralLabel.text  = @"1000000";
    _integralLabel.font  = [UIFont systemFontOfSize:14];
    _integralLabel.alpha = 0.7;
    _integralLabel.textAlignment = NSTextAlignmentRight;
    _addressLabel.text   = @"美罗观前街";
    _addressLabel.font   = [UIFont systemFontOfSize:14];
    _addressLabel.alpha  = 0.7;
    _addressLabel.textAlignment = NSTextAlignmentRight;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    _time.frame = CGRectMake(10, 0, 80, 30);
    _timeLabel.frame = CGRectMake(CGRectGetWidth(self.frame)-210, 0, 200, 30);
    _money.frame = CGRectMake(10, CGRectGetMaxY(_time.frame), 80, 30);
    _moneyLabel.frame = CGRectMake(CGRectGetWidth(self.frame)-210, CGRectGetMaxY(_timeLabel.frame), 200, 30);
    _integral.frame = CGRectMake(10, CGRectGetMaxY(_money.frame), 80, 30);
    _integralLabel.frame = CGRectMake(CGRectGetWidth(self.frame)-210, CGRectGetMaxY(_moneyLabel.frame), 200, 30);
    _address.frame = CGRectMake(10, CGRectGetMaxY(_integral.frame), 80, 30);
    _addressLabel.frame = CGRectMake(CGRectGetWidth(self.frame)-210, CGRectGetMaxY(_integralLabel.frame), 200, 30);
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
