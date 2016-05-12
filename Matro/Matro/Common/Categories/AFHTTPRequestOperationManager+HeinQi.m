//
//  AFHTTPRequestOperationManager+HeinQi.m
//  CrabPrince
//
//  Created by 王闻昊 on 15/9/7.
//  Copyright (c) 2015年 HeinQi. All rights reserved.
//

#import "AFHTTPRequestOperationManager+HeinQi.h"
#import <objc/runtime.h>

#import "HFSConstants.h"
#import "AppDelegate.h"

@implementation AFHTTPRequestOperationManager (HeinQi)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(GET:parameters:success:failure:);
        SEL swizzledSelector = @selector(HeinQi_GET:parameters:success:failure:);
        SEL originalSelectorPost = @selector(POST:parameters:success:failure:);
        SEL swizzledSelectorPost = @selector(HeinQi_POST:parameters:success:failure:);
    
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);
        Method originalMethodPost = class_getInstanceMethod(class, originalSelectorPost);
        Method swizzledMethodPost = class_getInstanceMethod([self class], swizzledSelectorPost);
        
        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        BOOL didAddMethodPost = class_addMethod(class, originalSelectorPost, method_getImplementation(swizzledMethodPost), method_getTypeEncoding(swizzledMethodPost));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
        
        if (didAddMethodPost) {

            class_replaceMethod(class,
                                swizzledSelectorPost,
                                method_getImplementation(originalMethodPost),
                                method_getTypeEncoding(originalMethodPost));
        } else {
            method_exchangeImplementations(originalMethodPost, swizzledMethodPost);
        }

    });
}

- (AFHTTPRequestOperation *)HeinQi_GET:(NSString *)URLString  parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    return [self HeinQi_GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            
//            if ([[responseObject objectForKey:@"status"] isEqualToNumber:@401]) {
            
//                GJNavigationController *nvc =[[GJNavigationController alloc]initWithRootViewController:[[GJLoginViewController alloc]init]];
//                ((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController = nvc;
//
//                [[[UIAlertView alloc]initWithTitle:@"提示" message:@"您的账号在其它设备上登录，请重新登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
//                
//            }
            
            success(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation,error);                    
        }                
    }];
}

- (AFHTTPRequestOperation *)HeinQi_POST:(NSString *)URLString  parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    return [self HeinQi_POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            
//            if ([[responseObject objectForKey:@"status"] isEqualToNumber:@401]) {
//                
//                GJNavigationController *nvc =[[GJNavigationController alloc]initWithRootViewController:[[GJLoginViewController alloc]init]];
//                ((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController = nvc;
//                
//                [[[UIAlertView alloc]initWithTitle:@"提示" message:@"您的账号在其它设备上登录，请重新登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
//            }
            
            success(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        if (failure) {
            failure(operation,error);
        }
    }];
}




@end
