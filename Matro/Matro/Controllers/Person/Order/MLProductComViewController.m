//
//  MLProductComViewController.m
//  Matro
//
//  Created by 黄裕华 on 16/5/5.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLProductComViewController.h"
@interface MLProductComViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *bgScroll;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@end

@implementation MLProductComViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat contentH = _contentView.frame.size.height;
    _contentView.frame = CGRectMake(0, 0,MAIN_SCREEN_WIDTH , contentH);
    _bgScroll.contentSize = CGSizeMake(MAIN_SCREEN_WIDTH, contentH);
    [_bgScroll addSubview:_contentView];
    
    
    self.textView.layer.cornerRadius = 3.f;
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.borderWidth = 1.f;
    self.textView.layer.borderColor = RGBA(245, 245, 245, 1).CGColor;
    self.textView.placeholder = @"请写下您的购物体会，为其他小伙伴提供参考";
    
    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)endEditing:(id)sender {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
