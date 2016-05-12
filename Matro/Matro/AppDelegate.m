//
//  AppDelegate.m
//  Matro
//
//  Created by NN on 16/3/20.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "AppDelegate.h"
#import "MLHomeViewController.h"
#import "MLClassViewController.h"
#import "MLBagViewController.h"
#import "MLPersonViewController.h"

#import "HFSConstants.h"
#import "UIColor+HeinQi.h"
#import "ZipArchive.h"


#import "WXApi.h"
#import <MagicalRecord/MagicalRecord.h>
#import "MMMaterialDesignSpinner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "HFSUtility.h"

#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"

#import "IQKeyboardManager.h"


@interface AppDelegate ()<UITabBarControllerDelegate,WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self initializeHomePageData];
   
    MMMaterialDesignSpinner *_loadingSpinner = [[MMMaterialDesignSpinner alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-80)/2, ([UIScreen mainScreen].bounds.size.height-80)/2, 80, 80)];
    _loadingSpinner.tintColor = [HFSUtility hexStringToColor:@"#ae8e5d"];
    _loadingSpinner.lineWidth = 5;
    
    [_loadingSpinner startAnimating];

    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UIWindow *mainWindow = delegate.window;
    [mainWindow addSubview:_loadingSpinner];
    
    [UIView animateWithDuration:0.6f delay:0.5f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _loadingSpinner.alpha = 0.0f;
        _loadingSpinner.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.5f, 1.5f, 1.0f);
    } completion:^(BOOL finished) {
        [_loadingSpinner removeFromSuperview];
    }];
    

    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"Model.sqlite"];
    
    /**
     * 推送处理1
     */
    if ([application
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //注册推送, iOS 8
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeAlert |
        UIRemoteNotificationTypeAlert |
        UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }


    [WXApi registerApp:@"wx5aced428a6ce270e"];
    
    
    [UMSocialData setAppKey:@"572b140d67e58e4b9e001422"];
    
    
    [UMSocialQQHandler setQQWithAppId:@"1105292890" appKey:@"ZXqkHJelaBNvrBfK" url:@"http://www.umeng.com/social"];
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wx5aced428a6ce270e" appSecret:@"54e1071ad99428a88330eee8489fb37c" url:@"http://www.umeng.com/social"];
    [self buildTabBarController];
    
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;

    
    
    self.window.rootViewController = _tabBarController;
    
    return YES;
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
        }];
    }
    if ([url.host isEqualToString:@"pay"])
    {
        return  [WXApi handleOpenURL:url delegate:self];
    }
    if ([url.host isEqualToString:@"oauth"]) {
        return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
    }
    return YES;
}
- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    if ([url.host isEqualToString:@"pay"])
    {
        return  [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
    
}


//支付结果
-(void) onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UMSocialSnsService  applicationDidBecomeActive];}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)initializeHomePageData
{

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *homeHtmlDirectory = [DOCUMENT_FOLDER_PATH stringByAppendingPathComponent:ZIP_FILE_NAME];
    BOOL isDirectory = NO;
    BOOL directoryExists = [fileManager fileExistsAtPath:homeHtmlDirectory isDirectory:&isDirectory];
    
    if (directoryExists) {
        [fileManager removeItemAtPath:homeHtmlDirectory error:nil];
    }
    //                        if (!directoryExists) {
    NSString *zipFilePath = [[NSBundle mainBundle]pathForResource:ZIP_FILE_NAME ofType:@"zip"];
    
    ZipArchive *zipArchive = [[ZipArchive alloc]init];
    if ([zipArchive UnzipOpenFile:zipFilePath]) {
        [zipArchive UnzipFileTo:homeHtmlDirectory overWrite:YES];
        [zipArchive UnzipCloseFile];
    }
}


#pragma mark- 初始化TabBar

- (UITabBarController*)buildTabBarController
{
    MLHomeViewController *homeViewController = [[MLHomeViewController alloc]init];
    homeViewController.title = @"首页";
    MLNavigationController *homeNavigationController = [[MLNavigationController alloc]initWithRootViewController:homeViewController];
    homeNavigationController.tabBarItem.image = [UIImage imageNamed:@"Home2"];
    homeNavigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"Home"];
    homeNavigationController.tabBarItem.title = @"首页";
    
    MLClassViewController *classViewController = [[MLClassViewController alloc]init];
    classViewController.title = @"分类";
    MLNavigationController *classNavigationController = [[MLNavigationController alloc]initWithRootViewController:classViewController];
    classNavigationController.tabBarItem.image = [UIImage imageNamed:@"Starred-List"];
    classNavigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"Starred-List-1"];
    classNavigationController.tabBarItem.title = @"分类";
    
    MLBagViewController *bagViewController = [[MLBagViewController alloc]init];
    bagViewController.title = @"购物袋";
    MLNavigationController *bagNavigationController = [[MLNavigationController alloc]initWithRootViewController:bagViewController];
    bagNavigationController.tabBarItem.image = [UIImage imageNamed:@"Outlined"];
    bagNavigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"Outlined2"];
    bagNavigationController.tabBarItem.title = @"购物袋";
    
    MLPersonViewController *personViewController = [[MLPersonViewController alloc]init];
    personViewController.title = @"我的";
    MLNavigationController *personalNavigationController = [[MLNavigationController alloc]initWithRootViewController:personViewController];
    personalNavigationController.tabBarItem.image = [UIImage imageNamed:@"User"];
    personalNavigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"User-1"];
    personalNavigationController.tabBarItem.title = @"我的";
    
  
    _tabBarController = [[UITabBarController alloc]init];
    [_tabBarController setViewControllers:@[homeNavigationController,classNavigationController, bagNavigationController, personalNavigationController]];
    
    self.tabBarController.delegate = self;
    self.tabBarController.tabBar.tintColor = [UIColor colorWithHexString:@"#AE8E5D"];
    UIView *bgView = [[UIView alloc] initWithFrame:self.tabBarController.tabBar.bounds];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.tabBarController.tabBar insertSubview:bgView atIndex:0];
    self.tabBarController.tabBar.opaque = YES;
    return self.tabBarController;
}


@end
