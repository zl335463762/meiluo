//
//  MyJSInterface.h
//  EasyJSWebViewSample
//
//  Created by Lau Alex on 19/1/13.
//  Copyright (c) 2013 Dukeland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EasyJSDataFunction.h"
@protocol JSInterfaceDelegate <NSObject>
- (void)homeAction:(NSDictionary*)paramdic;

@end



@interface MyJSInterface : NSObject

- (void) navigationFloor:(NSString*)param;
- (void) navigationScroll: (NSString*) param;
- (void) navigationChannel: (NSString*) param;
-(void)navigationProduct:(NSString*)param productid:(NSString*)productId;
//- (void) testWithFuncParam: (EasyJSDataFunction*) param;
//- (void) testWithFuncParam2: (EasyJSDataFunction*) param;

- (NSString*) testWithRet;
@property (assign,nonatomic,readwrite)id <JSInterfaceDelegate>delegate;

@end
