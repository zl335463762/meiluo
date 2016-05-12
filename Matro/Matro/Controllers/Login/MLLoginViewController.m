//
//  MLLoginViewController.m
//  Matro
//
//  Created by NN on 16/3/21.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLLoginViewController.h"
#import "UIColor+HeinQi.h"
#import "UIButton+HeinQi.h"
#import "UIView+HeinQi.h"

#import "MLVIPCardViewController.h"
#import "MLLoginTableViewCell.h"
#import "LoginHistory.h"

#import "HFSConstants.h"
#import "HFSUtility.h"
#import "HFSServiceClient.h"
#import <MagicalRecord/MagicalRecord.h>
#import "WXApi.h"
#import "UMSocial.h"

#import "MLBindPhoneController.h"
#import "MNNModifyPasswordViewController.h"

#define CODE_TIME_KEY @"CODE_TIME_KEY"

@interface MLLoginViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>{
    NSInteger _endTime;
    NSManagedObjectContext *_context;
    NSMutableArray *_accountArray;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *showpasswordButton;
@property (strong, nonatomic) IBOutlet UIButton *showmoreaccoutButton;

@property (strong, nonatomic) IBOutlet UIButton *registerTypeButton;
@property (strong, nonatomic) IBOutlet UIButton *loginTypeButton;

@property (strong, nonatomic) IBOutlet UIView *registerTypeBgView;
@property (strong, nonatomic) IBOutlet UIView *loginTypeBgView;

@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;

//页面没有textField的属性 通过 - (UITextField *)textField:(UIView *)view获取相应textField
@property (strong, nonatomic) IBOutlet UIView *passwordView;
@property (strong, nonatomic) IBOutlet UIView *accountView;
@property (strong, nonatomic) IBOutlet UIView *rphoneView;
@property (strong, nonatomic) IBOutlet UIView *rcodeView;
@property (strong, nonatomic) IBOutlet UIButton *codeButton;
@property (strong, nonatomic) IBOutlet UIView *rpasswordView;
@property (strong, nonatomic) IBOutlet UIView *rrpasswordView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewH;

@property (strong, nonatomic) IBOutlet UIView *qqLoginBgView;
@property (strong, nonatomic) IBOutlet UIView *wxLoginBgView;
@end

@implementation MLLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self loginVCUI];
    
    _accountArray = [[NSMutableArray alloc]initWithArray:@[@"13218102399",@"13218102388"]];
    
    //隐藏键盘
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    tapGestureRecognizer.delegate = self;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    _context = [NSManagedObjectContext MR_defaultContext];
    
    //宋凯测试账号
    [self textField:_accountView].text = @"18550396196";
    [self textField:_passwordView].text =@"123123";
}

- (void)loginVCUI{
    //    UIBarButtonItem *cancel = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Left_Arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    
    self.navigationItem.leftBarButtonItem = cancel;
    
    [_registerTypeButton selButtonType];
    [_loginTypeButton selButtonType];
    
    _loginTypeButton.selected = _isLogin;
    _loginTypeBgView.hidden = !_isLogin;
    
    _registerTypeButton.selected = !_isLogin;
    _registerTypeBgView.hidden = _isLogin;
    
    [_accountView loginType];
    [_passwordView loginType];
    [_rphoneView loginType];
    [_rcodeView loginType];
    [_codeButton loginButtonType];
    [_rpasswordView loginType];
    [_rrpasswordView loginType];
    
    [_loginButton loginButtonType];
    [_registerButton loginButtonType];
    
    [_showmoreaccoutButton setImage:[UIImage imageNamed:@"Left_Arrow_yuan"] forState:UIControlStateNormal];
    [_showpasswordButton setImage:[UIImage imageNamed:@"Eye"] forState:UIControlStateNormal];
    
    [_showmoreaccoutButton setImage:[UIImage imageNamed:@"Left_Arrow_yuan2"] forState:UIControlStateSelected];
    [_showpasswordButton setImage:[UIImage imageNamed:@"Eye2"] forState:UIControlStateSelected];
    
    _tableView.layer.borderWidth = 1.0f;
    _tableView.layer.borderColor = [UIColor colorWithHexString:@"#AE8E5D"].CGColor;
    
    //不支持QQ
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        _qqLoginBgView.hidden = YES;
    }
    
    //不支持微信
    if (![WXApi isWXAppInstalled] || ![WXApi isWXAppSupportApi]) {
        _wxLoginBgView.hidden = YES;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //历史
    [self loadLoginHistory];
    
    //修改导航栏
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        //if iOS 5.0 and later
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"TM.jpg"] forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        UIImageView *imageView = (UIImageView *)[self.navigationController.navigationBar  viewWithTag:10];
        [imageView setBackgroundColor:[UIColor clearColor]];
        if (imageView == nil)
        {
            imageView = [[UIImageView alloc] initWithImage:
                         [UIImage imageNamed:@"TM.jpg"]];
            [imageView setTag:10];
            [self.navigationController.navigationBar  insertSubview:imageView atIndex:0];
        }
    }
    
    [self.navigationController.navigationBar setTranslucent:YES];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector(shadowImage)])
    {
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    }
    
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    //设置是否可以登录
    if ([[self textField:_accountView].text isEqualToString:@""] || [[self textField:_passwordView].text isEqualToString:@""]) {
        _loginButton.enabled = NO;
        [_loginButton setBackgroundImage:[UIImage imageNamed:@"TM.jpg"] forState:UIControlStateNormal];
        _loginButton.backgroundColor = [UIColor clearColor];
        _loginButton.layer.borderWidth = 1.0f;
        _loginButton.layer.borderColor = [UIColor colorWithHexString:@"#AE8E5D"].CGColor;
    }
    
    //短信倒计时
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *tempTime = [userDefaults stringForKey:CODE_TIME_KEY];
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate new] timeIntervalSince1970]];
    if (timeSp) {
        _endTime = 60 - ([timeSp integerValue] - [tempTime integerValue]);
    }
    if (!tempTime ||  _endTime> 60) {
        
        _codeButton.enabled = YES;
        
        _endTime = 0;
    }else{
        _codeButton.enabled = NO;
    }
    
    [self codeTimeCountdown];
    
}

