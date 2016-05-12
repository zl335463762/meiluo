//
//  MLClass.h
//  Matro
//
//  Created by NN on 16/4/15.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface MLClass : MTLModel <MTLJSONSerializing>
@property (nonatomic, copy, readonly) NSString *CODE;
@property (nonatomic, copy, readonly) NSString *ENAME;
@property (nonatomic, copy, readonly) NSString *INX;
@property (nonatomic, copy, readonly) NSString *MC;
@property (nonatomic, copy, readonly) NSString *PCODE;
@property (nonatomic, copy, readonly) NSString *PNAME;
@property (nonatomic, copy, readonly) NSString *TYPE;
@property (nonatomic, copy, readonly) NSString *URL;
@property (nonatomic, copy, readonly) NSString *YXBJ;
@end
