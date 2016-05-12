//
//  CPProduct.m
//  CrabPrince
//
//  Created by 王闻昊 on 15/8/21.
//  Copyright (c) 2015年 HeinQi. All rights reserved.
//

#import "CPProduct.h"

@implementation CPProduct

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"productId" : @"productId",
             @"productName" : @"productName",
             @"imageUrl" : @"imageUrl",
             @"productPrice" : @"productPrice",
             @"soldCount" : @"soldCount",
             @"detail" : @"detail",
             @"summary": @"summary",
             @"category":@"category",
             @"productMarketPrice":@"productMarketPrice",
             @"tags":@"tags"
             };
}

+ (NSValueTransformer *)imageUrlJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}


@end
