//
//  MLBagFootView.m
//  Matro
//
//  Created by 陈文娟 on 16/5/1.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBagFootView.h"
#import "HFSUtility.h"

@implementation MLBagFootView

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
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"MLBagFootView" owner:self options:nil];
        
        if (arrayOfViews.count < 1) {
            return nil;
        }
        
        if (![arrayOfViews[0] isKindOfClass:[UITableViewHeaderFooterView class]]) {
            return nil;
        }
        
        UIView *backgroundView = [[UIView alloc]initWithFrame:self.frame];
        backgroundView.backgroundColor = [UIColor whiteColor];
        ((UITableViewHeaderFooterView *)arrayOfViews[0]).backgroundView = backgroundView;
        self.bgView.backgroundColor = [HFSUtility hexStringToColor:@"F5F5F5"];
        self = arrayOfViews[0];
        
    }
    
    return self;
}
@end
