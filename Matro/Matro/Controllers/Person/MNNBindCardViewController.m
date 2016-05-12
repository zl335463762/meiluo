//
//  MNNBindCardViewController.m
//  Matro
//
//  Created by benssen on 16/3/30.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MNNBindCardViewController.h"
#import "HFSUtility.h"
#import "UIColor+HeinQi.h"
#import "HFSConstants.h"
#import "HFSServiceClient.h"

#define CODE_TIME_KEY @"CODE_TIME_KEY"
#define kScreenWidth self.view.frame.size.width

@interface MNNBindCardViewController () {
    UITextField *_phoneTextField;
    UITextField *_numberTextField;
    UITextField *_cardNumberTextField;
    NSInteger _endTime;
    UIButton *_button;
    UIButton *_showList;
    CGRect _oldRect;
    NSMutableArray *_cardList;
    NSInteger _isShow;
    UIScrollView *_listView;
    UIImageView *_view3;
}

@end

@implementation MNNBindCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定会员卡";
    _isShow = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
    _cardList = [NSMutableArray array];
    [_cardList addObjectsFromArray:@[@"154500",@"436430",@"434332",@"784500",@"423145"]];
    
    [self createViews];

    // Do any additional setup after loading the view.
}
#pragma mark 获取会员卡号清单
- (void)loadDateCardList {
    
    NSDictionary *dic = @{@"appId":APP_ID,@"nonceStr":NONCE_STR,@"account":_phoneTextField.text};
    
    NSData *data = [HFSUtility RSADicToData:dic] ;
    NSString *ret = base64_encode_data(data);
    
    [[HFSServiceClient sharedClient] POST:@"vip/getVipCardList" parameters:ret success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([@"0" isEqualToString:[NSString stringWithFormat:@"%@",result[@"status"]]]) {
            [_cardList addObjectsFromArray:result[@"cardlist"]];
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
- (void)tap:(UITapGestureRecognizer *)gesture {
    [_phoneTextField resignFirstResponder];
    [_numberTextField resignFirstResponder];
    [_cardNumberTextField resignFirstResponder];
}
#pragma mark 创建视图
- (void)createViews {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 30)];
    label.text = @"绑定美罗VIP卡，即可享受更多线上线下优惠";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:label];
    //输入手机号
    UIImageView *view1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(label.frame)+10, kScreenWidth-20, 40)];
    UIImage *image1 = [UIImage imageNamed:@"shuzixianshi"];
    image1 = [image1 resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20) resizingMode:UIImageResizingModeStretch];
    view1.image = image1;
    view1.userInteractionEnabled = YES;
    [self.view addSubview:view1];
    UIImageView *phoneView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    phoneView.image = [UIImage imageNamed:@"Profile_xiugaimima"];
    [view1 addSubview:phoneView];
    _phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(35, 10, kScreenWidth-60, 30)];
    _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    _phoneTextField.placeholder = @"办卡时的手机号";
    [_phoneTextField setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    _phoneTextField.borderStyle = UITextBorderStyleNone;
    [view1 addSubview:_phoneTextField];
    //输入验证码
    UIImageView *view2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(view1.frame)+10, kScreenWidth-100, 40)];
    UIImage *image2 = [UIImage imageNamed:@"shuzixianshi"];
    image2 = [image2 resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 20) resizingMode:UIImageResizingModeStretch];
    view2.image = image2;
    view2.userInteractionEnabled = YES;
    [self.view addSubview:view2];
    UIImageView *numberView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 13, 20)];
    numberView.image = [UIImage imageNamed:@"Lock_xiugaimima"];
    [view2 addSubview:numberView];
    _numberTextField = [[UITextField alloc] initWithFrame:CGRectMake(35, 10, kScreenWidth-100, 30)];
    _numberTextField.placeholder = @"验证码";
    [_numberTextField setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    _numberTextField.keyboardType = UIKeyboardTypeNumberPad;
    _numberTextField.borderStyle = UITextBorderStyleNone;
    [view2 addSubview:_numberTextField];
    //获取验证码
    _button = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-90, CGRectGetMaxY(view1.frame)+10, 80, 40)];
    _button.tag = 151;
    [_button setBackgroundImage:[UIImage imageNamed:@"golden_button"] forState:UIControlStateNormal];
    [_button setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    _button.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:_button];
    //绑定卡号
    _view3 = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(view2.frame)+10, kScreenWidth-20, 40)];
    UIImage *image3 = [UIImage imageNamed:@"shuzixianshi"];
    image3 = [image3 resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 20) resizingMode:UIImageResizingModeStretch];
    _view3.image = image3;
    _view3.userInteractionEnabled = YES;
    [self.view addSubview:_view3];
    UIImageView *cardView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 20, 15)];
    cardView.image = [UIImage imageNamed:@"Outlined_gray"];
    [_view3 addSubview:cardView];
    _cardNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(35, 10, kScreenWidth-40, 30)];
    _cardNumberTextField.placeholder = @"卡号";
    _cardNumberTextField.borderStyle = UITextBorderStyleNone;
    [_cardNumberTextField setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    [_view3 addSubview:_cardNumberTextField];
    _showList = [[UIButton alloc] initWithFrame:CGRectMake(_view3.frame.size.width-25, 12, 20, 15)];
    [_showList setBackgroundImage:[UIImage imageNamed:@"jiage_arrow_shang"] forState:UIControlStateNormal];
    [_showList addTarget:self action:@selector(showList:) forControlEvents:UIControlEventTouchUpInside];
    [_view3 addSubview:_showList];
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height-230, kScreenWidth-20, 30)];
    button1.tag = 150;
    [button1 setBackgroundImage:[UIImage imageNamed:@"golden_button"] forState:UIControlStateNormal];
    [button1 setTitle:@"绑定" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)showList:(UIButton *)button {
    if (_isShow) {
        _isShow+=1;
        [button setBackgroundImage:[UIImage imageNamed:@"jiage_arrow_shang"] forState:UIControlStateNormal];
        [_listView removeFromSuperview];
        
    }else {
        _isShow-=1;
        [self loadDateCardList];
        [button setBackgroundImage:[UIImage imageNamed:@"jiage_arrow"] forState:UIControlStateNormal];
        if (_cardList.count) {
            _listView = [[UIScrollView alloc] initWithFrame:CGRectMake(kScreenWidth-100, CGRectGetMaxY(_view3.frame)+5, 90, 60)];
            _listView.showsHorizontalScrollIndicator = NO;
            
            _listView.backgroundColor = [UIColor whiteColor];
            for (int i = 0; i < _cardList.count; i++) {
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(5, 5+i*25, 80, 20)];
                [button setTitle:[NSString stringWithFormat:@"%@",_cardList[i]] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(selList:) forControlEvents:UIControlEventTouchUpInside];
                [_listView addSubview:button];
            }
            _listView.contentSize = CGSizeMake(90, 30*_cardList.count);
            [self.view addSubview:_listView];
        }
    }
}
- (void)selList:(UIButton *)button {
    _cardNumberTextField.text = button.titleLabel.text;
    
}
#pragma mark 监听键盘是否超过输入框
- (void)keyboardWillShow:(NSNotification *)notification {
    //获取键盘的高度
    
    NSDictionary *dic = notification.userInfo;
    NSValue *value = [dic objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [value CGRectValue];
    CGFloat keyboardHeight = keyboardFrame.size.height;
    
    _oldRect = _cardNumberTextField.frame;
    if (keyboardHeight > (self.view.frame.size.height - (_oldRect.size.height+_oldRect.origin.y))) {
        CGRect newRect = CGRectMake(_oldRect.origin.x, _oldRect.origin.y-keyboardHeight, _oldRect.size.width, _oldRect.size.height);
        _cardNumberTextField.frame = newRect;
    }
    
}
- (void)keyboardWillHide:(NSNotification *)notification {
    _cardNumberTextField.frame = _oldRect;
}
- (void)buttonAction:(UIButton *)button {
    //收回键盘
    [_phoneTextField resignFirstResponder];
    [_numberTextField resignFirstResponder];
    [_cardNumberTextField resignFirstResponder];
    if (button.tag == 151) {
        //判断输入的手机号是否为真实手机号
        if ([HFSUtility validateMobile:_phoneTextField.text]) {
            
            //发送验证码
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeIndeterminate;
            _hud.labelText = @"";
            
            [self getValidateCode];
            
        }else{
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"请输入正确的手机号码";
            [_hud hide:YES afterDelay:2];
        }

    }
    if (button.tag == 150) {
#pragma mark 校验验证码
        [[HFSServiceClient sharedJSONClient] POST:@"common/checksms" parameters:@{@"account":_phoneTextField.text,@"vcode":_numberTextField.text} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *result = (NSDictionary *)responseObject;
            NSLog(@"%@",result);
            if ([@"0" isEqualToString:[NSString stringWithFormat:@"%@",result[@"strtus"]]]) {
                [_hud show:YES];
                _hud.mode = MBProgressHUDModeText;
                _hud.labelText = @"绑定成功";
                [_hud hide:YES afterDelay:2];
                //等待二秒返回上个界面
                [self performSelector:@selector(popView) withObject:nil afterDelay:2];
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
}
#pragma mark 按钮倒计时
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
                _button.enabled=YES;
                
                [_button setBackgroundImage:[UIImage imageNamed:@"quguangguang_button"] forState:UIControlStateNormal];
                [_button setTitle:@"获取验证码" forState:UIControlStateNormal];
                [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                _button.backgroundColor = [UIColor clearColor];
                _button.layer.borderWidth = 1.0f;
                _button.layer.borderColor = [UIColor clearColor].CGColor;
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
                _button.enabled=NO;
                [_button setTitle:strTime forState:UIControlStateNormal];
                [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [_button setBackgroundImage:[UIImage imageNamed:@"TM.jpg"] forState:UIControlStateNormal];
                _button.backgroundColor = [UIColor clearColor];
                _button.layer.borderWidth = 1.0f;
                _button.layer.borderColor = [UIColor colorWithHexString:@"#AE8E5D"].CGColor;
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}
#pragma mark 发送验证码
-(void)getValidateCode{
    
    [[HFSServiceClient sharedJSONClient]POST:@"common/sendsms" parameters:@{@"mphone":_phoneTextField.text,@"content":@"",@"vcode":@""} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        NSLog(@"%@",result);
        if([@"0" isEqualToString:[NSString stringWithFormat:@"%@",result[@"status"]]]){
            NSLog(@"%@",result[@"msg"]);
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