-(void)loadLoginHistory{
    NSArray *historyLoginArray = [LoginHistory MR_findAllInContext:_context];
    _accountArray = [NSMutableArray array];
    for (LoginHistory *loginhHistory in historyLoginArray) {
        
        [_accountArray addObject:loginhHistory.loginkeyword];
        
    }
    [_tableView reloadData];
    _tableViewH.constant = _accountArray.count > 3 ? 3 * 30 : _accountArray.count * 30;
}

//倒计时
-(void)codeTimeCountdown{
    __block NSInteger timeout=_endTime; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                _codeButton.enabled=YES;
                [_codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                
                [_codeButton setBackgroundImage:[UIImage imageNamed:@"quguangguang_button"] forState:UIControlStateNormal];
                _codeButton.backgroundColor = [UIColor clearColor];
                _codeButton.layer.borderWidth = 1.0f;
                _codeButton.layer.borderColor = [UIColor clearColor].CGColor;
            });
        }else{
            int seconds;
            if (timeout==60) {
                seconds=60;
            }else{
                seconds = timeout % 60;
            }
            
            NSString *strTime = [NSString stringWithFormat:@"(%.2d)重新发送",seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                _codeButton.enabled=NO;
                [_codeButton setTitle:strTime forState:UIControlStateNormal];
                
                [_codeButton setBackgroundImage:[UIImage imageNamed:@"TM.jpg"] forState:UIControlStateNormal];
                _codeButton.backgroundColor = [UIColor clearColor];
                _codeButton.layer.borderWidth = 1.0f;
                _codeButton.layer.borderColor = [UIColor colorWithHexString:@"#AE8E5D"].CGColor;
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}


-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
}

