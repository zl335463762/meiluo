//
//  HFSOrderListFooterView.m
//  FashionShop
//
//  Created by 王闻昊 on 15/10/8.
//  Copyright © 2015年 HeinQi. All rights reserved.
//

#import "HFSOrderListFooterView.h"
#import "UIColor+HeinQi.h"

@interface HFSOrderListFooterView ()

@property (weak, nonatomic) IBOutlet UILabel *paidAmountLabel;

@end

@implementation HFSOrderListFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"HFSOrderListFooterView" owner:self options:nil];
        
        if (arrayOfViews.count < 1) {
            return nil;
        }
        
        if (![arrayOfViews[0] isKindOfClass:[UITableViewHeaderFooterView class]]) {
            return nil;
        }
        
        self = arrayOfViews[0];
    }
    
    return self;
}

-(void)setPaidAmount:(NSNumber *)paidAmount {
    _paidAmount = paidAmount;
    if (paidAmount) {
        self.paidAmountLabel.text = [NSString stringWithFormat:@"实付款: ¥%.2f", paidAmount.floatValue];
    } else {
        self.paidAmountLabel.text = @"";
    }
}

@end
