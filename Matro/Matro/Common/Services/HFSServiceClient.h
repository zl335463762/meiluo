//
//  HFSServiceClient.h
//  FashionShop
//
//  Created by 王闻昊 on 15/9/22.
//  Copyright © 2015年 HeinQi. All rights reserved.
//

#import <AFNetworking/AFHTTPRequestOperationManager.h>

@interface HFSServiceClient : AFHTTPRequestOperationManager

@property (nonatomic, copy) NSString *accessToken;
+(instancetype)sharedPayClient;
+(instancetype)sharedClient;
+(instancetype)sharedJSONClient;
+(instancetype)sharedClientNOT;
+(instancetype)sharedJSONClientNOT;
+(instancetype)sharedClientwithUrl:(NSString *)url;
+(instancetype)sharedJSONClientwithurl:(NSString*)url;
@end
