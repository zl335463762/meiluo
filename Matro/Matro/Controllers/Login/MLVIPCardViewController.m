//
//  MLVIPCardViewController.m
//  Matro
//
//  Created by NN on 16/3/21.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLVIPCardViewController.h"

#import "MLLoginTableViewCell.h"

#import "UIColor+HeinQi.h"
#import "UIButton+HeinQi.h"
#import "UIView+HeinQi.h"

#import "HFSConstants.h"
#import "HFSUtility.h"
#import "HFSServiceClient.h"

#define CODE_TIME_KEY @"CODE_TIME_KEY"

@interface MLVIPCardViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>{
    NSInteger _endTime;
    NSMutableArray *_vipArray;

}
@property (weak, nonatomic) IBOutlet UITextField *vcodeField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;

@property (strong, nonatomic) IBOutlet UIView *vipView;
@property (strong, nonatomic) IBOutlet UIView *rphoneView;
@property (strong, nonatomic) IBOutlet UIView *rcodeView;
@property (strong, nonatomic) IBOutlet UIButton *codeButton;
@property (strong, nonatomic) IBOutlet UIView *rpasswordView;
@property (strong, nonatomic) IBOutlet UIView *rrpasswordView;
@property (strong, nonatomic) IBOutlet UIButton *jihuoButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *showmoreaccoutButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewH;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdField;
@end

@implementation MLVIPCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"美罗VIP卡激活";
    
    _vipArray = [[NSMutableArray alloc]init];
    
    [self vipVCUI];
    //隐藏键盘
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    tapGestureRecognizer.delegate = self;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    [self.codeButton addTarget:self action:@selector(getValidateCode) forControlEvents:UIControlEventTouchUpInside];
    self.vcodeField.delegate = self;
    [self.vcodeField addTarget:self action:@selector(textfieldChange:) forControlEvents:UIControlEventEditingChanged];
}
- (void)vipVCUI{

    [_vipView loginType];
    [_rphoneView loginType];
    [_rcodeView loginType];
    [_codeButton loginButtonType];
    [_rpasswordView loginType];
    [_rrpasswordView loginType];
    
    [_jihuoButton loginButtonType];

    [_showmoreaccoutButton setImage:[UIImage imageNamed:@"Left_Arrow_yuan"] forState:UIControlStateNormal];

    [_showmoreaccoutButton setImage:[UIImage imageNamed:@"Left_Arrow_yuan2"] forState:UIControlStateSelected];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
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
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    _tableView.layer.borderWidth = 1.0f;
    _tableView.layer.borderColor = [UIColor colorWithHexString:@"#AE8E5D"].CGColor;
    _tableViewH.constant = _vipArray.count > 3 ? 3 * 30 : _vipArray.count * 30;
    
#pragma mark- 验证码
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


- (IBAction)toolButtonAction:(id)sender {
    
    UIButton *button = ((UIButton *)sender);
    button.selected = !button.selected;
    
    if (button.selected) {
        NSLog(@"展开");
        _tableView.hidden = NO;
    }else{
        NSLog(@"收回");
        _tableView.hidden = YES;
        [[self textField:_vipView] resignFirstResponder];
    }

 
}

//清空文本框的X
- (IBAction)closeButtonAction:(id)sender {
    UIView *view = ((UIButton *)sender).superview;
    [self textField:view].text = @"";
    ((UIButton *)sender).hidden = YES;
}

#pragma mark- 激活
//注册按钮
- (IBAction)registerButton:(id)sender {
    
    if ([self canRegister]) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"激活成功";
        [_hud hide:YES afterDelay:2];
        
        [self activeVipcard];
        
    }
    
}

