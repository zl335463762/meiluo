//
//  MLClassInfo.m
//  Matro
//
//  Created by NN on 16/4/15.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLClassInfo.h"

@implementation MLClassInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"HEIGHT" : @"HEIGHT",
             @"HOTIMG" : @"HOTIMG",
             @"CID" : @"ID",
             @"MC" : @"MC",
             @"SRC" : @"SRC",
             @"TITLE" : @"TITLE",
             @"URL" : @"URL",
             @"WIDTH" : @"WIDTH",
             };
}

+ (NSValueTransformer *)SRCJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
