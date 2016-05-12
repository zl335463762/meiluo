//
//  MLBaseViewController.m
//  Matro
//
//  Created by NN on 16/2/26.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

@class AppDelegate;

#import "MLNavigationController.h"
#import "HFSConstants.h"
static NSString *base64_encode_data(NSData *data){
    data = [data base64EncodedDataWithOptions:0];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}
@interface MLBaseViewController : UIViewController {
    MBProgressHUD *_hud;
}

- (AppDelegate *)getAppDelegate;

- (void)alert:(NSString *)title msg:(NSString *)msg;

@end
