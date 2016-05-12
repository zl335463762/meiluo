//
//  YMLeftImageField.h
//  YMShare
//
//  Created by MR.Huang on 16/1/7.
//  Copyright © 2016年 YMKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMLeftImageField : UITextField


@property (nonatomic,copy)NSString *leftImgName;

@property (nonatomic,assign)float leftOffset;
@property (nonatomic,assign)float rightOffset;
@property (nonatomic,assign)float pecoOffset;
@property (nonatomic,assign)float textOffset;

@end
