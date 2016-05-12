//
//  HFSServiceClient.m
//  FashionShop
//
//  Created by 王闻昊 on 15/9/22.
//  Copyright © 2015年 HeinQi. All rights reserved.
//

#import "HFSServiceClient.h"
#import "HFSConstants.h"
#import "HFSUtility.h"

__strong static HFSServiceClient *_clientNOT = nil;
__strong static HFSServiceClient *_client = nil;
__strong static HFSServiceClient *_JSONClient = nil;
__strong static HFSServiceClient *_JSONClientNOT = nil;

@implementation HFSServiceClient

+(instancetype)sharedClientNOT {
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, ^{
        
        _clientNOT = [[HFSServiceClient alloc]init];
        _clientNOT.responseSerializer = [AFHTTPResponseSerializer serializer];
        _clientNOT.responseSerializer.acceptableContentTypes = [_client.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];

        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *accessToken = [userDefaults stringForKey:kUSERDEFAULT_ACCCESSTOKEN];
        if (!accessToken) {
            accessToken = @"";
        }
        
        //设置HttpHeader
        [_clientNOT.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"AppClient"];
        [_clientNOT.requestSerializer setValue:[HFSUtility getSystemVersion] forHTTPHeaderField:@"OS-Version"];
        [_clientNOT.requestSerializer setValue:[HFSUtility getAppVersion] forHTTPHeaderField:@"AppVersion"];
        [_clientNOT.requestSerializer setValue:accessToken forHTTPHeaderField:@"AccessToken"];
        [_clientNOT.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",accessToken] forHTTPHeaderField:@"Authorization"];
    });
    return _clientNOT;
}



