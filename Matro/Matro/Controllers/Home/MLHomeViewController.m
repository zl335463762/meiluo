//
//  MLHomeViewController.m
//  Matro
//
//  Created by NN on 16/3/20.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLHomeViewController.h"
#import "MLLoginViewController.h"
#import "MLSearchViewController.h"
#import "MLGoodsListViewController.h"
#import "HFSConstants.h"
#import "HFSServiceClient.h"
#import "HFSUtility.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "MMMaterialDesignSpinner.h"
#import "MyJSInterface.h"
#import "EasyJSWebView.h"
#import "HFSUtility.h"
#import "MLGoodsDetailsViewController.h"

#import <AVFoundation/AVFoundation.h>

#import "ZBarSDK.h"

@interface MLHomeViewController ()<UISearchBarDelegate,UIGestureRecognizerDelegate,SearchDelegate,UIWebViewDelegate,JSInterfaceDelegate,ZBarReaderDelegate>//用于处理采集信息的代理
{
    AVCaptureSession * session;//输入输出的中间桥梁
}

@property (strong, nonatomic) IBOutlet EasyJSWebView *webView;
//搜索
@property (strong, nonatomic) UISearchBar *searchBar;

@property(nonatomic,strong)UIView *searchView;

@property (weak, nonatomic) IBOutlet MMMaterialDesignSpinner *loadingSpinner;
@property (weak, nonatomic) IBOutlet UIView *loadingBGView;

@end

@implementation MLHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"shouyesaoyisao"] style:UIBarButtonItemStylePlain target:self action:@selector(scanning)];
    self.navigationItem.leftBarButtonItem = left;
    
    //添加边框和提示
    UIView   *frameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 28)] ;
    frameView.layer.borderWidth = 1;
    frameView.layer.borderColor = [[UIColor blackColor] CGColor];

    CGFloat H = frameView.bounds.size.height - 8;
    CGFloat imgW = H;
    CGFloat textW = frameView.bounds.size.width - imgW - 6;
    
    UIImageView *searchImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Magnifying-Class"]];
    UITextField *searchText = [[UITextField alloc] initWithFrame:CGRectMake(imgW + 4, 2, textW, H)];
    searchText.enabled = NO;
    [frameView addSubview:searchImg];
    [frameView addSubview:searchText];
    searchImg.frame = CGRectMake(4 , 4, imgW, imgW);
    searchText.frame = CGRectMake(imgW + 6, 4, textW, H);
    searchText.textColor = [UIColor grayColor];
    searchText.placeholder = @"寻找你想要的商品";
    searchText.font = [UIFont fontWithName:@"Arial" size:15.0f];
    
    self.navigationItem.titleView = frameView;
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [frameView addGestureRecognizer:singleTap];
    
    _loadingSpinner.tintColor = [HFSUtility hexStringToColor:@"#ae8e5d"];
    _loadingSpinner.lineWidth = 5;


    // [_loadingSpinner startAnimating];
    MyJSInterface* interface = [MyJSInterface new];
    interface.delegate = self;
    [self.webView addJavascriptInterfaces:interface WithName:@"_native"];
    [_loadingBGView removeFromSuperview];
    NSString *path = [[DOCUMENT_FOLDER_PATH stringByAppendingPathComponent:ZIP_FILE_NAME] stringByAppendingPathComponent:@"home_html/index.html"];
    NSLog(@"URL路径为：%@",path);
    NSURL *url = [NSURL fileURLWithPath:path];
    //NSURL * url = [NSURL URLWithString:@"http://www.baidu.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:3000];
    [self.webView loadRequest:request];
}

#pragma js点击回调

- (void)homeAction:(NSDictionary*)paramdic
{
    NSLog(@"js回调：%@",paramdic);
    MLGoodsDetailsViewController *vc = [MLGoodsDetailsViewController new];
    vc.paramDic = paramdic;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loginAction{
    MLNavigationController *nvc =[[MLNavigationController alloc]initWithRootViewController:[[MLLoginViewController alloc]init]];
        [self presentViewController:nvc animated:YES completion:^{
    
        }];
}



#pragma mark -- UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer

{
    
    return YES;
    
}

//搜索器的UIView的点击事件
-(void)handleSingleTap:(UITapGestureRecognizer *)sender

{
    
    MLSearchViewController *searchViewController = [[MLSearchViewController alloc]init];
    searchViewController.delegate = self;
    searchViewController.activeViewController = self;
    MLNavigationController *searchNavigationViewController = [[MLNavigationController alloc]initWithRootViewController:searchViewController];
    
    UIViewController *rootViewController = ((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
    [rootViewController addChildViewController:searchNavigationViewController];
    [rootViewController.view addSubview:searchNavigationViewController.view];

}

#pragma mark-SearchDelegate
-(void)SearchText:(NSString *)text{
//    NSLog(@"%@",text);
    MLGoodsListViewController *vc =[[MLGoodsListViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    vc.searchString = text;
    [self.navigationController pushViewController:vc animated:NO];
    self.hidesBottomBarWhenPushed = NO;
}

//-(void)navigationProduct:(int)zdd productid:(NSString*)pid
//{
//    NSLog(@"ddd");
//    
//    MLGoodsDetailsViewController *vc = [MLGoodsDetailsViewController new];
//    self.hidesBottomBarWhenPushed = YES;
//
//    NSDictionary *parmdic = @{@"JMSP_ID":pid,@"ZCSP":[NSString stringWithFormat:@"%d",zdd]};
//    vc.paramDic = parmdic;
//    
//    [self.navigationController pushViewController:vc animated:NO];
//    self.hidesBottomBarWhenPushed = NO;
//}

- (void)scanning{
    //初始化相机控制器
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    //设置代理
    reader.readerDelegate = self;
    //基本适配
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    //二维码/条形码识别设置
    ZBarImageScanner *scanner = reader.scanner;
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    //弹出系统照相机，全屏拍摄
    [self presentModalViewController: reader
                            animated: YES];
}

- (void) readerControllerDidFailToRead: (ZBarReaderController*) reader
                             withRetry: (BOOL) retry{
    
    NSLog(@"%@",reader);
    
}

#pragma mark- UIWebViewDelegate
- (void) webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
}
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [_loadingSpinner stopAnimating];
    self.loadingBGView.hidden = YES;
    [_hud hide:YES];
}
- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.loadingBGView.hidden = YES;
    [_loadingSpinner stopAnimating];
    NSLog(@"didFailLoadWithError:%@", error);
    [_hud show:YES];
    _hud.mode = MBProgressHUDModeText;
    _hud.labelText = @"加载失败";
    [_hud hide:YES afterDelay:2];
}
@end
