//
//  MLAddressInfoViewController.m
//  Matro
//
//  Created by NN on 16/3/29.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLAddressInfoViewController.h"

#import "HFSConstants.h"
#import "UIColor+HeinQi.h"
#import "SBJSON.h"

#import "HFSServiceClient.h"
#import "HFSUtility.h"

@interface MLAddressInfoViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>{
    UIControl *_blackView;
    
    //省市区的数组，解析的是本地的json
    NSMutableArray * addressArray01;
    NSMutableArray * addressArray02;
    NSMutableArray * addressArray03;
    NSArray * jsonObj;
    NSString *userid;
    NSString *selcode;
}
@property (strong, nonatomic) IBOutlet UIView *sBgView;
@property (strong, nonatomic) IBOutlet UIButton *sOn;
@property (strong, nonatomic) IBOutlet UIButton *sOff;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bH;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *rW;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *rH;
@property (strong, nonatomic) IBOutlet UIView *pickerRootView;
@property (strong, nonatomic) IBOutlet UIPickerView *addressPickerView;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UITextField *selTextField;
@property (strong, nonatomic) IBOutlet UILabel *tisLabel;
@property (strong, nonatomic) IBOutlet UITextField *inputTextField;

@end

@implementation MLAddressInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userid = [userDefaults valueForKey:kUSERDEFAULT_USERID];
    addressArray01 = [NSMutableArray array];
    addressArray02 = [NSMutableArray array];
    addressArray03 = [NSMutableArray array];
    [self notDefault];
    if (_isNewAddress) {
        self.title = @"新增收货地址";
    }else{
        self.title = @"编辑收货地址";
        self.nameTextField.text = _paramdic[@"SHRMC"];
        self.phoneTextField.text = _paramdic[@"SHRMPHONE"];
        self.inputTextField.text = _paramdic[@"SHRADDRESS"];
        self.selTextField.text = _paramdic[@"SFNAME"];
        
        if ([@"1" isEqualToString:_paramdic[@"MRSHRBJ"]]) {
            [self isonDefault];
        }
        
    }
    
    //隐藏键盘
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
//    tapGestureRecognizer.delegate = self;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    _blackView = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT -  224)];
    [_blackView addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _blackView.backgroundColor = [UIColor blackColor];
    _blackView.alpha = 0.4;
    _blackView.hidden = YES;
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:_blackView];
    
    NSString *string = [[NSString alloc]initWithContentsOfFile:[self getDocumentpath] encoding:NSUTF8StringEncoding error:nil];
    if (!string) {
        [self getAllarea];
    }
    else{
        SBJSON *sbjson = [SBJSON new];
        NSArray *ary = [sbjson objectWithString:string error:nil];
        [addressArray01 addObjectsFromArray:ary];
        addressArray02 = addressArray01[0][@"Sub"]; //默认显示第一个
        addressArray03 = addressArray02[0][@"Sub"];
    }
}
-(NSString*)getDocumentpath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"Area.json"]];
    return filePath;
}
-(void)getAllarea
{
    
    [[HFSServiceClient sharedClient] GET:@"http://www.matrojp.com/Ajax/Common/District.ashx?op=all" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            NSDictionary *tempdic = (NSDictionary*)responseObject;
            NSLog(@"temdic %@",tempdic);
            
            SBJSON *sbjson = [SBJSON new];
            NSError *error;
            NSString *jsonstr = [sbjson stringWithObject:tempdic error:&error];
            if (jsonstr) {
                [jsonstr writeToFile:[self getDocumentpath] atomically:YES encoding:NSUTF8StringEncoding error:&error];
            }
            
            NSArray *ary = (NSArray*)responseObject;
            if (ary && ary.count>0) {
                
                [addressArray01 addObjectsFromArray:ary];
                addressArray02 = addressArray01[0][@"Sub"]; //默认显示第一个
                addressArray03 = addressArray02[0][@"Sub"];
            }
            
            
            
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
        
    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    _rH.constant = MAIN_SCREEN_HEIGHT - 64;
    _rW.constant = MAIN_SCREEN_WIDTH;
}


- (IBAction)selAddressButtonAction:(id)sender {
    _blackView.hidden = _pickerRootView.hidden = NO;
}

- (IBAction)cancelButtonAction:(id)sender {
    _blackView.hidden = _pickerRootView.hidden = YES;
}

- (IBAction)addressSureButtonAction:(id)sender {
    _pickerRootView.hidden = YES;
    _blackView.hidden = YES;
    
    NSMutableString *addressStr = [[NSMutableString alloc]initWithString:addressArray01[[_addressPickerView selectedRowInComponent:0]][@"Name"]];
    
    if (addressArray02.count > 0) {
        [addressStr appendFormat:@"%@",addressArray02[[_addressPickerView selectedRowInComponent:1]][@"Name"]];
        selcode = addressArray02[[_addressPickerView selectedRowInComponent:1]][@"Code"];
    }
    
    if (addressArray03.count > 0) {
        [addressStr appendFormat:@"%@",addressArray03[[_addressPickerView selectedRowInComponent:2]][@"Name"]];
//        [code appendString:addressArray03[[_addressPickerView selectedRowInComponent:2]][@"Code"]];
        selcode = addressArray03[[_addressPickerView selectedRowInComponent:2]][@"Code"];
    }
    _selTextField.text = addressStr;
    
}

- (IBAction)sButtonAction:(id)sender {
    
//    UIButton * button = ((UIButton *)sender);
//    button.selected = !button.selected;
    
    if (_sOn.selected) {
        [self notDefault];
    }else{
        [self isonDefault];
    }
}

-(void)notDefault
{
    _sOn.selected = NO;
    _sOff.selected = YES;
    _sOn.backgroundColor = [UIColor clearColor];
    _sOff.backgroundColor = [UIColor whiteColor];
    _sBgView.backgroundColor = [UIColor colorWithHexString:@"AE8E5D"];
    _tisLabel.hidden = NO;
}

-(void)isonDefault
{
    _sOn.selected = YES;
    _sOff.selected = NO;
    _sOn.backgroundColor = [UIColor whiteColor];
    _sOff.backgroundColor = [UIColor clearColor];
    _sBgView.backgroundColor = [UIColor grayColor];
    _tisLabel.hidden = YES;
}

//保存使用新地址
- (IBAction)sureButtonAction:(id)sender {
    NSString *urlStr;
    if ([self.title isEqualToString:@"新增收货地址"]) {
        //新增地址
        urlStr = [NSString stringWithFormat:@"%@Ajax/member/glshdz.ashx?op=saveaddr&textSjrXm=%@&textSfzHm=%@&sf=%@&textXxdz=%@&textMPhoneNumber=%@&textPhoneNumber=%@&inx=%@&userid=%@",SERVICE_GETBASE_URL,self.nameTextField.text,@"",selcode,self.selTextField.text,self.phoneTextField.text,@"",@"",userid];
    }else {
        //编辑地址
        urlStr = [NSString stringWithFormat:@"%@Ajax/member/glshdz.ashx?op=saveaddr&textSjrXm=%@&textSfzHm=%@&sf=%@&textXxdz=%@&textMPhoneNumber=%@&textPhoneNumber=%@&inx=%@&userid=%@",SERVICE_GETBASE_URL,self.nameTextField.text,selcode,_paramdic[@"SHRSF"],self.selTextField.text,self.phoneTextField.text,_paramdic[@"SHRPHONE"],_paramdic[@"INX"],userid];
    }
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[HFSServiceClient sharedJSONClient] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
        
    }];
    
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
}

