//
//  CPStepper.m
//  CrabPrince
//
//  Created by 王闻昊 on 15/8/18.
//  Copyright (c) 2015年 HeinQi. All rights reserved.
//

#import "CPStepper.h"
#import "UIColor+HeinQi.h"

@interface CPStepper () <UITextFieldDelegate> {
    
}

@end

@implementation CPStepper

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    _minValue = 1;
    _maxValue = 100;
    
    self.keyboardType = UIKeyboardTypeNumberPad;
    
    self.leftViewMode = UITextFieldViewModeAlways;
    self.rightViewMode = UITextFieldViewModeAlways;
    
    UIButton *subButton = [UIButton buttonWithType:UIButtonTypeSystem];
    subButton.frame = CGRectMake(0, 0, 25, rect.size.height);
    [subButton setTitle:@"-" forState:UIControlStateNormal];
    subButton.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    [subButton setTintColor:[UIColor colorWithHexString:@"#C9C9C9"]];
    [subButton addTarget:self action:@selector(sub:) forControlEvents:UIControlEventTouchUpInside];
    self.leftView = subButton;
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeSystem];
    addButton.frame = CGRectMake(0, 0, 25, rect.size.height);
    [addButton setTitle:@"+" forState:UIControlStateNormal];
    addButton.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    [addButton setTintColor:[UIColor colorWithHexString:@"#C9C9C9"]];
    [addButton addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
    self.rightView = addButton;
    
    self.textAlignment = NSTextAlignmentCenter;
    self.delegate = self;
    
    if(_value){
        self.text = [NSString stringWithFormat:@"%lu", (unsigned long)_value];
    }else{
        self.text = [NSString stringWithFormat:@"%lu", (unsigned long)_minValue];
        _value = _minValue;
    }

}

-(void)sub:(UIButton *)sender {
//    _value = [self.text integerValue];
    
    if (_value <= _minValue) {
        return;
    }
    
    _value--;
    
    self.text = [NSString stringWithFormat:@"%lu", (unsigned long)_value];
    
    if (self.stepperDelegate) {
        [self.stepperDelegate subButtonClicked:sender];
    }
}

-(void)add: (UIButton *)sender {
//    _value = [self.text integerValue];
    
    if (_value >= _maxValue) {
        return;
    }
    
    _value++;
    
    self.text = [NSString stringWithFormat:@"%lu", (unsigned long)_value];
    
    if (self.stepperDelegate) {
        [self.stepperDelegate addButtonClicked:sender];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    _value = textField.text.intValue;
    
    if (_value <= _minValue) {
        _value = _minValue;
        textField.text = [NSString stringWithFormat:@"%lu", (unsigned long)_value];
    }
    
    if (_value >= _maxValue) {
        _value = _maxValue;
        textField.text = [NSString stringWithFormat:@"%lu", (unsigned long)_value];
    }
}

@end