- (void)cancelAction{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)findPassClick:(id)sender {
    MNNModifyPasswordViewController *vc = [[MNNModifyPasswordViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


//注册还是登录按钮
- (IBAction)typeButtonAction:(id)sender {
    UIButton * button = (UIButton *)sender;
    if (button.selected) {
        return;
    }
    button.selected = YES;
    if ([button isEqual:_registerTypeButton]) {
        _loginTypeButton.selected = NO;
        _loginTypeBgView.hidden = YES;
        _registerTypeBgView.hidden = NO;
    }else{
        _registerTypeButton.selected = NO;
        _registerTypeBgView.hidden = YES;
        _loginTypeBgView.hidden = NO;
    }
    
}

#pragma mark- 文本框相关

//当前view的输入框
- (UITextField *)textField:(UIView *)view{
    
    UITextField *textfield = nil;
    
    for (id tf in view.subviews) {
        if ([tf isKindOfClass:[UITextField class]]) {
            textfield = (UITextField *)tf;
            break;
        }
    }
    return textfield;
}

//当前的view的清除按钮
- (UIButton *)closeButton:(UITextField *)tf{
    UIButton * button = nil;
    
    for (id bt in tf.superview.subviews) {
        if ([bt isKindOfClass:[UIButton class]] && ((UIButton *)bt).tag == 99) {
            button =((UIButton *)bt);
            break;
        }
    }
    
    return button;
}

- (void)dimissViewControllerAction{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)toolButtonAction:(id)sender {
    
    UIButton *button = ((UIButton *)sender);
    button.selected = !button.selected;
    
    if ([button isEqual:_showpasswordButton]) {
        if (button.selected) {
            NSLog(@"显示密码");
            [self textField:button.superview].secureTextEntry = NO;
        }else{
            NSLog(@"不显示密码");
            [self textField:button.superview].secureTextEntry = YES;
        }
    }else if([button isEqual:_showmoreaccoutButton]){
        if (button.selected) {
            NSLog(@"展开");
            _tableView.hidden = NO;
        }else{
            NSLog(@"收回");
            _tableView.hidden = YES;
            [[self textField:_accountView] resignFirstResponder];
        }
    }
    
}

//清空文本框的X
- (IBAction)closeButtonAction:(id)sender {
    UIView *view = ((UIButton *)sender).superview;
    [self textField:view].text = @"";
    ((UIButton *)sender).hidden = YES;
}

#pragma mark- 注册
//注册按钮
- (IBAction)registerButton:(id)sender {
    
    if ([self canRegister]) {
        [self registerAction];
    }
    
}

-(void)registerAction{
    
    __weak __typeof(&*self)weakSelf =self;
    NSDictionary *dic = @{@"appId":APP_ID,
                          @"nonceStr":NONCE_STR,
                          @"mphone":[self textField:_rphoneView].text,
                          @"vcode":[self textField:_rcodeView].text,
                          @"pwd":[self textField:_rpasswordView].text,
                          };
    
    
    NSData *data = [HFSUtility RSADicToData:dic] ;
    NSString *ret = base64_encode_data(data);
    [[HFSServiceClient sharedClient]POST:@"vip/RegisterUserInfo" parameters:ret success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *result = (NSDictionary *)responseObject;
        NSLog(@"result %@",result);
        if([@"0" isEqualToString:[NSString stringWithFormat:@"%@",result[@"status"]]]){
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"注册成功";
            [_hud hide:YES afterDelay:2];
            
            [weakSelf textField:_rrpasswordView].text = @"";
            [weakSelf textField:_rphoneView].text = @"";
            [weakSelf textField:_rcodeView].text = @"";
            [weakSelf textField:_rpasswordView].text = @"";
            
            _loginTypeButton.selected = YES;
            _loginTypeBgView.hidden = NO;
            _registerTypeBgView.hidden = YES;
            _registerTypeButton.selected = NO;
            
        }else{
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = result[@"msg"];
            [_hud hide:YES afterDelay:2];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        NSLog(@"error kkkk %@",error);
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:2];
    }];
}

-(void)requestPostHttp:(NSString*)url params:(NSData*)params{
    NSURL * URL = [NSURL URLWithString:url];
    
    
//    NSData * postData = [params dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]init];
    [request setHTTPMethod:@"post"]; //指定请求方式
    [request setURL:URL]; //设置请求的地址
    [request setHTTPBody:params];  //设置请求的参数}
//    [request mutableSetValueForKeyPath:<#(nonnull NSString *)#>]
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      //NSData 转NSString
                                      NSString *result  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                      NSLog(@"error %@",result);
                                  }];
    
    [task resume];
}


-(BOOL)canRegister{
    NSString *errStr = nil;
    
    if (![HFSUtility validateMobile:[self textField:_rphoneView].text]) {
        errStr = @"手机号码格式不正确";
    }else if ([self textField:_rcodeView].text.length != 4){
        errStr = @"验证码长度不正确";
    }else if ([self textField:_rpasswordView].text.length < 6 || [self textField:_rpasswordView].text.length > 16){
        errStr = @"密码长度不正确";
    }else if (![[self textField:_rpasswordView].text isEqualToString:[self textField:_rrpasswordView].text]){
        errStr = @"两次输入密码不一致";
    }else{
        errStr = nil;
    }
    
    if (errStr) {
        
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = errStr;
        [_hud hide:YES afterDelay:2];
        
        return NO;
    }
    return YES;
}

