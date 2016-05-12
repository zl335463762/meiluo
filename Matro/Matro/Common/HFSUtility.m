//
//  HFSUtility.m
//  FashionShop
//
//  Created by 王闻昊 on 15/8/11.
//  Copyright (c) 2015年 HeinQi. All rights reserved.
//

#import "HFSUtility.h"
#import "HFSConstants.h"
#import <ifaddrs.h>
#import <arpa/inet.h>

#import "HBRSAHandler.h"
#import "HQRSA.h"
static NSMutableData *totaldata ;

@implementation HFSUtility
{
    NSMutableString *rtnrsastring;

}
+(NSString *)getAppVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

+(NSString *)getSystemVersion {
    return [UIDevice currentDevice].systemVersion;
}

//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile {
    //手机号以13， 15，18，17开头，八个 \d 数字字符
    NSString *phoneRegex = @"^13[0-9]{1}[0-9]{8}$|14[0-9]{1}[0-9]{8}$|15[0-9]{1}[0-9]{8}$|17[0-9]{1}[0-9]{8}$|18[0-9]{1}[0-9]{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

//邮箱验证
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//邮编验证
+ (BOOL) validatePostCode:(NSString *)code {
    NSString *codeRegex = @"^[1-9][0-9]{5}$";
    NSPredicate *codeText = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", codeRegex];
    return [codeText evaluateWithObject:code];
}

//昵称验证
+ (BOOL) validatePostName:(NSString *)name {
    NSString *nameRegex = @"^[a-zA-Z0-9\u4e00-\u9fa5_-]{2,20}$";
    NSPredicate *nameText = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex];
    return [nameText evaluateWithObject:name];
}

+ (BOOL)hasUserLogin {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *acccessToken = [userDefaults stringForKey:kUSERDEFAULT_ACCCESSTOKEN];
    if (!acccessToken) {
        return NO;
    }
    return YES;
}

+ (NSString *) GUID {
    CFUUIDRef guid_ref = CFUUIDCreate(NULL);
    CFStringRef guid_string_ref= CFUUIDCreateString(NULL, guid_ref);
    
    CFRelease(guid_ref);
    NSString *guid = [NSString stringWithString:(__bridge NSString*)guid_string_ref];
    
    CFRelease(guid_string_ref);
    return guid;
}

+ (NSAttributedString *)deletString:(NSString *)str{

    NSUInteger length = [str length];
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:str];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
//    [attri addAttribute:NSStrikethroughColorAttributeName value:UIColorFromRGB(0x999999, 1) range:NSMakeRange(0, length)];
    return attri;
}
// Get IP Address
+ (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

+ (void)changeUserInfoFromDic:(NSDictionary *)dic{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //用户的手机号，登录账号
    if (dic[@"phonenum"]) {
        [userDefaults setObject:dic[@"phonenum"] forKey:kUSERDEFAULT_USERPHONE];
    }

    //用户的ID
//    [userDefaults setObject:dic[@""] forKey:kUSERDEFAULT_USERID];
    //用户的姓名
    if (dic[@"username"]) {
        [userDefaults setObject:dic[@"username"] forKey:kUSERDEFAULT_USERNAME];
    }
    //用户的性别
    if (dic[@"sex"]) {
        [userDefaults setObject:dic[@"sex"] forKey:kUSERDEFAULT_USERSEX];
    }
    //用户的地址
    if (dic[@"address"]) {
        [userDefaults setObject:dic[@"address"] forKey:kUSERDEFAULT_USERADRESS];
    }
    //用户的生日
    if (dic[@"birth"]) {
        [userDefaults setObject:dic[@"birth"] forKey:kUSERDEFAULT_USERBIRTH];
    }
    //医生医院
    if (dic[@"hospital"]) {
        [userDefaults setObject:dic[@"hospital"] forKey:kUSERDEFAULT_USERHOSPITAL];
    }
    //医生职位
    if (dic[@"jobpostion"]) {
        [userDefaults setObject:dic[@"jobpostion"] forKey:kUSERDEFAULT_USERJOBPOSITION];
    }
    
    if (!dic) {//这个作退出操作
        NSArray *keyArr = @[kUSERDEFAULT_USERPHONE,
                            kUSERDEFAULT_USERID,
                            kUSERDEFAULT_USERNAME,
                            kUSERDEFAULT_USERSEX,
                            kUSERDEFAULT_USERADRESS,
                            kUSERDEFAULT_USERBIRTH,
                            kUSERDEFAULT_USERHOSPITAL,
                            kUSERDEFAULT_USERJOBPOSITION,
                            kUSERDEFAULT_USERAVATOR,
                            kUSERDEFAULT_ACCCESSTOKEN,
                            kUSERDEFAULT_RONGCLOUDTOKEN,
                            kUSERDEFAULT_LOGINTYPE];
        
        for (NSString * keyStr in keyArr) {
            [userDefaults removeObjectForKey:keyStr];
        }
        
    }
    
}

+(NSInteger)ageFromBirthStr:(NSString *)birth{
    NSInteger age = 0;
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [df dateFromString:birth];
    
    // 出生日期转换 年月日
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    NSInteger brithDateYear  = [components1 year];
    NSInteger brithDateDay   = [components1 day];
    NSInteger brithDateMonth = [components1 month];
    
    // 获取系统当前 年月日
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger currentDateYear  = [components2 year];
    NSInteger currentDateDay   = [components2 day];
    NSInteger currentDateMonth = [components2 month];
    
    // 计算年龄
    age = currentDateYear - brithDateYear - 1;
    if ((currentDateMonth > brithDateMonth) || (currentDateMonth == brithDateMonth && currentDateDay >= brithDateDay)) {
        age++;
    }
    
    return age;
}

//返回添加sign后的字典
+(NSDictionary *)SIGNDic:(NSDictionary *)dic{
    
    NSMutableDictionary *tempdic = [[NSMutableDictionary alloc]initWithDictionary:dic];
    
    NSMutableString *orderSpec = [NSMutableString string];
    NSArray *sortedKeys = [dic.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 caseInsensitiveCompare:obj2];
    }];
    for (NSString *key in sortedKeys) {
        [orderSpec appendFormat:@"%@=%@&", key, [dic objectForKey:key]];
    }
    
    HBRSAHandler* handler = [HBRSAHandler new];
    [handler importKeyWithType:KeyTypePrivate andkeyString:private_key_string];
    [handler importKeyWithType:KeyTypePublic andkeyString:public_key_string];
