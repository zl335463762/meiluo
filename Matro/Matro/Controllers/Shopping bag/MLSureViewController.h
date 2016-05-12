//
//  MLSureViewController.h
//  Matro
//
//  Created by NN on 16/3/28.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"

@interface MLSureViewController : MLBaseViewController
@property(nonatomic,retain) NSDictionary *paramDic;
@property(nonatomic,retain) NSDictionary *invoceDic;
@property(nonatomic) BOOL isGlobalShop;
@property(nonatomic) BOOL isfromdetail; //只会有一个参数
@property(nonatomic,retain) NSArray *shopsary;
@property (weak, nonatomic) IBOutlet UILabel *totalShoppingLabel;

- (IBAction)editAdressAction:(id)sender;
- (IBAction)selInvoiceAction:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shenfenzHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shuieHeight;
@property (weak, nonatomic) IBOutlet UIView *shuiebgView;

@end
