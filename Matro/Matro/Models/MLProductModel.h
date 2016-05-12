//
//  MLProductModel.h
//  Matro
//
//  Created by 黄裕华 on 16/5/3.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLProductModel : NSObject

@property (nonatomic,copy)NSString *XSMSP_ID;
@property (nonatomic,copy)NSString *SPNAME;
@property (nonatomic,copy)NSString *CJJ;
@property (nonatomic,copy)NSString *XSSL;
@property (nonatomic,assign)float XSJE;
@property (nonatomic,copy)NSString *ZCSP;
@property (nonatomic,copy)NSString *IMGURL;
@property (nonatomic,copy)NSString *JMSP_ID;

@property (nonatomic,assign)float LSDJ;

@end
