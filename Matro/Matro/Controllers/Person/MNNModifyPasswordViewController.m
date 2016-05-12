//
//  MNNModifyPasswordViewController.m
//  Matro
//
//  Created by benssen on 16/3/28.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MNNModifyPasswordViewController.h"
#import "MNNNextStepViewController.h"
#import "HFSUtility.h"
#import "UIColor+HeinQi.h"
#import "HFSConstants.h"
#import "HFSServiceClient.h"

#define CODE_TIME_KEY @"CODE_TIME_KEY"
#define  kScreenWidth self.view.frame.size.width

@interface MNNModifyPasswordViewController () {
    UITextField *_phoneTextField;//手机号输入框
    UITextField *_verificationNumberTextField;//验证码输入框
    UIButton *_getVerificationCode;//获取验证码
    UIButton *_nextStep;//下一步
//    NSTimer *_timer;//定时器 控制再次获取验证码
    int residualTime;//设定每次获取验证码的时间间隔
    UIView *_promplabelview;//提示框
    NSInteger _endTime;
}

@end

@implementation MNNModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    residualTime = 6;
   
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:gesture];
    [self createView];
    // Do any additional setup after loading the view.
}
//Lock_xiugaimima锁     Profile_xiugaimima人    golden_button

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    //短信倒计时
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *tempTime = [userDefaults stringForKey:CODE_TIME_KEY];
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate new] timeIntervalSince1970]];
    if (timeSp) {
        _endTime = 60 - ([timeSp integerValue] - [tempTime integerValue]);
    }
    if (!tempTime ||  _endTime> 60) {
        
        _getVerificationCode.enabled = YES;
        
        _endTime = 0;
    }else{
        _getVerificationCode.enabled = NO;
    }
    
    [self codeTimeCountdown];
}

- (void)tap {
    [_phoneTextField resignFirstResponder];
    [_verificationNumberTextField resignFirstResponder];
}

