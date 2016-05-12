//
//  CPProduct.h
//  CrabPrince
//
//  Created by 王闻昊 on 15/8/21.
//  Copyright (c) 2015年 HeinQi. All rights reserved.
//

#import "Mantle.h"

@interface CPProduct : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSNumber *productId;
@property (nonatomic, copy, readonly) NSString *productName;
@property (nonatomic, copy, readonly) NSURL *imageUrl;
@property (nonatomic, copy, readonly) NSNumber *productPrice;
@property (nonatomic, copy, readonly) NSNumber *soldCount;
@property (nonatomic, copy, readonly) NSNumber *productMarketPrice;

@property (nonatomic, copy, readonly) NSString *detail;
@property (nonatomic, copy, readonly) NSString *summary;
@property (nonatomic, copy, readonly) NSString *category;

@property (nonatomic, copy) NSNumber *tags;
@end
