//
//  MLPersonViewController.m
//  Matro
//
//  Created by NN on 16/3/20.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLPersonViewController.h"
#import "UIButton+HeinQi.h"
#import "HFSConstants.h"

#import "MLLoginViewController.h"
#import "MLAddressListViewController.h"
#import "HFSOrderListViewController.h"
#import "MNNManagementViewController.h"
#import "APPSettingViewController.h"
#import "MNNMemberViewController.h"
#import "MLFootprintViewController.h"
#import "MLCollectionViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "MyAddressManagerViewController.h"

//#import "MLHYHTableViewController.h"

@interface MLPersonViewController ()
{
    NSString *loginid;
}

@property (weak, nonatomic) IBOutlet UIScrollView *quanJuScrollView;

//uiview的高度约束
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *loginBgViewHConstraint;

//uiview的宽度的约束
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *loginBgViewWConstraint;

@property (strong, nonatomic) IBOutlet UILabel *viplevelLabel;
//头像
@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;
@property (strong, nonatomic) IBOutlet UIImageView *vipImageView;
//登录按钮
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

@property (strong, nonatomic) IBOutlet UIButton *setInfoButton;
@property (strong, nonatomic) IBOutlet UIImageView *infoImageView;

//代发货
@property (strong, nonatomic) IBOutlet UIButton *paymentButton;
//待收货
@property (strong, nonatomic) IBOutlet UIButton *delivergoodsButton;
//待付款
@property (strong, nonatomic) IBOutlet UIButton *harvestButton;

@property (strong, nonatomic) IBOutlet UIView *numBgView;
//退货、退款
@property (weak, nonatomic) IBOutlet UIButton *returngoodsButton;

@property (strong, nonatomic) IBOutlet UIControl *paymentBgView;
@property (strong, nonatomic) IBOutlet UIControl *onshipBgView;
@property (strong, nonatomic) IBOutlet UIControl *sipnBgView;

@property (weak, nonatomic) IBOutlet UIView *notloginView;

@property (weak, nonatomic) IBOutlet UILabel *nicknameLb;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *buttonBgViewWConstraint;
@property (strong, nonatomic) IBOutlet UILabel *voucherLabel;
@end

