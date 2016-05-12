//
//  MLAddressModel.m
//  Matro
//
//  Created by benssen on 16/4/15.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLAddressModel.h"

@implementation MLAddressModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"EDITKEY":@"EDITKEY",
             @"HYID":@"HYID",
             @"INX":@"INX",
             @"MRSHRBJ":@"MRSHRBJ",
             @"SFNAME":@"SFNAME",
             @"SFZHM":@"SFZHM",
             @"SHRADDRESS":@"SHRADDRESS",
             @"SHRMC":@"SHRMC",
             @"SHRMPHONE":@"SHRMPHONE",
             @"SHRPHONE":@"SHRPHONE",
             @"SHRPOST":@"SHRPOST",
             @"SHRSF":@"SHRSF"
             };
}

@end