#pragma mark- 登录
//登录按钮
- (IBAction)loginButtonAction:(id)sender {
    

    
    NSDictionary *dic = @{@"appId":APP_ID,
                          @"nonceStr":NONCE_STR,
                          @"account":[self textField:_accountView].text,
                          @"pwd":[self textField:_passwordView].text
                          };
    
    NSData *data = [HFSUtility RSADicToData:dic] ;
    NSString *ret = base64_encode_data(data);
    
    [[HFSServiceClient sharedClient] POST:@"vip/AuthUserInfo" parameters:ret success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *result = (NSDictionary *)responseObject;
        NSLog(@"%@",result);
        if([@"0" isEqualToString:[NSString stringWithFormat:@"%@",result[@"status"]]]){
            
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"登录成功";
            [_hud hide:YES afterDelay:2];
            
            // 存储用户信息
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            //存储时，除NSNumber类型使用对应的类型意外，其他的都是使用setObject:forKey:
            [userDefaults setObject:result[@"cardno"] forKey:kUSERDEFAULT_USERCARDNO ];
            if (result[@"headPicUrl"] && ![@"" isEqualToString:result[@"headPicUrl"]]) {
                [userDefaults setObject:result[@"headPicUrl"] forKey:kUSERDEFAULT_USERAVATOR ];

            }
            [userDefaults setObject:result[@"mphone"] forKey:kUSERDEFAULT_USERPHONE ];
            [userDefaults setObject:result[@"nickname"] forKey:kUSERDEFAULT_USERNAME ];
            
            
            [userDefaults setObject:result[@"userId"] forKey:kUSERDEFAULT_USERID ];
            
            
            [userDefaults synchronize];
            
            //保存登录账号下次使用
            LoginHistory *loginHistory = [LoginHistory MR_findFirstByAttribute:@"loginkeyword" withValue:result[@"mphone"] inContext:_context];
            if (!loginHistory) {
                LoginHistory *loginHistory = [LoginHistory MR_createEntityInContext:_context];
                loginHistory.loginkeyword = [self textField:_accountView].text;
                [_context MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
                    [self loadLoginHistory];
                }];
            }
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = result[@"msg"];
            [_hud hide:YES afterDelay:2];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        NSLog(@"error %@",error);
        [_hud hide:YES afterDelay:2];
    }];
//
    
    
}

//快速注册按钮
- (IBAction)fresisterButtonAction:(id)sender {
    _loginTypeButton.selected = NO;
    _loginTypeBgView.hidden = YES;
    _registerTypeBgView.hidden = NO;
    _registerTypeButton.selected = YES;
}
- (IBAction)vipLoginButtonAction:(id)sender {
    
#warning 直接登录还是跳VIP界面
    
    MLVIPCardViewController *vc = [[MLVIPCardViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    //    [_hud show:YES];
    //    _hud.mode = MBProgressHUDModeText;
    //    _hud.labelText = @"VIP登录";
    //    [_hud hide:YES afterDelay:2];
    //
    //    [self performSelector:@selector(dimissViewControllerAction) withObject:nil afterDelay:2.0f];
}
- (IBAction)qqLoginButtonAction:(id)sender {
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            
//            NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
            
            NSDictionary *dict = @{@"nickname":snsAccount.userName?:@"",@"headPicUrl":snsAccount.iconURL?:@"",@"sorce":@"QQ",@"partnerId":snsAccount.openId};
            
            [self loginWxAndQQWithParams:dict];
            
        }});
    
    
    [_hud show:YES];
    _hud.mode = MBProgressHUDModeText;
    _hud.labelText = @"qq登录";
    [_hud hide:YES afterDelay:2];
    
    [self performSelector:@selector(dimissViewControllerAction) withObject:nil afterDelay:2.0f];
}
- (IBAction)wxLoginButtonAction:(id)sender {
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            
            
//            NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
            
            NSDictionary *dict = @{@"nickname":snsAccount.userName?:@"",@"headPicUrl":snsAccount.iconURL?:@"",@"sorce":@"WECHAT",@"partnerId":snsAccount.openId};
            
            [self loginWxAndQQWithParams:dict];
            
            
        }
    });

//    [_hud show:YES];
//    _hud.mode = MBProgressHUDModeText;
//    _hud.labelText = @"微信登录";
//    [_hud hide:YES afterDelay:2];
//    
//    [self performSelector:@selector(dimissViewControllerAction) withObject:nil afterDelay:2.0f];
}


- (void)loginWxAndQQWithParams:(NSDictionary *)params{
    NSData *data = [HFSUtility RSADicToData:params] ;
    NSString *ret = base64_encode_data(data);
    
    [[HFSServiceClient sharedClient] POST:@"vip/ThirdPartyLoginIn" parameters:ret success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result objectForKey:@"userId"]) {//如果有userId说明第三方登录成功
            
        }
        else{//如果没有调到绑定页面
            MLBindPhoneController *vc = [[MLBindPhoneController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        NSLog(@"error %@",error);
        [_hud hide:YES afterDelay:2];
    }];
}

