//
//  MNNNextStepViewController.m
//  Matro
//
//  Created by benssen on 16/3/28.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MNNNextStepViewController.h"
#import "MNNManagementViewController.h"
#import "UIColor+HeinQi.h"
#import "HFSConstants.h"
#import "HFSUtility.h"
#import "HFSServiceClient.h"

#define kScreenWidth self.view.frame.size.width


@interface MNNNextStepViewController () {
    UITextField *_newPassword;
    UITextField *_confirmPassword;
    UIButton *_determine;
}

@end

@implementation MNNNextStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:gesture];
    [self createView];
    // Do any additional setup after loading the view.
}
//Lock_xiugaimima锁     Profile_xiugaimima人    golden_button

//收回键盘
- (void)tap {
    [_newPassword resignFirstResponder];
    [_confirmPassword resignFirstResponder];
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
    lable2.textColor = [UIColor colorWithHexString:@"#AE8E5D"];
    lable2.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:lable2];

    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(40, 30, 20, 20)];
    label3.layer.cornerRadius = 10;
    label3.layer.masksToBounds = YES;
    label3.backgroundColor = [UIColor colorWithHexString:@"#AE8E5D"];
    label3.font = [UIFont systemFontOfSize:20];
    label3.text = @"1";
    label3.textColor = [UIColor whiteColor];
    label3.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label3];
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-120)/2+80, 30, 20, 20)];
    label4.layer.cornerRadius = 10;
    label4.layer.masksToBounds = YES;
    label4.backgroundColor = [UIColor colorWithHexString:@"#AE8E5D"];
    label4.font = [UIFont systemFontOfSize:20];
    label4.text = @"2";
    label4.textColor = [UIColor whiteColor];
    label4.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label4];
    [self createlableWithRect:CGRectMake(10, 79, kScreenWidth-20, 1)];
    _newPassword = [[UITextField alloc] initWithFrame:CGRectMake(40, 90, kScreenWidth-50, 30)];
    _newPassword.placeholder = @"新密码";
    _newPassword.borderStyle = UITextBorderStyleNone;
    _newPassword.secureTextEntry = YES;
    [_newPassword setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 90, 15, 20)];
    imageView1.image = [UIImage imageNamed:@"Lock_xiugaimima"];
    [self.view addSubview:imageView1];
    _newPassword.clearsOnBeginEditing = YES;
    _newPassword.keyboardType = UIKeyboardAppearanceDefault;
    [self.view addSubview:_newPassword];
    [self createlableWithRect:CGRectMake(10, CGRectGetMaxY(_newPassword.frame), kScreenWidth-20, 1)];
  
    _confirmPassword = [[UITextField alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(_newPassword.frame)+10, kScreenWidth-160, 30)];
    _confirmPassword.placeholder = @"确认新密码";
    _confirmPassword.borderStyle = UITextBorderStyleNone;
    _confirmPassword.secureTextEntry = YES;
    [_confirmPassword setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_newPassword.frame)+10, 15, 20)];
    imageView2.image = [UIImage imageNamed:@"Lock_xiugaimima"];
    [self.view addSubview:imageView2];
    _confirmPassword.clearsOnBeginEditing = YES;
    _confirmPassword.keyboardType = UIKeyboardAppearanceDefault;
    [self.view addSubview:_confirmPassword];
    [self createlableWithRect:CGRectMake(10, CGRectGetMaxY(_confirmPassword.frame), kScreenWidth-20, 1)];
    _determine = [[UIButton alloc] initWithFrame:CGRectMake(50, self.view.frame.size.height-230, kScreenWidth-100, 30)];
    [_determine setBackgroundImage:[UIImage imageNamed:@"golden_button"] forState:UIControlStateNormal];
    [_determine setTitle:@"确定" forState:UIControlStateNormal];
    [_determine addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_determine];
}
- (void)createlableWithRect:(CGRect)rect {
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.backgroundColor = [UIColor grayColor];
    label.alpha = 0.7;
    [self.view addSubview:label];
}

#pragma mark 修改密码
- (void)buttonAction {
    [_newPassword resignFirstResponder];
    [_confirmPassword resignFirstResponder];
    if ([_newPassword.text isEqualToString:@""]||[_confirmPassword.text isEqualToString:@""]) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请将信息填写完整";
        [_hud hide:YES afterDelay:2];
    }
    else {
        if ([_newPassword.text isEqualToString:_confirmPassword.text]) {
            //没有登录账号无法获得验证码
            NSDictionary *dic = @{@"appId":APP_ID,@"nonceStr":NONCE_STR,@"pwd":_newPassword.text,@"mphone":@"18913525275",@"cardno":@"",@"vcode":self.vcode};
            
            NSData *data = [HFSUtility RSADicToData:dic] ;
            NSString *ret = base64_encode_data(data);
            
            [[HFSServiceClient sharedClient] POST:@"vip/ResetPassword" parameters:ret success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSDictionary *result = (NSDictionary *)responseObject;
                NSLog(@"返回编码:%@",result[@"status"]);
                NSLog(@"%@",result[@"msg"]);
                if([@"0" isEqualToString:[NSString stringWithFormat:@"%@",result[@"status"]]]){
                    
                    [_hud show:YES];
                    _hud.mode = MBProgressHUDModeText;
                    _hud.labelText = @"密码修改成功";
                    [_hud hide:YES afterDelay:2];
                    [self performSelector:@selector(popView) withObject:nil afterDelay:2];
                }
                else{
                    [_hud show:YES];
                    _hud.mode = MBProgressHUDModeText;
                    _hud.labelText = result[@"msg"];
                    [_hud hide:YES afterDelay:2];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"请求失败");
                [_hud show:YES];
                _hud.mode = MBProgressHUDModeText;
                _hud.labelText = @"请求失败";
                [_hud hide:YES afterDelay:2];
            }];
        }else {
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"两次输入密码不同";
            [_hud hide:YES afterDelay:2];
        }
    }
}
- (void)popView {
    NSArray *viewControllers = self.navigationController.viewControllers;
    UIViewController *management = [viewControllers objectAtIndex:1];
    [self.navigationController popToViewController:management animated:YES];
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
