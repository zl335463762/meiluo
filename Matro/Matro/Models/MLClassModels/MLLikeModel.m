//
//  MLLikeModel.m
//  Matro
//
//  Created by benssen on 16/4/15.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLLikeModel.h"

@implementation MLLikeModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"IMGURL":@"IMGURL",
             @"JMSP_ID":@"JMSP_ID",
             @"KCSL":@"KCSL",
             @"LSDJ":@"LSDJ",
             @"NAMELIST":@"NAMELIST",
             @"SPNAME":@"SPNAME",
             @"XJ":@"XJ",
             @"XSBJ":@"XSBJ",
             @"XSMSP_ID":@"XSMSP_ID",
             @"XSSL":@"XSSL",
             @"ZCSP":@"ZCSP"
             };
}

+ (NSValueTransformer *)IMGURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