//    NSLog(@"sign string %@",[handler signString:@"123456"] );
    [tempdic setObject:[handler signString:orderSpec] forKey:@"sign"];
    
    return tempdic;
    
}

HBRSAHandler* handler;
NSString * const private_key_string = @"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAK3mvqA4VMRkbUUvlOeTd5njYLlV/5FtX3q8NzBrbP7LfhGXHz57fFklashaKkNAv2i/9CxNtlc7e2t5GDn4yMJzoXnmdPWHOwy4ZeJj0+aqznlnknkoB1UqBAMRN23FZLMTLhTfoIov1LHeR1HzyTjVoQaWQidnlAxw29SgqHu5AgMBAAECgYAMjEkuPK5SJvhy/PBSxuNjB2MB8IyCuPiCHc1iKSg52ONZf9TtcGHcOVzThN0GkggVtf8XiMp60CQTUM8wlKzgq51hkR3+xFgBIK/QLi3I2iQ31y+/dB1DNaD7bAggVRI4guOOQnUiSljOFQEBPERBrtrUBnziU9Kdg6RZQRUogQJBANWcdA7SpjSHY+D6bLfPkb9l8bTLpfl7iPFfj0V4outd2VfMgYYyN8EDkFRaWVdCctBpOIg9g6cdarE2IopPYIECQQDQaQPJBxGtnwdYTllFg2SP3IQvSJSDj5qA8Yncs1tbDkvkGdhDWy9qPntW8Fkx3BLP9G7Y3mVqyJaYqCTmHH85AkABogmNF3Unz6Um0iNEoHSXxvq7DBd/ub8JQVbCDDMKo5QGxMx0ryuX8SQIUQx/y0U/bJ5/BCFehK4NHsHS1tqBAkBJjEXhs7TxaKXW7A9lELF0c4XSifKfWxZTWuokEMe0op71qIlBe/SHsfUlATz484lQChr0Pcfcn11GElCzRGtBAkAzZ7BiIOAI9X0GLvKyvp7AhqkchKONo9JAbEF/cQQ3qTMHcqwcMUic+eAviEpSt7xgoYzbB86RLmpsHfhJv3/c";

 NSString* const public_key_string = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCSE+Pq8j6gGNi8VI26xyJXm4WO6tXRgFobCQc94xlRjzia/4BSJ4uNjmXX+4MKOXxEbzt3UZENgRWsZ7wSMH2em5zjrqxX5y1gJXOikhfheerq20Tsp33llJA463Ndrhfy5lZPVfHzJZ0GsUniUbeEDri3O3fgYDyleSvborqRCwIDAQAB";
//返回RSA加密的字符串
+(NSData *)RSADicToData:(NSDictionary *)dic01{
    
    NSDictionary *dic = [HFSUtility SIGNDic:dic01];
    
    NSString *jsonst = [self DataTOjsonString:dic];
    NSData* data = [jsonst dataUsingEncoding:NSUTF8StringEncoding];
    if (!totaldata) {
        totaldata = [[NSMutableData alloc] init];
    }
    else{
        [totaldata setLength:0];
    }
    NSData *signeddata = [self sectionRSASecret:data];

    return signeddata;
}

