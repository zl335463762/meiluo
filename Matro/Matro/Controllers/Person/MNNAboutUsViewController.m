//
//  MNNAboutUsViewController.m
//  Matro
//
//  Created by benssen on 16/3/30.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MNNAboutUsViewController.h"

@interface MNNAboutUsViewController () {
    UIScrollView *_scrollView;
}

@end

@implementation MNNAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+50);
    [self.view addSubview:_scrollView];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.view.frame.size.width, 30)];
    titleLabel.text = @"欢迎来到美罗全球精品购";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:titleLabel];
    UILabel *introduceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLabel.frame)+20, self.view.frame.size.width-20, 100)];
    introduceLabel.text = @"  美罗全球精品购隶属于苏州函数集团，与2015年成立，旨在让更多人享受到美罗的全球精品。\n\n  美罗全球精品购秉承100%官方正品，分享全球精品的时尚智选理念，与多个国际知名品牌形成官方授权合作，打造成为时尚精品网站的领导者。";
    introduceLabel.font = [UIFont systemFontOfSize:12];
    introduceLabel.numberOfLines = 0;
    [_scrollView addSubview:introduceLabel];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    imageView.center = CGPointMake(self.view.frame.size.width/2, CGRectGetMaxY(introduceLabel.frame)+70);
//    imageView.image = [UIImage imageNamed:@""];
    imageView.backgroundColor = [UIColor greenColor];
    [_scrollView addSubview:imageView];
    UILabel *promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(imageView.frame)-30, CGRectGetMaxY(imageView.frame)+10, 160, 60)];
    promptLabel.text = @"扫描二维码让您的朋友也可以下载美罗全球购APP";
    promptLabel.font = [UIFont systemFontOfSize:14];
    promptLabel.numberOfLines = 0;
    promptLabel.alpha = 0.5;
    [_scrollView addSubview:promptLabel];
    // Do any additional setup after loading the view.
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
