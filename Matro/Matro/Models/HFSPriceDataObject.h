//
//  HFSPriceDataObject.h
//  FashionShop
//
//  Created by 王闻昊 on 15/9/30.
//  Copyright © 2015年 HeinQi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFSPriceDataObject : NSObject

@property (strong, nonatomic) NSNumber *fromPrice;
@property (strong, nonatomic) NSNumber *toPrice;
@property (nonatomic) BOOL selected;

- (id)initWithFrom:(NSNumber *)fromPrice to:(NSNumber *)toPrice;

+ (id)priceObjectWithFrom:(NSNumber *)fromPrice to:(NSNumber *)toPrice;

@end
