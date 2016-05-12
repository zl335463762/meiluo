//
//  GJCircleViewController.m
//  NnGJTry
//
//  Created by NN on 16/2/26.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#ifndef HFSConstants_h
#define HFSConstants_h

#define SERVICE_BASE_URL @"http://app-test.matrojp.com/P2MLinkCenter/"
#define SERVICE_BASEPAY_URL @"http://app-test.matrojp.com/PayCenter/"
#define SERVICE_GETBASE_URL @"http://61.155.212.163:81/"

#define DOCUMENT_FOLDER_PATH    (NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0])

#define APP_ID @"testapp2"
#define NONCE_STR @"12345678"

#define MAIN_TINT_COLOR     @"#FFFFFF"

#define MAIN_SCREEN_WIDTH   ([UIScreen mainScreen].bounds.size.width)
#define MAIN_SCREEN_HEIGHT  ([UIScreen mainScreen].bounds.size.height)

// Notifications
#define NOTIFICATION_GOTO_PROD_DETAILS @"NOTIFICATION_GOTO_PROD_DETAILS"
//#define NOTIFICATION_GOTO_MEAL_DETAILS @"NOTIFICATION_GOTO_MEAL_DETAILS"
//#define NOTIFICATION_GOTO_NEWS_DETAILS @"NOTIFICATION_GOTO_NEWS_DETAILS"
#define NOTIFICATION_GOTO_ODRE_LISTS   @"NOTIFICATION_GOTO_ODRE_LISTS"
//#define NOTIFICATION_UPDATA_PROFILE_UI @"NOTIFICATION_UPDATA_PROFILE_UI"
#define NOTIFICATION_WEICHAT_PAY_SUCCESS @"NOTIFICATION_WEICHAT_PAY_SUCCESS"
#define NOTIFICATION_WEICHAT_PAY_FAIL @"NOTIFICATION_WEICHAT_PAY_FAIL"

//#define WECHAT_MCH_ID @""
//#define WECHAT_PARTNER_ID @""
//#define WECHAT_NOTIFY_URL @""
//#define WECHAT_SP_URL @""
//
#define WECHAT_APP_ID @"wx220f2459690a865b"
#define WECHAT_APP_SECRET @"d4624c36b6795d1d99dcf0547af5443d"

#define SHARE_APP_KEY @"e5cccbc5912a"
#define SHARE_APP_SECRET @"aa81c9f15d62695dbf821e053b6f6d46"

#define TENCENT_APP_ID @"100371282"
#define TENCENT_APP_SECRET @"aed9b0303e3ed1e27bae87c33761161d"
//
//#define BUGLY_APP_ID @"900008207"
//
#define SMS_APP_ID @"e5c8612eb410"
#define SMS_APP_SECRET @"01af4d357271852e7a73d36fc23703c6"

#define kUSERDEFAULT_USERNAME              @"USER_NAME"
#define kUSERDEFAULT_USERID                @"USER_ID"
#define kUSERDEFAULT_USERCARDNO            @"USER_CARDNO"
#define kUSERDEFAULT_USERSEX               @"USER_SEX"
#define kUSERDEFAULT_USERADRESS            @"USER_USERADRESS"
#define kUSERDEFAULT_USERPHONE             @"USER_PHONE"
#define kUSERDEFAULT_USERBIRTH             @"USER_BIRTH"
#define kUSERDEFAULT_USERHOSPITAL          @"USER_HOSPITAL "
#define kUSERDEFAULT_USERJOBPOSITION       @"USER_JOBPOSITION "
#define kUSERDEFAULT_USERAVATOR            @"USER_AVATOR"

#define kUSERDEFAULT_FRISTUSER             @"FRISTUSER"
#define kUSERDEFAULT_ACCCESSTOKEN          @"ACCCESS_TOKEN"
#define kUSERDEFAULT_RONGCLOUDTOKEN        @"RONGCLOUDTOKEN"
#define kUSERDEFAULT_USERHEADER            @"ACCCESS_USERHEADER"
#define kUSERDEFAULT_USERDATA              @"USERDEFAULT_USERDATA"
#define kUSERDEFAULT_LOGINTYPE             @"USERDEFAULT_LOGINTYPE"

#define kHOME_VIEW_FILE_VRESION            @"HOME_VIEW_FILE_VRESION"
#define kUSERDEFAULT_BASE_URL              @"USERDEFAULT_BASE_URL"
#define ZIP_FILE_NAME                      @"home_html"




typedef NS_ENUM(NSUInteger, PaymentType) {
    ALIPAY = 1,
    WECHATPAY = 2,
    UNIONPAY = 3
};

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define PLACEHOLDER_IMAGE [UIImage imageNamed:@"imageloading"]

#endif /* HFSConstants_h */
