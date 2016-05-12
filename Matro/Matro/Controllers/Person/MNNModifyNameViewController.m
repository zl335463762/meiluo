//
//  MNNModifyNameViewController.m
//  Matro
//
//  Created by benssen on 16/3/28.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MNNModifyNameViewController.h"
#import "HFSConstants.h"
#import "HFSServiceClient.h"
#import "HFSUtility.h"


@interface MNNModifyNameViewController () {
    UITextField *_textField;
    UIButton *_preservationButton;
}

@end

@implementation MNNModifyNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改昵称";
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:gesture];
    [self createView];
    // Do any additional setup after loading the view.
}

- (void)tap {
    [_textField resignFirstResponder];
}

//创建修改试图golden_button
- (void)createView {
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 20, self.view.frame.size.width-20, 30)];
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.placeholder = @"请输入新的昵称";
    _textField.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:_textField];
    _preservationButton = [[UIButton alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(_textField.frame)+40, self.view.frame.size.width-100, 30)];
    [_preservationButton setBackgroundImage:[UIImage imageNamed:@"golden_button"] forState:UIControlStateNormal];
    [_preservationButton setTitle:@"保存" forState:UIControlStateNormal];
    [_preservationButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_preservationButton];
}
#pragma mark 保存修改后的昵称
- (void)buttonAction {
    
    [_textField resignFirstResponder];
    if ([_textField.text isEqualToString:@""]) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请输入您的昵称";
        [_hud hide:YES afterDelay:2];
    }
    else {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *avatorurl = [userDefaults objectForKey:kUSERDEFAULT_USERAVATOR];
        NSString *mphone = [userDefaults objectForKey:kUSERDEFAULT_USERPHONE];
        NSString *cardno = [userDefaults objectForKey:kUSERDEFAULT_USERCARDNO];
        NSDictionary *dic = @{@"appId":APP_ID,@"nickname":_textField.text,@"cardno":cardno,@"mphone":mphone,@"headPicUrl":avatorurl};
        
        NSData *data = [HFSUtility RSADicToData:dic];
        NSString *ret = base64_encode_data(data);
        
        [[HFSServiceClient sharedClient]POST:@"vip/updateUserInfo" parameters:ret success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *result = (NSDictionary *)responseObject;
            
            if([@"0" isEqualToString:[NSString stringWithFormat:@"%@",result[@"status"]]]){
                [_hud show:YES];
                _hud.mode = MBProgressHUDModeText;
                _hud.labelText = @"昵称修改成功";
                [_hud hide:YES afterDelay:2];
                if ([self.delegate respondsToSelector:@selector(MNNModifyNameViewController:userName:)]) {
                    [self.delegate MNNModifyNameViewController:self userName:_textField.text];
                }
                [self performSelector:@selector(popView) withObject:nil afterDelay:2];
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
}
- (void)popView {
    [self.navigationController popViewControllerAnimated:YES];
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