#pragma mark- 验证码
//验证码按钮
- (IBAction)codeButtonAction:(id)sender {
    
    [_hud show:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = @"";
    
    if ([HFSUtility validateMobile:[self textField:_rphoneView].text]) {
        
        NSDictionary *dic = @{
                              @"nonceStr":NONCE_STR,
                              @"appId":APP_ID,
                              @"account":[self textField:_rphoneView].text,
                              
                              };
        
        NSData *data = [HFSUtility RSADicToData:dic] ;
        NSString *ret = base64_encode_data(data);
        
        [[HFSServiceClient sharedClient]POST:@"vip/CheckAccountExist" parameters:ret success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *result = (NSDictionary *)responseObject;
            
            if([@"1" isEqualToString:[NSString stringWithFormat:@"%@",result[@"status"]]]){//这不是我们的会员，可以用来注册
                [self getValidateCode];//发验证码
            }else{
                [_hud show:YES];
                _hud.mode = MBProgressHUDModeText;
                _hud.labelText = result[@"cardlist"][0][@"msg"];
                [_hud hide:YES afterDelay:2];
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"请求失败";
            [_hud hide:YES afterDelay:2];
        }];
        
    }else{
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请输入正确的手机号码";
        [_hud hide:YES afterDelay:2];
    }
    
}
//发送验证码
-(void)getValidateCode{
    
    
    [[HFSServiceClient sharedJSONClientwithurl:SERVICE_BASE_URL]POST:@"common/sendsms" parameters:@{@"mphone":[self textField:_rphoneView].text,@"content":@"",@"vcode":@""} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
                                                                                
        if([@"0" isEqualToString:[NSString stringWithFormat:@"%@",result[@"status"]]]){
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"验证码已发送，请注意查收";
            [_hud hide:YES afterDelay:2];
            _endTime = 60;
            [self codeTimeCountdown];
                                                                                    
        }else{
                [_hud show:YES];
                _hud.mode = MBProgressHUDModeText;
                _hud.labelText = result[@"msg"];
                [_hud hide:YES afterDelay:2];
        }
                                                                                
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:2];
    }];
    
}

#pragma mark- UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField;{
    if (![textField.text isEqualToString:@""]) {
        [self closeButton:textField].hidden = NO;
    }
    
    if ([textField isEqual:[self textField:_accountView]]) {
        _tableView.hidden = NO;
        _showmoreaccoutButton.selected = YES;
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;{
    
    if (![textField.text isEqualToString:@""]) {
        [self closeButton:textField].hidden = NO;
    }
    
    if ([textField isEqual:[self textField:_accountView]] || [textField isEqual:[self textField:_passwordView]]) {
        if ([[self textField:_accountView].text isEqualToString:@""] || [[self textField:_passwordView].text isEqualToString:@""]) {
            _loginButton.enabled = NO;
            
            [_loginButton setBackgroundImage:[UIImage imageNamed:@"TM.jpg"] forState:UIControlStateNormal];
            _loginButton.backgroundColor = [UIColor clearColor];
            _loginButton.layer.borderWidth = 1.0f;
            _loginButton.layer.borderColor = [UIColor colorWithHexString:@"#AE8E5D"].CGColor;
        }else{
            _loginButton.enabled = YES;
            
            [_loginButton setBackgroundImage:[UIImage imageNamed:@"quguangguang_button"] forState:UIControlStateNormal];
            _loginButton.backgroundColor = [UIColor clearColor];
            _loginButton.layer.borderWidth = 1.0f;
            _loginButton.layer.borderColor = [UIColor clearColor].CGColor;
        }
    }
    
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField; {
    [self closeButton:textField].hidden = YES;
    
    if ([textField isEqual:[self textField:_accountView]]) {
        _tableView.hidden = YES;
        _showmoreaccoutButton.selected = NO;
    }
}

#pragma mark- UITableViewDataSource And UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    return _accountArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    
    static NSString *CellIdentifier = @"MLLoginTableViewCell" ;
    MLLoginTableViewCell *cell = (MLLoginTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    cell.logininfoLabel.text = _accountArray[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self textField:_accountView].text = _accountArray[indexPath.row];
    [[self textField:_accountView] resignFirstResponder];
    _tableView.hidden = YES;
    _showmoreaccoutButton.selected = NO;
    
}

#pragma mark - UIGestureRecognizerDelegate

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //SkyRadiusView 是一个圆角的类的View，在这里使用是为了防止手势冲突
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"SkyRadiusView"]) {
        return NO;
    }
    return  YES;
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
