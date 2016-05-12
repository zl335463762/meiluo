//
//  MLSXView.h
//  Matro
//
//  Created by NN on 16/3/30.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NNSXDelegate <NSObject>
- (void)blackAction:(NSDictionary*)paramdic;
@end

@interface MLSXView : UIView

- (id)init;
- (id)initWithFrame:(CGRect)frame;

@property (assign,nonatomic,readwrite)id <NNSXDelegate>delegate;

//判断之前是否有选有最大最小价格，然后在自定义价格做修改
@property (nonatomic) NSNumber *postMinPrice;
@property (nonatomic) NSNumber *postMaxPrice;
@property (nonatomic, retain) NSString *keywords;
@end