///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    _bH.constant = kbHeight;
}

///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    _bH.constant = 0;
}

#pragma mark- UIPickerViewDataSource and UIPickerViewDelegate
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;{
    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;{
    switch (component) {
        case 0:
            return addressArray01.count;
            break;
        case 1:
            return addressArray02.count;
            break;
        default:
            return addressArray03.count;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return addressArray01[row][@"Name"];
            break;
        case 1:
            return addressArray02[row][@"Name"];
            break;
        default:
            return addressArray03[row][@"Name"];
            break;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.minimumFontSize = 8.0f;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (component) {
        case 0://滑动第一个轮子，然后根据第二第三个轮子数据的实际情况改变第二第三个轮子
            addressArray02 = addressArray01[row][@"Sub"];
            [_addressPickerView reloadComponent:1];//更新第二个轮子
            if (addressArray02.count > 0) {//第二个轮子有数据的时候才执行更新
                [_addressPickerView selectRow:0 inComponent:1 animated:YES];//第二个轮子滑动到第一行
                addressArray03 = addressArray02[0][@"Sub"];
            }
            
            [_addressPickerView reloadComponent:2];//第三个轮子的数据前面判断过了，只能是有或者没有，可以直接刷新第三个轮子
            if (addressArray03.count > 0) {//判断第三个轮子有没有数据，有的话让滑动到第一个，第三个轮子已经是最后一个轮子了没有其他的事件了
                [_addressPickerView selectRow:0 inComponent:2 animated:YES];
            }
            
            break;
        case 1://滑动第二个轮子的事件，根据情况改变第三个轮子，同滑动第一个轮子的方法中改变第三个轮子
            addressArray03 = addressArray02[row][@"Sub"];
            [_addressPickerView reloadComponent:2];
            if (addressArray03.count > 0) {
                [_addressPickerView selectRow:0 inComponent:2 animated:YES];
            }
            break;
        default:
            
            break;
    }
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
