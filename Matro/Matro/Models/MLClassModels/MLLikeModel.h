//
//  MLLikeModel.h
//  Matro
//
//  Created by benssen on 16/4/15.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface MLLikeModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSURL *IMGURL;
@property (nonatomic, copy, readonly) NSString *JMSP_ID;
@property (nonatomic, copy, readonly) NSString *KCSL;
@property (nonatomic, copy, readonly) NSString *LSDJ;
@property (nonatomic, copy, readonly) NSString *NAMELIST;
@property (nonatomic, copy, readonly) NSString *SPNAME;
@property (nonatomic, copy, readonly) NSString *XJ;
@property (nonatomic, copy, readonly) NSString *XSBJ;
@property (nonatomic, copy, readonly) NSString *XSMSP_ID;
@property (nonatomic, copy, readonly) NSString *XSSL;
@property (nonatomic, copy, readonly) NSString *ZCSP;

@end
