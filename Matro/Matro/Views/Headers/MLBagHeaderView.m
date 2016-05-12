//
//  MLBagHeaderView.m
//  Matro
//
//  Created by hyk on 16/3/24.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBagHeaderView.h"
#import "HFSUtility.h"

@implementation MLBagHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"MLBagHeaderView" owner:self options:nil];
        
        if (arrayOfViews.count < 1) {
            return nil;
        }
        
        if (![arrayOfViews[0] isKindOfClass:[UITableViewHeaderFooterView class]]) {
            return nil;
        }
        UIView *backgroundView = [[UIView alloc]initWithFrame:self.frame];
        backgroundView.backgroundColor = [HFSUtility hexStringToColor:@"F5F5F5"];
        ((UITableViewHeaderFooterView *)arrayOfViews[0]).backgroundView = backgroundView;
        
        self = arrayOfViews[0];
        
    }

    return self;
}


@end