+(instancetype)sharedJSONClientNOT {
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, ^{
        
        _JSONClientNOT = [[HFSServiceClient alloc]init];
        _JSONClientNOT.responseSerializer.acceptableContentTypes = [_client.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *accessToken = [userDefaults stringForKey:kUSERDEFAULT_ACCCESSTOKEN];
        if (!accessToken) {
            accessToken = @"";
        }
        
        _JSONClientNOT.requestSerializer = [AFJSONRequestSerializer serializer];
        
        //设置HttpHeader
        [_JSONClientNOT.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"AppClient"];
        [_JSONClientNOT.requestSerializer setValue:[HFSUtility getSystemVersion] forHTTPHeaderField:@"OS-Version"];
        [_JSONClientNOT.requestSerializer setValue:[HFSUtility getAppVersion] forHTTPHeaderField:@"AppVersion"];
        [_JSONClientNOT.requestSerializer setValue:accessToken forHTTPHeaderField:@"AccessToken"];
        [_JSONClientNOT.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",accessToken] forHTTPHeaderField:@"Authorization"];
    });
    return _JSONClientNOT;
}


+(instancetype)sharedPayClient {
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, ^{
        
        _JSONClient = [[HFSServiceClient alloc]initWithBaseURL:[NSURL URLWithString:SERVICE_BASEPAY_URL]];
        _JSONClient.responseSerializer.acceptableContentTypes = [_JSONClient.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *accessToken = [userDefaults stringForKey:kUSERDEFAULT_ACCCESSTOKEN];
        if (!accessToken) {
            accessToken = @"";
        }
        
        _JSONClient.requestSerializer = [AFJSONRequestSerializer serializer];
        
        //设置HttpHeader
        [_JSONClient.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"AppClient"];
        [_JSONClient.requestSerializer setValue:[HFSUtility getSystemVersion] forHTTPHeaderField:@"OS-Version"];
        [_JSONClient.requestSerializer setValue:[HFSUtility getAppVersion] forHTTPHeaderField:@"AppVersion"];
        [_JSONClient.requestSerializer setValue:accessToken forHTTPHeaderField:@"AccessToken"];
        [_JSONClient.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",accessToken] forHTTPHeaderField:@"Authorization"];
    });
    return _JSONClient;
    
    
    
    
}


+(instancetype)sharedClientwithUrl:(NSString *)url {
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, ^{
        
        _client = [[HFSServiceClient alloc]initWithBaseURL:[NSURL URLWithString:url]];
        
        _client.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript", nil];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *accessToken = [userDefaults stringForKey:kUSERDEFAULT_ACCCESSTOKEN];
        if (!accessToken) {
            accessToken = @"";
        }
        [_client.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    });
    return _client;
}

+(instancetype)sharedClient {
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, ^{
        
        _client = [[HFSServiceClient alloc]initWithBaseURL:[NSURL URLWithString:SERVICE_BASE_URL]];
        
        _client.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript",  @"text/plain",nil];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *accessToken = [userDefaults stringForKey:kUSERDEFAULT_ACCCESSTOKEN];
        if (!accessToken) {
            accessToken = @"";
        }
        [_client.requestSerializer setValue:@"text/json" forHTTPHeaderField:@"Content-Type"];
    });
    return _client;
}

+(instancetype)sharedJSONClientwithurl:(NSString*)url {
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, ^{
        
        _JSONClient = [[HFSServiceClient alloc]initWithBaseURL:[NSURL URLWithString:url]];
        _JSONClient.responseSerializer.acceptableContentTypes = [_JSONClient.responseSerializer.acceptableContentTypes setByAddingObject:[NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript", @"text/plain",nil]];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *accessToken = [userDefaults stringForKey:kUSERDEFAULT_ACCCESSTOKEN];
        if (!accessToken) {
            accessToken = @"";
        }
        
        _JSONClient.requestSerializer = [AFJSONRequestSerializer serializer];
        
        //设置HttpHeader
        [_JSONClient.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"AppClient"];
        [_JSONClient.requestSerializer setValue:[HFSUtility getSystemVersion] forHTTPHeaderField:@"OS-Version"];
        [_JSONClient.requestSerializer setValue:[HFSUtility getAppVersion] forHTTPHeaderField:@"AppVersion"];
        [_JSONClient.requestSerializer setValue:accessToken forHTTPHeaderField:@"AccessToken"];
        [_JSONClient.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",accessToken] forHTTPHeaderField:@"Authorization"];
    });
    return _JSONClient;
}

+(instancetype)sharedJSONClient {
    
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, ^{
        
        _JSONClient = [[HFSServiceClient alloc]initWithBaseURL:[NSURL URLWithString:SERVICE_GETBASE_URL]];
        _JSONClient.responseSerializer.acceptableContentTypes = [_JSONClient.responseSerializer.acceptableContentTypes setByAddingObject:[NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript", @"text/plain",nil]];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *accessToken = [userDefaults stringForKey:kUSERDEFAULT_ACCCESSTOKEN];
        if (!accessToken) {
            accessToken = @"";
        }
        
        _JSONClient.requestSerializer = [AFJSONRequestSerializer serializer];

        //设置HttpHeader
        [_JSONClient.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"AppClient"];
        [_JSONClient.requestSerializer setValue:[HFSUtility getSystemVersion] forHTTPHeaderField:@"OS-Version"];
        [_JSONClient.requestSerializer setValue:[HFSUtility getAppVersion] forHTTPHeaderField:@"AppVersion"];
        [_JSONClient.requestSerializer setValue:accessToken forHTTPHeaderField:@"AccessToken"];
        [_JSONClient.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",accessToken] forHTTPHeaderField:@"Authorization"];
    });
    return _JSONClient;
}

-(void)setAccessToken:(NSString *)accessToken {
    _accessToken = accessToken;
    
    [_client.requestSerializer setValue:accessToken forHTTPHeaderField:@"AccessToken"];
    [_client.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",accessToken] forHTTPHeaderField:@"Authorization"];
    if (_JSONClient) {
        [_JSONClient.requestSerializer setValue:accessToken forHTTPHeaderField:@"AccessToken"];
        [_JSONClient.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",accessToken] forHTTPHeaderField:@"Authorization"];
    }
}

@end
