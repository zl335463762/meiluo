//
//  MLClassHeader.m
//  Matro
//
//  Created by NN on 16/3/23.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLClassHeader.h"

@implementation MLClassHeader

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"MLClassHeader" owner:self options:nil];
        
        if (arrayOfViews.count < 1) {
            return nil;
        }
        
        if (![arrayOfViews[0] isKindOfClass:[UITableViewHeaderFooterView class]]) {
            return nil;
        }
        
        UIView *backgroundView = [[UIView alloc]initWithFrame:self.frame];
        backgroundView.backgroundColor = [UIColor clearColor];
        ((UITableViewHeaderFooterView *)arrayOfViews[0]).backgroundView = backgroundView;
        
        self = arrayOfViews[0];
        
    }
    _headerImageView.userInteractionEnabled = YES;
    //原图或拉伸图片
//    _headerImageView.contentMode = UIViewContentModeScaleAspectFit;
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