-(BOOL)canRegister{
    NSString *errStr = nil;
    
    if (_phoneField.text.length!=11) {
        errStr = @"手机号码格式不正确";
    }else if (_vcodeField.text.length != 4){
        errStr = @"验证码长度不正确";
    }else if ([@"" isEqualToString:[self textField:_vipView].text]){
        errStr = @"未填写卡号";
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

- (void)dimissViewControllerAction{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark- UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField;{
    if (![textField.text isEqualToString:@""]) {
        [self closeButton:textField].hidden = NO;
    }
    
    if ([textField isEqual:[self textField:_vipView]]) {
        _tableView.hidden = NO;
        _showmoreaccoutButton.selected = YES;
    }
    
    
}

-(void)textfieldChange:(UITextField*)field
{
    if (_vcodeField.text.length==4) {
        [self loadDateCardList];
    }
}


//发送验证码
-(void)getValidateCode{
    
    
    [[HFSServiceClient sharedJSONClient]POST:@"common/sendsms" parameters:@{@"mphone":[self textField:_rphoneView].text,@"content":@"",@"vcode":@""} success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

-(void)activeVipcard
{
    NSDictionary *dic = @{@"appId":APP_ID,@"nonceStr":NONCE_STR,@"account":_phoneField.text,@"pwd":_passwordField.text,@"cardno":[self textField:_vipView].text, @"vcode":_vcodeField.text};
    
    NSData *data = [HFSUtility RSADicToData:dic] ;
    NSString *ret = base64_encode_data(data);
    
    [[HFSServiceClient sharedClient] POST:@"vip/ActivationUserInfo" parameters:ret success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([@"0" isEqualToString:[NSString stringWithFormat:@"%@",result[@"status"]]]) {
            [_vipArray addObjectsFromArray:result[@"cardlist"]];
            
        }else {
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

#pragma mark 获取会员卡号清单
- (void)loadDateCardList {
    
    NSDictionary *dic = @{@"appId":APP_ID,@"nonceStr":NONCE_STR,@"account":_phoneField.text,@"vcode":_vcodeField.text};
    
    NSData *data = [HFSUtility RSADicToData:dic] ;
    NSString *ret = base64_encode_data(data);
    
    [[HFSServiceClient sharedClient] POST:@"vip/getVipCardList" parameters:ret success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        [_vipArray addObject:@"0000000025"];
        [_tableView reloadData];
        _tableViewH.constant = _vipArray.count > 3 ? 3 * 30 : _vipArray.count * 30;

        if ([@"0" isEqualToString:[NSString stringWithFormat:@"%@",result[@"status"]]]) {
//            [_vipArray addObjectsFromArray:result[@"cardlist"]];
            [_vipArray addObject:@"0000000025"];
            [_tableView reloadData];
        }else {
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


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;{
    
    if (![textField.text isEqualToString:@""]) {
        [self closeButton:textField].hidden = NO;
    }
    
//    if ([textField isEqual:[self textField:_accountView]] || [textField isEqual:[self textField:_passwordView]]) {
//        if ([[self textField:_accountView].text isEqualToString:@""] || [[self textField:_passwordView].text isEqualToString:@""]) {
//            _loginButton.enabled = NO;
//            
//            [_loginButton setBackgroundImage:[UIImage imageNamed:@"TM.jpg"] forState:UIControlStateNormal];
//            _loginButton.backgroundColor = [UIColor clearColor];
//            _loginButton.layer.borderWidth = 1.0f;
//            _loginButton.layer.borderColor = [UIColor colorWithHexString:@"#AE8E5D"].CGColor;
//        }else{
//            _loginButton.enabled = YES;
//            
//            [_loginButton setBackgroundImage:[UIImage imageNamed:@"quguangguang_button"] forState:UIControlStateNormal];
//            _loginButton.backgroundColor = [UIColor clearColor];
//            _loginButton.layer.borderWidth = 1.0f;
//            _loginButton.layer.borderColor = [UIColor clearColor].CGColor;
//        }
//    }
    
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField; {
    [self closeButton:textField].hidden = YES;
    
    if ([textField isEqual:[self textField:_vipView]]) {
        _tableView.hidden = YES;
        _showmoreaccoutButton.selected = NO;
    }
}

#pragma mark- UITableViewDataSource And UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    return _vipArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    
    static NSString *CellIdentifier = @"MLLoginTableViewCell" ;
    MLLoginTableViewCell *cell = (MLLoginTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    cell.logininfoLabel.text = _vipArray[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self textField:_vipView].text = _vipArray[indexPath.row];
    [[self textField:_vipView] resignFirstResponder];
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
