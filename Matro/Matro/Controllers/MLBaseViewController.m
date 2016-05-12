//
//  MLBaseViewController.m
//  Matro
//
//  Created by NN on 16/2/26.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"
#import "AppDelegate.h"
#import "UIColor+HeinQi.h"

@interface MLBaseViewController ()

@end

@implementation MLBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _hud = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:_hud];
    //UIBarButtonItemStyleBordered
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@""  style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:item];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
}

- (AppDelegate *)getAppDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)alert:(NSString *)title msg:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
}

@end
