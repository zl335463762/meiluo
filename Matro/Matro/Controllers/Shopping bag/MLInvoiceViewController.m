//
//  MLInvoiceViewController.m
//  Matro
//
//  Created by NN on 16/3/29.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLInvoiceViewController.h"

#import "UIButton+HeinQi.h"
#import "HFSConstants.h"

@interface MLInvoiceViewController ()
@property (strong, nonatomic) IBOutlet UIButton *kai;
@property (strong, nonatomic) IBOutlet UIButton *bukai;
@property (strong, nonatomic) IBOutlet UIButton *putong;
@property (strong, nonatomic) IBOutlet UIButton *mingxi;
@property (strong, nonatomic) IBOutlet UITextField *titouTextField;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation MLInvoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self invoiceUI];
    self.title = @"发票信息";
    
    //隐藏键盘
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
//    tapGestureRecognizer.delegate = self;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _bukai.selected = !_isNeed;
    _kai.selected = _isNeed;
    _putong.selected = _isNeed;
    _mingxi.selected = _isNeed;
    _titouTextField.enabled = _isNeed;
    _titouTextField.text = _isNeed ? @"" : @"";//传入数据
}

- (void)invoiceUI{
    [_kai invoiceselButtonType];
    [_bukai invoiceselButtonType];
    [_putong invoiceselButtonType];
    [_mingxi invoiceselButtonType];
    [_saveButton loginButtonType];

}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
}

- (IBAction)invoiceButtonAction:(id)sender {
    UIButton *button = ((UIButton *)sender);
    if (button.selected) {
        return;
    }
    
    button.selected = YES;
    
    if ([button isEqual:_kai]) {
        _bukai.selected = NO;
        _putong.selected = YES;
        _mingxi.selected = YES;
        _titouTextField.enabled = YES;
    }else{
        _kai.selected = NO;
        _putong.selected = NO;
        _mingxi.selected = NO;
        _titouTextField.enabled = NO;
        _titouTextField.text = @"";
    }
    
}
- (IBAction)saveButtonAction:(id)sender {
    
    NSString *titou = _titouTextField.text;
    if ([@"" isEqualToString:titou]) {
        titou = @"个人";
    }
    
    [_delegate InvoiceDic:@{
                            @"invoice":_bukai.selected ? @"NO" : @"YES",
                            @"titleText":titou
                            }];
    [self.navigationController popViewControllerAnimated:YES];
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
