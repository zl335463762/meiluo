//
//  MLAddressModel.h
//  Matro
//
//  Created by benssen on 16/4/15.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface MLAddressModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *EDITKEY;
@property (nonatomic, copy, readonly) NSString *HYID;
@property (nonatomic, copy, readonly) NSString *INX;
@property (nonatomic, copy, readonly) NSString *MRSHRBJ;
@property (nonatomic, copy, readonly) NSString *SFNAME;
@property (nonatomic, copy, readonly) NSString *SFZHM;
@property (nonatomic, copy, readonly) NSString *SHRADDRESS;
@property (nonatomic, copy, readonly) NSString *SHRMC;
@property (nonatomic, copy, readonly) NSString *SHRMPHONE;
@property (nonatomic, copy, readonly) NSString *SHRPHONE;
@property (nonatomic, copy, readonly) NSString *SHRPOST;
@property (nonatomic, copy, readonly) NSString *SHRSF;


@end
