//
//  MyJSInterface.m
//  EasyJSWebViewSample
//
//  Created by Lau Alex on 19/1/13.
//  Copyright (c) 2013 Dukeland. All rights reserved.
//

#import "MyJSInterface.h"

@implementation MyJSInterface

- (void) test{
	NSLog(@"test called");
}

- (void) navigationFloor:(NSString*)param;
{
    NSLog(@"下部广告位调用轮显navigationFloor called");

}
- (void) navigationScroll: (NSString*) param
{
    NSLog(@"头部轮显调用方法navigationScroll called");

}
- (void) navigationChannel: (NSString*) param
{
    NSLog(@"4个按钮调用的方法navigationChannel called");

}
-(void)navigation:(NSString*)param Product:(NSString*)productId
{
    NSLog(@"商品按钮调用方法product_click called");
    if (_delegate) {
        NSDictionary *parmdic = @{@"JMSP_ID":productId,@"ZCSP":param};

        [_delegate homeAction:parmdic];
    }
}


- (void) testWithParam: (NSString*) param{
	NSLog(@"test with param: %@", param);
}

- (void) testWithTwoParam: (NSString*) param AndParam2: (NSString*) param2{
	NSLog(@"test with param: %@ and param2: %@", param, param2);
}

- (void) testWithFuncParam: (EasyJSDataFunction*) param{
	NSLog(@"test with func");
	
	param.removeAfterExecute = YES;
	NSString* ret = [param executeWithParam:@"blabla:\"bla"];
	
	NSLog(@"Return value from callback: %@", ret);
}

- (void) testWithFuncParam2: (EasyJSDataFunction*) param{
	NSLog(@"test with func 2 but not removing callback after invocation");
	
	param.removeAfterExecute = NO;
	[param executeWithParam:@"data 1"];
	[param executeWithParam:@"data 2"];
}

- (NSString*) testWithRet{
	NSString* ret = @"js";
	return ret;
}

@end
