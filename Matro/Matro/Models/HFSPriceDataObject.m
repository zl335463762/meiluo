//
//  HFSPriceDataObject.m
//  FashionShop
//
//  Created by 王闻昊 on 15/9/30.
//  Copyright © 2015年 HeinQi. All rights reserved.
//

#import "HFSPriceDataObject.h"

@implementation HFSPriceDataObject

-(id)initWithFrom:(NSNumber *)fromPrice to:(NSNumber *)toPrice {
    self = [super init];
    if (self) {
        self.fromPrice = fromPrice;
        self.toPrice = toPrice;
    }
    return self;
}

+(id)priceObjectWithFrom:(NSNumber *)fromPrice to:(NSNumber *)toPrice {
    return [[self alloc]initWithFrom:fromPrice to:toPrice];
}

-(NSString *)description {
    return [NSString stringWithFormat:@"%@~%@", self.fromPrice, self.toPrice];
}

@end