#pragma mark 创建视图
- (void)createView {
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(40, 30, (kScreenWidth-120)/2, 20)];
    lable1.text = @"验证身份";
    lable1.textAlignment = NSTextAlignmentCenter;
    lable1.textColor = [UIColor colorWithHexString:@"#AE8E5D"];
    lable1.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:lable1];
    UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-120)/2+80, 30, (kScreenWidth-120)/2, 20)];
    lable2.text = @"修改密码";
    lable2.textAlignment = NSTextAlignmentCenter;
    lable2.textColor = [UIColor lightGrayColor];
    lable2.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:lable2];
    //圆圈数字
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(40, 30, 20, 20)];
    label3.layer.cornerRadius = 10;
    label3.layer.masksToBounds = YES;
    label3.backgroundColor = [UIColor colorWithHexString:@"#AE8E5D"];
    label3.font = [UIFont systemFontOfSize:20];
    label3.text = @"1";
    label3.textColor = [UIColor whiteColor];
    label3.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label3];
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-120)/2+90, 32, 15, 15)];
    label4.layer.cornerRadius = 7.5;
    label4.layer.masksToBounds = YES;
    label4.backgroundColor = [UIColor lightGrayColor];
    label4.font = [UIFont systemFontOfSize:15];
    label4.text = @"2";
    label4.textColor = [UIColor whiteColor];
    label4.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label4];
    
    
    [self createlableWithRect:CGRectMake(10, 79, kScreenWidth-20, 1)];
    _phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(40, 90, kScreenWidth-50, 30)];
    _phoneTextField.placeholder = @"手机号";
    _phoneTextField.borderStyle = UITextBorderStyleNone;
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 90, 20, 20)];
    imageView1.image = [UIImage imageNamed:@"Profile_xiugaimima"];
    [self.view addSubview:imageView1];
    _phoneTextField.clearsOnBeginEditing = YES;
    _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_phoneTextField setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    [self.view addSubview:_phoneTextField];
    [self createlableWithRect:CGRectMake(10, CGRectGetMaxY(_phoneTextField.frame), kScreenWidth-20, 1)];
    _verificationNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(_phoneTextField.frame)+15, kScreenWidth-160, 30)];
    _verificationNumberTextField.placeholder = @"验证码";
    _verificationNumberTextField.borderStyle = UITextBorderStyleNone;
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_phoneTextField.frame)+15, 20, 20)];
    imageView2.image = [UIImage imageNamed:@"Lock_xiugaimima"];
    [self.view addSubview:imageView2];
    _verificationNumberTextField.clearsOnBeginEditing = YES;
    _verificationNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_verificationNumberTextField setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    [self.view addSubview:_verificationNumberTextField];
    _getVerificationCode = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-110, CGRectGetMaxY(_phoneTextField.frame)+10, 100, 30)];
    _getVerificationCode.tag = 10000;
    [_getVerificationCode setBackgroundImage:[UIImage imageNamed:@"golden_button"] forState:UIControlStateNormal];
    [_getVerificationCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    _getVerificationCode.titleLabel.font = [UIFont systemFontOfSize:13];
    [_getVerificationCode addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_getVerificationCode];
    [self createlableWithRect:CGRectMake(10, CGRectGetMaxY(_verificationNumberTextField.frame)+5, kScreenWidth-20, 1)];
    _nextStep = [[UIButton alloc] initWithFrame:CGRectMake(50, self.view.frame.size.height-230, kScreenWidth-100, 30)];
    _nextStep.tag = 10001;
    [_nextStep setBackgroundImage:[UIImage imageNamed:@"golden_button"] forState:UIControlStateNormal];
    [_nextStep setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextStep addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextStep];
}
- (void)createlableWithRect:(CGRect)rect {
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.backgroundColor = [UIColor grayColor];
    label.alpha = 0.4;
    [self.view addSubview:label];
}
#pragma mark  验证码倒计时
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
                _getVerificationCode.enabled=YES;
                [_getVerificationCode setTitle:@"获取验证码" forState:UIControlStateNormal];
                [_getVerificationCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [_getVerificationCode setBackgroundImage:[UIImage imageNamed:@"quguangguang_button"] forState:UIControlStateNormal];
                _getVerificationCode.backgroundColor = [UIColor clearColor];
                _getVerificationCode.layer.borderWidth = 1.0f;
                _getVerificationCode.layer.borderColor = [UIColor clearColor].CGColor;
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
                _getVerificationCode.enabled=NO;
                [_getVerificationCode setTitle:strTime forState:UIControlStateNormal];
                [_getVerificationCode setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [_getVerificationCode setBackgroundImage:[UIImage imageNamed:@"TM.jpg"] forState:UIControlStateNormal];
                _getVerificationCode.backgroundColor = [UIColor clearColor];
                _getVerificationCode.layer.borderWidth = 1.0f;
                _getVerificationCode.layer.borderColor = [UIColor colorWithHexString:@"#AE8E5D"].CGColor;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
- (void)buttonAction:(UIButton *)button {
    //收回键盘
    [_phoneTextField resignFirstResponder];
    [_verificationNumberTextField resignFirstResponder];
#pragma mark 获取验证码
    if (button.tag == 10000) {
         NSDictionary *dic = @{@"mphone":_phoneTextField.text,@"content":@"",@"vcode":@""};
        [[HFSServiceClient sharedJSONClient]POST:@"common/sendsms" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    

    //下一步
    if (button.tag == 10001) {
#pragma mark 校验验证码
        self.hidesBottomBarWhenPushed = YES;
        MNNNextStepViewController *nextStepVC = [MNNNextStepViewController new];
        nextStepVC.vcode = _verificationNumberTextField.text;
        [self.navigationController pushViewController:nextStepVC animated:YES];
//        //校验验证码接口不对
//        if ([_verificationNumberTextField.text isEqualToString:@""]) {
//            [_hud show:YES];
//            _hud.mode = MBProgressHUDModeText;
//            _hud.labelText = @"请输入验证码";
//            [_hud hide:YES afterDelay:2];
//        }else {
//            [[HFSServiceClient sharedJSONClient] POST:@"common/checksms" parameters:@{@"account":_phoneTextField.text,@"vcode":_verificationNumberTextField.text} success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                NSDictionary *result = (NSDictionary *)responseObject;
//                if ([@"0" isEqualToString:[NSString stringWithFormat:@"%@",result[@"status"]]]) {
//                    
//                    [_hud show:YES];
//                    _hud.mode = MBProgressHUDModeText;
//                    _hud.labelText = @"验证成功";
//                    [_hud hide:YES afterDelay:2];
//                    [self performSelector:@selector(popView) withObject:nil afterDelay:2];
//                }else {
//                    
//                    [_hud show:YES];
//                    _hud.mode = MBProgressHUDModeText;
//                    _hud.labelText = result[@"msg"];
//                    [_hud hide:YES afterDelay:2];
//                }
//                NSLog(@"%@",result[@"msg"]);
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                [_hud show:YES];
//                _hud.mode = MBProgressHUDModeText;
//                _hud.labelText = @"请求失败";
//                [_hud hide:YES afterDelay:2];
//                NSLog(@"请求失败");
//            }];
//        }
    }
}
- (void)popView {
    self.hidesBottomBarWhenPushed = YES;
    MNNNextStepViewController *nextStepVC = [MNNNextStepViewController new];
    nextStepVC.vcode = _verificationNumberTextField.text;
    [self.navigationController pushViewController:nextStepVC animated:YES];
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
