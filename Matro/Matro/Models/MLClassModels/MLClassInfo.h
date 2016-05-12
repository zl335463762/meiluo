//
//  MLClassInfo.h
//  Matro
//
//  Created by NN on 16/4/15.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface MLClassInfo : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *HEIGHT;
@property (nonatomic, copy, readonly) NSString *HOTIMG;
@property (nonatomic, copy, readonly) NSString *CID;
@property (nonatomic, copy, readonly) NSString *MC;
@property (nonatomic, copy, readonly) NSURL *SRC;
@property (nonatomic, copy, readonly) NSString *TITLE;
@property (nonatomic, copy, readonly) NSString *URL;
@property (nonatomic, copy, readonly) NSString *WIDTH;


@end
