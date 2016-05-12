//
//  MLSecondClass.h
//  Matro
//
//  Created by NN on 16/4/15.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "MLClassInfo.h"

@interface MLSecondClass : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong,readonly) MLClassInfo *SecondaryClassification_Ggw;
@property (nonatomic, copy, readonly) NSString *SecondaryClassification_WebrameCode;
@property (nonatomic, strong, readonly) NSArray *ThreeClassificationList;

@end