+(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}


+(NSData *)sectionRSASecret:(NSData*)tempstr
{
    
    NSData *rest;
    if (tempstr.length>117) {
        NSData *signd = [tempstr subdataWithRange:NSMakeRange(0, 117)];
        rest = [tempstr subdataWithRange:NSMakeRange(117, tempstr.length-117)];
        NSData *tempdata =[HQRSA encryptData:signd publicKey:public_key_string];
        [totaldata appendData:tempdata];
        [self sectionRSASecret:rest];
    }
    else{
        NSData *tempdata =[HQRSA encryptData:tempstr publicKey:public_key_string];
        [totaldata appendData:tempdata];
    }
    return totaldata;
}

-(void)RsaDicToStr:(NSDictionary *)dic01{
    
    NSDictionary *dic = [HFSUtility SIGNDic:dic01];
    
    NSMutableString *orderSpec = [NSMutableString string];
    NSArray *sortedKeys = [dic.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 caseInsensitiveCompare:obj2];
    }];
    for (NSString *key in sortedKeys) {
        [orderSpec appendFormat:@"&%@=%@", key, [dic objectForKey:key]];
    }
    
    NSString * tempStr = [NSString stringWithFormat:@"%@",[orderSpec substringFromIndex:1]];
    NSString* private_key_string = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAMDRUyA9+5cobyB+3+GSyMOam/SjMPCekMRwLqq3kTUs+aAOBIxk81LzSYmvglmfjss7mJu++DLjSHVKbEE1shJX7lwd6/IV+wkigIQxS1sJgJUqLQLYZ405k0ua/L8cPZTxhuIbWG+xqolArqNld21ewsW9am0qMGpH0fRmxyk/AgMBAAECgYEAsIe0xEMbMWQKgcTG8j2x4yuM9yflaZay0bYnc5MGtZmMnVXYIjVWdK5auFzgSW+Ei1rvuD/Z+rUNpJzTicxAT2LV40AGx3v85bn/P8eP8RYnIPDZhVYyJm5TXXQdjIsQoCdopt1JJgv7LUmwANzpTGLnqpnCA3ahYZjwWGduAEkCQQD8nwLTNoMXqsCRu8ilF0Ql7/KRDBtktYosZQcMuLAeIAF9JSuKsCcdTr8vnM9ZxUKByeXHXTCqYOaByg6Au8izAkEAw2WLEyhTmCX6JEPJ28+QznYjogW85wLFibcJ6eDQkvEz1N8f0WcjxEwMd+Fr4ro4tAEMKDCrYY11VYMvIrwrRQJAUFKm7U155T6PuEbDB2scagufTutQknb+lhsRYMQgi5OVpZr5+0EDTthJBfSQIXUNLoNpojhJTwM8h6wdbGVI7QJAKTjI6Fe/mv+YEAKFGWxmvkfKKKpROeMpzW3iF4coOXfNWYFg8wpxTz5D+x6BZimnQMJf0DLEVSZEtK+iSA+uiQJBALsHTE1pvmbvIx61KxHj4mmNvL7ZQmbWUIwyFZkURYEaROb3IK3t7Ah1K1yKD7CEdz4rVAWR4v/B8Fi7jiqhnEo=";
    
    NSString* public_key_string = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCt5r6gOFTEZG1FL5Tnk3eZ42C5Vf+RbV96vDcwa2z+y34Rlx8+e3xZJWrIWipDQL9ov/QsTbZXO3treRg5+MjCc6F55nT1hzsMuGXiY9Pmqs55Z5J5KAdVKgQDETdtxWSzEy4U36CKL9Sx3kdR88k41aEGlkInZ5QMcNvUoKh7uQIDAQAB";
    
    handler = [HBRSAHandler new];
    [handler importKeyWithType:KeyTypePrivate andkeyString:private_key_string];
    [handler importKeyWithType:KeyTypePublic andkeyString:public_key_string];
    
}

-(NSString *)getSignedString
{
    return rtnrsastring;
}


+(UIColor *) hexStringToColor: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    
    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


//+(NSString *)JSONString:(NSString *)aString {
//    NSMutableString *s = [NSMutableString stringWithString:aString];
//    [s replaceOccurrencesOfString:@"\"" withString:@"\\\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
//    [s replaceOccurrencesOfString:@"/" withString:@"\\/" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
//    [s replaceOccurrencesOfString:@"\n" withString:@"\\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
//    [s replaceOccurrencesOfString:@"\b" withString:@"\\b" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
//    [s replaceOccurrencesOfString:@"\f" withString:@"\\f" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
//    [s replaceOccurrencesOfString:@"\r" withString:@"\\r" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
//    [s replaceOccurrencesOfString:@"\t" withString:@"\\t" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
//    return [NSString stringWithString:s];
//}

@end
