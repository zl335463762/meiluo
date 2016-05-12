//
//  YMLeftImageField.m
//  YMShare
//
//  Created by MR.Huang on 16/1/7.
//  Copyright © 2016年 YMKJ. All rights reserved.
//

#import "YMLeftImageField.h"

@interface YMLeftImageField()

@property (nonatomic,strong)UIImageView *leftImageView;
@end

@implementation YMLeftImageField



- (void)awakeFromNib
{
    [self setupLeftMode];

}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupLeftMode];
    }
    return self;
}


- (void)setupLeftMode
{
    self.leftViewMode        = UITextFieldViewModeAlways;
    UIImageView *leftImageView         = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.height, self.frame.size.height)];
    [leftImageView setContentMode:UIViewContentModeCenter];
    self.leftImageView = leftImageView;
    self.leftView = leftImageView;
}


- (void)setLeftImgName:(NSString *)leftImgName
{
    if (_leftImgName != leftImgName)
    {
        _leftImgName = leftImgName;
        self.leftImageView.image = [UIImage imageNamed:_leftImgName];
    }
}


- (CGRect)textRectForBounds:(CGRect)bounds{
    
    CGRect iconRect = [super textRectForBounds:bounds];
    if (self.textOffset!=0) {
        iconRect.origin.x += self.textOffset;// 右偏
        
    }else{
        iconRect.origin.x += 0;// 右偏
        
    }
    return iconRect;
    
}


- (CGRect)placeholderRectForBounds:(CGRect)bounds{
    
    CGRect iconRect = [super placeholderRectForBounds:bounds];
    if (self.pecoOffset!=0) {
        iconRect.origin.x += self.pecoOffset;// 右偏
        
    }else{
        iconRect.origin.x += 0;// 右偏
        
    }
    return iconRect;
    
    
    
}


-(CGRect) leftViewRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    if (self.leftOffset!=0) {
        iconRect.origin.x += self.leftOffset;// 右偏
        
    }else{
        iconRect.origin.x += 0;// 右偏
        
    }
    return iconRect;
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds{
    
    CGRect iconRect = [super rightViewRectForBounds:bounds];
    if (self.rightOffset!=0) {
        iconRect.origin.x -= self.rightOffset;// 右偏
        
    }else{
        iconRect.origin.x -= 0;// 右偏
        
    }
    
    return iconRect;
    
}



@end
