//
//  HFSOrderListHeaderView.m
//  FashionShop
//
//  Created by 王闻昊 on 15/10/8.
//  Copyright © 2015年 HeinQi. All rights reserved.
//

#import "HFSOrderListHeaderView.h"

@implementation HFSOrderListHeaderView

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
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"HFSOrderListHeaderView" owner:self options:nil];
        
        if (arrayOfViews.count < 1) {
            return nil;
        }
        
        if (![arrayOfViews[0] isKindOfClass:[UITableViewHeaderFooterView class]]) {
            return nil;
        }
        
        UIView *backgroundView = [[UIView alloc]initWithFrame:self.frame];
        backgroundView.backgroundColor = [UIColor whiteColor];
        ((UITableViewHeaderFooterView *)arrayOfViews[0]).backgroundView = backgroundView;
        
        self = arrayOfViews[0];
        
    }
    
    return self;
}

@end