@implementation MLPersonViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotordersLists:) name:NOTIFICATION_GOTO_ODRE_LISTS object:nil];
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"个人中心";
    //设置按钮里图片与文字之间关系的方法
    [_paymentButton centerImageAndTitleWithSpace:4];
    [_delivergoodsButton centerImageAndTitleWithSpace:4];
    [_harvestButton centerImageAndTitleWithSpace:4];
    [_returngoodsButton centerImageAndTitleWithSpace:4];
    
    _headerImageView.layer.masksToBounds = YES;
    _headerImageView.layer.cornerRadius = 35.0f;
    _headerImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _headerImageView.layer.borderWidth = 2.0f;
    self.vipcardBgView.hidden = YES;
    self.vipcardHeight.constant = 0;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    loginid = [userDefaults objectForKey:kUSERDEFAULT_USERID];
    NSString *avatorurl = [userDefaults objectForKey:kUSERDEFAULT_USERAVATOR];
    if (loginid && ![@"" isEqualToString:loginid]) {
        self.notloginView.hidden = YES;
    }
    else{
        self.notloginView.hidden = NO;
    }
    NSString *nickname = [userDefaults objectForKey:kUSERDEFAULT_USERNAME];
    if (nickname && ![@"" isEqualToString:nickname]) {
        self.nicknameLb.text = nickname;
        self.nicknameLb.hidden = NO;
    }
    else
    {
        self.nicknameLb.hidden = YES;

    }
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:avatorurl] placeholderImage:[UIImage imageNamed:@"weidenglu_touxiang"]];


    //去掉弹簧效果
    _quanJuScrollView.bounces = NO;
    //隐藏垂直的滚动条
    _quanJuScrollView.showsVerticalScrollIndicator = NO;
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    _loginBgViewHConstraint.constant = MAIN_SCREEN_HEIGHT + 10;
    
    if (_loginBgViewHConstraint.constant < 580) {
        _loginBgViewHConstraint.constant = 580;
    }
    
    _loginBgViewWConstraint.constant = MAIN_SCREEN_WIDTH;
    _buttonBgViewWConstraint.constant = MAIN_SCREEN_WIDTH/12;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)gotordersLists:(NSNotification *)obj{
    HFSOrderListViewController *orderListViewController = [[HFSOrderListViewController alloc]init];
    
    NSInteger tag = 0;
    orderListViewController.typeInteger = tag;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderListViewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (IBAction)loginButtonAction:(id)sender {
    NSString *typeStr = ((UIButton *)sender).titleLabel.text;
    
    MLLoginViewController *vc = [[MLLoginViewController alloc]init];
    
    if ([typeStr isEqualToString:@"登录"]) {
        vc.isLogin = YES;
    }else{
        vc.isLogin = NO;
    }
    
    MLNavigationController *nvc = [[MLNavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:^{
        
    }];
}
-(void)showError
{
    [_hud show:YES];
    _hud.mode = MBProgressHUDModeText;
    _hud.labelText = @"请先登录";
    [_hud hide:YES afterDelay:2];
}

//账户管理
- (IBAction)managementAction:(id)sender {
    if (!loginid) {
        [self showError];
        return;
    }
    self.hidesBottomBarWhenPushed = YES;
    MNNManagementViewController *managementVC = [[MNNManagementViewController alloc] init];
    [self.navigationController pushViewController:managementVC animated:YES];
    /*
    [self presentViewController:managementVC animated:YES completion:^{
     
    }];
     */
    self.hidesBottomBarWhenPushed = NO;
}
//商品收藏
- (IBAction)collectionAction:(id)sender {
    if (!loginid) {
        [self showError];
        return;
    }
    self.hidesBottomBarWhenPushed = YES;
    MLCollectionViewController *vc = [MLCollectionViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

//收货地址
- (IBAction)addressAction:(id)sender {
    if (!loginid) {
        [self showError];
        return;
    }
    MyAddressManagerViewController *vc = [[MyAddressManagerViewController alloc]init];
//    vc.delegate = nil;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

//会员卡
- (IBAction)memberAction:(id)sender {
    if (!loginid) {
        [self showError];
        return;
    }
    self.hidesBottomBarWhenPushed = YES;
    MNNMemberViewController *memberVC = [MNNMemberViewController new];
    [self.navigationController pushViewController:memberVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
//客户服务
- (IBAction)customerServeAction:(id)sender {
    MyTestViewController * vc = [[MyTestViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
//浏览足迹
- (IBAction)lookPrintAction:(id)sender {
    if (!loginid) {
        [self showError];
        return;
    }
    MLFootprintViewController *vc = [[MLFootprintViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}
//设置
- (IBAction)seetingAction:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    APPSettingViewController *settingVC = [APPSettingViewController new];
    [self.navigationController pushViewController:settingVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
//意见反馈
- (IBAction)feedBackAction:(id)sender {
//    MLHYHTableViewController *vc = [[MLHYHTableViewController alloc]init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
}

//订单状态按钮
- (IBAction)orderTypeButtonAction:(id)sender {
    if (!loginid) {
        [self showError];
        return;
    }
    HFSOrderListViewController *orderListViewController = [[HFSOrderListViewController alloc]init];
    
    NSInteger tag = 0;
    
    if ([sender isKindOfClass:[UIButton class]]) {
        tag = ((UIButton *)sender).tag;
    }else if ([sender isKindOfClass:[UIControl class]]){
        tag = ((UIControl *)sender).tag;
    }
    
    if (tag != 0) {
        switch (tag) {
            case 100://待付款
                orderListViewController.typeInteger = 1;
                break;
            case 101://待发货
                orderListViewController.typeInteger = 2;
                break;
            case 102://待收货
                orderListViewController.typeInteger = 3;
                break;
//            case 103://退款
//                orderListViewController.typeInteger = 4;
//                break;
                
            default:
                
                break;
        }
    }
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderListViewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

@end
