//
//  MLBindPhoneController.m
//  Matro
//
//  Created by 黄裕华 on 16/5/5.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBindPhoneController.h"
#import "YMLeftImageField.h"
#import "Masonry.h"

@interface MLBindPhoneController ()
@property (weak, nonatomic) IBOutlet YMLeftImageField *phoneField;
@property (weak, nonatomic) IBOutlet YMLeftImageField *codeField;
@property (weak, nonatomic) IBOutlet UIButton *subCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *bindBtn;
@property (nonatomic,strong)YMLeftImageField *passField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bindConstraint;

@end

@implementation MLBindPhoneController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定手机号";
    self.view.backgroundColor = [UIColor whiteColor];
    self.phoneField.layer.borderWidth = 1.f;
    self.phoneField.layer.borderColor = RGBA(245, 245, 245, 1).CGColor;
    self.phoneField.layer.masksToBounds = YES;
    self.phoneField.leftImgName = @"Profile_gray";
    self.phoneField.leftOffset = 5.f;
    self.phoneField.rightOffset = 5.f;
    self.codeField.layer.borderWidth = 1.f;
    self.codeField.layer.borderColor = RGBA(245, 245, 245, 1).CGColor;
    self.codeField.layer.masksToBounds = YES;
    self.codeField.leftOffset = 5.f;
    self.codeField.rightOffset = 5.f;
    self.codeField.leftImgName = @"Lock_gray";
    self.subCodeBtn.layer.borderWidth = 1.f;
    self.subCodeBtn.layer.borderColor = RGBA(245, 245, 245, 1).CGColor;
    self.subCodeBtn.layer.masksToBounds = YES;
    
    _passField = ({
       YMLeftImageField *filed = [[YMLeftImageField alloc]initWithFrame:self.bindBtn.frame];
        filed.secureTextEntry = YES;
        filed.placeholder = @"请输入密码";
        filed.leftOffset = 5.f;
        filed.rightOffset = 5.f;
        filed.leftImgName = @"Lock_gray";
        filed.font = [UIFont systemFontOfSize:14];
        filed.layer.borderWidth = 1.f;
        filed.layer.borderColor = RGBA(245, 245, 245, 1).CGColor;
        filed.layer.masksToBounds = YES;
        filed;
    });
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)subCodeClick:(id)sender {
    
//    [[HFSServiceClient sharedJSONClientwithurl:SERVICE_BASE_URL]POST:@"common/sendsms" parameters:@{@"mphone":self.phoneField.text,@"content":@"",@"vcode":@""} success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *result = (NSDictionary *)responseObject;
//        
//        if([@"0" isEqualToString:[NSString stringWithFormat:@"%@",result[@"status"]]]){
//            [_hud show:YES];
//            _hud.mode = MBProgressHUDModeText;
//            _hud.labelText = @"验证码已发送，请注意查收";
//            [_hud hide:YES afterDelay:2];
//            _endTime = 60;
//            
//        }else{
//            [_hud show:YES];
//            _hud.mode = MBProgressHUDModeText;
//            _hud.labelText = result[@"msg"];
//            [_hud hide:YES afterDelay:2];
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [_hud show:YES];
//        _hud.mode = MBProgressHUDModeText;
//        _hud.labelText = @"请求失败";
//        [_hud hide:YES afterDelay:2];
//    }];


}

- (IBAction)bindClick:(id)sender {
//    UIButton *btn = (UIButton *)sender;


}

@end
