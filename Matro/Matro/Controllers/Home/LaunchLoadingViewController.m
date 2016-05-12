//
//  LaunchLoadingViewController.m
//  Matro
//
//  Created by 陈文娟 on 16/4/26.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "LaunchLoadingViewController.h"

@interface LaunchLoadingViewController ()

@end

@implementation LaunchLoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loadingSpinner.lineWidth = 10;
    [self.loadingSpinner startAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
