//
//  MNNQRCodeViewController.m
//  Matro
//
//  Created by benssen on 16/3/30.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MNNQRCodeViewController.h"

@interface MNNQRCodeViewController ()

@end

@implementation MNNQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会员卡二维码";
    [self createViews];
    // Do any additional setup after loading the view.
}
- (void)createViews {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 20)];
    label.text = @"使用时向服务员出示二维码";
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-200)/2, CGRectGetMaxY(label.frame)+20, 200, 200)];
//    imageView.image = [UIImage imageNamed:@""];
    imageView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:imageView];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+10, self.view.frame.size.width, 20)];
    label1.text = @"每30分钟刷新";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.alpha = 0.5;
    label1.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:label1];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(50, self.view.frame.size.height-30, 100, 20)];
//    view.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:view];
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
