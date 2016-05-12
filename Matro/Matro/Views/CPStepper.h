//
//  CPStepper.h
//  CrabPrince
//
//  Created by 王闻昊 on 15/8/18.
//  Copyright (c) 2015年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CPStepperDelegate <NSObject>

- (void)addButtonClicked:(UIButton *)sender;
- (void)subButtonClicked:(UIButton *)sender;

@end

@interface CPStepper : UITextField

@property (nonatomic) NSUInteger minValue;
@property (nonatomic) NSUInteger maxValue;

@property (nonatomic) NSUInteger value;

@property (nonatomic, weak) id<CPStepperDelegate> stepperDelegate;

@end
