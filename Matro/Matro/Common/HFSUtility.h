//
//  HFSUtility.h
//  FashionShop
//
//  Created by 王闻昊 on 15/8/11.
//  Copyright (c) 2015年 HeinQi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HFSUtility : NSObject

+ (NSString *)getAppVersion;
+ (NSString *)getSystemVersion;
+ (BOOL) validateMobile:(NSString *)mobile;
+ (BOOL) validateEmail:(NSString *)email;
+ (BOOL) validatePostCode:(NSString *)code;
+ (BOOL) validatePostName:(NSString *)name;
+ (BOOL) hasUserLogin;
+ (NSString *) GUID;
+ (NSAttributedString *)deletString:(NSString *)str;
+ (NSString *)getIPAddress;
+ (void)changeUserInfoFromDic:(NSDictionary *)dic;
+ (NSInteger)ageFromBirthStr:(NSString *)birth;
+ (NSDictionary *)SIGNDic:(NSDictionary *)dic;
+ (NSString *)RSADicToStr:(NSDictionary *)dic01;
-(void)RsaDicToStr:(NSDictionary *)dic01;
-(NSString *)getSignedString;
+(NSData *)RSADicToData:(NSDictionary *)dic01;
-(NSData *)sectionRSASecret:(NSData*)tempstr;
+(UIColor *) hexStringToColor: (NSString *) stringToConvert;

@end
