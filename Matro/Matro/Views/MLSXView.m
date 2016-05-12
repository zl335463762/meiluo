//
//  MLSXView.m
//  Matro
//
//  Created by NN on 16/3/30.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLSXView.h"
#import "UIColor+HeinQi.h"
#import "RADataObject.h"
#import "HFSPriceDataObject.h"
#import <RATreeView/RATreeView.h>
#import "HFSConstants.h"
#import "HFSServiceClient.h"
#import "HFSUtility.h"


#define PriceCellIdentifier @"PriceCellIdentifier"

@interface MLSXView()<RATreeViewDataSource, RATreeViewDelegate,UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>{
    
    //品牌分类相关数组，用treeview显示
    NSMutableArray *_dataArray;
    RADataObject *_selectedItem;
    
    //价格的数组，用tableview显示
    NSMutableArray *_priceArray;
    NSIndexPath *_selectedIndexPath;
    UITableView * _tableView;
    UITextField *fromPriceTextField;
    UITextField *toPriceTextField;
    NSNumber *_minPrice;
    NSNumber *_maxPrice;
    NSIndexPath *_selectAllIndexPath;
    NSIndexPath *_customIndexPath;
    NSIndexPath *_selectMoreIndexPath;
    NSMutableDictionary *paramfilterDic;
}

@property (strong, nonatomic) IBOutlet UIButton *backButton;

@property (strong, nonatomic) IBOutlet UIView *titleButtonBgView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *cleanButton;

@property (strong, nonatomic) IBOutlet UIView *sxRootView;
@property (strong, nonatomic) IBOutlet UIView *shaixuanNextView;

@property (strong, nonatomic) IBOutlet UIButton *quanqiugouButton;
@property (strong, nonatomic) IBOutlet UIButton *cuxiaoButton;
@property (strong, nonatomic) IBOutlet UIButton *youhuoButton;

@property (strong, nonatomic) IBOutlet UILabel *fenlei;
@property (strong, nonatomic) IBOutlet UILabel *jiage;
@property (strong, nonatomic) IBOutlet UILabel *pinpai;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bh;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet RATreeView *treeView;
@end

@implementation MLSXView

- (id)init
{
    self = [super init];
    if (self) {
        
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:[NSString stringWithUTF8String:object_getClassName(self)] owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
        
        CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        //初始化背景视图，添加手势
        self.frame = frame ;
        self.userInteractionEnabled = YES;
        
        _treeView.delegate = self;
        _treeView.dataSource = self;
        _treeView.separatorStyle = RATreeViewCellSeparatorStyleNone;
        [_treeView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TypeCellIdentifier"];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:PriceCellIdentifier];
        
        _tableView.tableFooterView = [[UIView alloc]init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        _priceArray = [[NSMutableArray alloc ] initWithObjects:@"全部",@">10000", @"自定义", nil];
        _selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        //设置特殊选择项，全部、大于10000、自定义
        _selectAllIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        _customIndexPath = [NSIndexPath indexPathForRow:_priceArray.count-1 inSection:0];
        _selectMoreIndexPath = [NSIndexPath indexPathForRow:_priceArray.count-2 inSection:0];
        paramfilterDic = [[NSMutableDictionary alloc] init];
    }


    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    _bh.constant = kbHeight - 100;//底部按钮已经抵掉100
    
}

///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    _bh.constant = 0;
}
#pragma mark 获取筛选条件
//品牌
- (void)loadBrand:(NSString*)urlStr
{
    [[HFSServiceClient sharedClient] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *result = (NSArray *)responseObject;
        NSLog(@"%@",result);
        if (result) {
            for (NSDictionary *temp in result) {
                RADataObject *itemAll = [RADataObject dataObjectWithIdstr:temp[@"SBID"] name:temp[@"NAME"] children:nil];
                itemAll.level = @0;
                itemAll.dataId = [NSNumber numberWithInt:1];
                itemAll.selected = NO;
                [_dataArray addObject:itemAll];
            }
            [_treeView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"价格筛选 请求失败");
        
    }];
}
//价格
- (void)loadDatePrice {
    NSString *urlStr = @"http://www.matrojp.com/Ajax/search/search.ashx?op=jgcount&spflcode=&jgcount=5";
    [[HFSServiceClient sharedJSONClient] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *array = (NSArray *)responseObject;
        if (array && array.count>0) {
            int i=1;
            for (NSDictionary *temp in array) {
                NSString *startprice = temp[@"jgs"];
                NSString *endprice = temp[@"jge"];
                NSNumber *s = [NSNumber numberWithInt:startprice.intValue];
                NSNumber *e = [NSNumber numberWithInt:endprice.intValue];
                HFSPriceDataObject *tempPriceDataObject = [[HFSPriceDataObject alloc] initWithFrom:s to:e];
                [_priceArray insertObject:tempPriceDataObject.description atIndex:i];
                i++;
            }
            [self.tableView reloadData];

            
//            if (_postMaxPrice && _postMinPrice) {
//                for (NSInteger i = 1; i < _priceArray.count - 1; i ++ ) {
//                    HFSPriceDataObject *tempPriceDataObject = _priceArray[i];
//                    if ([tempPriceDataObject.fromPrice isEqualToNumber:_postMinPrice]&&[tempPriceDataObject.toPrice isEqualToNumber:_postMaxPrice]) {
//                        _selectedIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
//                        break;
//                    }else{
//                        _selectedIndexPath = _customIndexPath;
//                    }
//                }
//            }else{
//                if (!_selectedIndexPath) {
//                    _selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//                }
//            }

            
        }
        NSLog(@"请求成功");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
}
//分类
- (void)loadDateClass {
    NSString *urlStr = @"http://www.matrojp.com/Ajax/search/search.ashx?op=getspfl&spflcode=&ppcode=&key=";
    if (self.keywords) {
        NSString *key = [self.keywords stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
        urlStr = [NSString stringWithFormat:@"%@%@",urlStr,key];
    }
    [[HFSServiceClient sharedJSONClient] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray *result = (NSArray *)responseObject;
        if (result) {
            int i=0;
            for (NSDictionary *temp in result) {
                NSString *spfl = temp[@"SPFL"];
                NSLog(@"spfl %@",spfl);

                RADataObject *itemAll = [RADataObject dataObjectWithIdstr:temp[@"SPFL"] name:temp[@"NAME"] children:nil];
                itemAll.level = @0;
                itemAll.dataId = [NSNumber numberWithInt:0];
                itemAll.selected = NO;
                [_dataArray addObject:itemAll];
                i++;
            }
            [_treeView reloadData];
        }

        NSLog(@"请求成功");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
}
#pragma mark- 确定按钮
/*
 根据标题来决定确定按钮的事件
 */
- (IBAction)sureButtonAction:(id)sender {
    if ([_titleLabel.text isEqualToString:@"筛选"]) {

    }else if ([_titleLabel.text isEqualToString:@"商品分类"]){
        _fenlei.text = _selectedItem.name;
    }else if ([_titleLabel.text isEqualToString:@"品牌"]){
        _pinpai.text = _selectedItem.name;
        [paramfilterDic setObject:_selectedItem.name forKey:@"spsb"];
        
    }else if ([_titleLabel.text isEqualToString:@"价格"]){
//        _jiage.text = _selectedItem.name;
        [self confirmAction];
    }
    
    [self backButtonAction:nil];
}

#pragma mark- 返回
/*
 根据标题来决定返回按钮的事件
 */
- (IBAction)backButtonAction:(id)sender {
    
    [self endEditing:YES];
    
    if ([_titleLabel.text isEqualToString:@"筛选"]) {
        [_delegate blackAction:paramfilterDic];
    }else{
        _titleLabel.text = @"筛选";
        _sxRootView.hidden = NO;
        _cleanButton.hidden = NO;
        _shaixuanNextView.hidden = YES;
        [_backButton setImage:[UIImage imageNamed:@"xiayiye_arrow"] forState:UIControlStateNormal];
    }
    
}

#pragma mark- 清除
/*
清除刚刚选的选项_selectedItem
 还原标题、将当前的选择按钮设置成未选中等
 */
- (IBAction)cleanButtonAction:(id)sender {
   _titleLabel.text = @"筛选";
    _sxRootView.hidden = NO;
    _cleanButton.hidden = NO;
    _shaixuanNextView.hidden = YES;
    _youhuoButton.selected = _quanqiugouButton.selected = _cuxiaoButton.selected = NO;
    
    _fenlei.text = @"";
    _pinpai.text = @"";
    _jiage.text  = @"";
    
    for (id view in _titleButtonBgView.subviews) {
        if([view isKindOfClass:[UIButton class]]){
            if (((UIButton *)view).selected) {
                ((UIButton *)view).backgroundColor = [UIColor blackColor];
            }else{
                ((UIButton *)view).backgroundColor = [UIColor clearColor];
            }
        }
    }
    
    _selectedItem = nil;
    [paramfilterDic removeAllObjects];
//    _selectedIndexPath = nil;
}
#pragma mark- 顶部按钮
//    1. op：操作码
//    2. spflcode：商品分类代码
//    3. tpgg：图片规格
//    4. sort：排序
//    XSSL&false（销量）
//    XJ&true（价格正序）
//    XJ&false（价格倒序）
//            5. spsb：商品商标代码
//    6. pagesize：每页显示记录数，默认为：20
//            7. pageindex：页码
//    8. key：搜索关键字
//    9. jgs：开始价格
//    10. jge：结束价格
//    11. iskc：是否仅显示有货（true表示显示有货，false则表示忽略）
//    12. zcsp：是否跨境购（true表示跨境购，false则表示忽略）
//顶部的三个大分类按钮事件
- (IBAction)sxTitleButtonAction:(id)sender {
    UIButton * button = ((UIButton *)sender);
    
    button.selected = !button.selected;
    
    if ([button isEqual:_quanqiugouButton]) {
        _youhuoButton.selected = _cuxiaoButton.selected = NO;
    }else if ([button isEqual:_youhuoButton]){
        _quanqiugouButton.selected = _cuxiaoButton.selected = NO;
    }else{
        _quanqiugouButton.selected = _youhuoButton.selected = NO;
    }
    
    for (id view in _titleButtonBgView.subviews) {
        if([view isKindOfClass:[UIButton class]]){
            if (((UIButton *)view).selected) {
                ((UIButton *)view).backgroundColor = [UIColor blackColor];
            }else{
                ((UIButton *)view).backgroundColor = [UIColor clearColor];
            }
        }
    }
    
    if (_youhuoButton.selected) {
        [paramfilterDic setObject:@"true" forKey:@"iskc"];
    }
    else{
        [paramfilterDic setObject:@"false" forKey:@"iskc"];

    }
    if (_quanqiugouButton.selected) {
        [paramfilterDic setObject:@"true" forKey:@"zcsp"];

    }
    else{
        [paramfilterDic setObject:@"false" forKey:@"zcsp"];

    }
}

#pragma mark- 分类，品牌，价格选项
/*
 根据所选的列跳转到下一选项列表
 并加载相应的数据
 分类和品牌用treeview
 价格用tableview
 */
- (IBAction)nextAction:(id)sender {
    UIControl *control = ((UIControl *)sender);
    _sxRootView.hidden = YES;
    _cleanButton.hidden = YES;
    
    [_backButton setImage:[UIImage imageNamed:@"shangyiye_arrow"] forState:UIControlStateNormal];
    
    switch (control.tag) {
#pragma mark- 分类
        case 100:{
            _titleLabel.text = @"商品分类";
            _shaixuanNextView.hidden = NO;
            _treeView.hidden = NO;
            _tableView.hidden = YES;
            _dataArray = [NSMutableArray array];
            RADataObject *itemAll = [RADataObject dataObjectWithId:@0 name:@"全部" children:nil];
            itemAll.level = @0;
            itemAll.selected = YES;
            _selectedItem = itemAll;
            [_dataArray addObject:itemAll];
            
            
            [self loadDateClass];
        }
            break;
#pragma mark- 品牌
        case 101:{
            _titleLabel.text = @"品牌";
            _shaixuanNextView.hidden = NO;
            _treeView.hidden = NO;
            _tableView.hidden = YES;
            _dataArray = [NSMutableArray array];
            
            RADataObject *itemAll = [RADataObject dataObjectWithId:@0 name:@"全部" children:nil];
            itemAll.level = @0;
            itemAll.selected = YES;
            [_dataArray addObject:itemAll];
            _selectedItem = itemAll;
            NSString *urlStr = [NSString stringWithFormat:@"%@Ajax/search/search.ashx?op=getpp&spflcode=&ppcode=&key=",SERVICE_GETBASE_URL];
            if (self.keywords) {
                self.keywords =@"奶粉"; // 以后要删掉
                NSString *keystr = [self.keywords stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
                urlStr = [NSString stringWithFormat:@"%@%@",urlStr,keystr];
            }
            

            [self loadBrand:urlStr];
            
            
        }
            break;
#pragma mark- 价格
        default:{
            _titleLabel.text = @"价格";
            _shaixuanNextView.hidden = NO;
            _treeView.hidden = YES;
            _tableView.hidden = NO;
            
            [self loadDatePrice];
            
        }
            break;
    }
}

#pragma mark- 分类、品牌
#pragma mark- RATreeViewDataSource

-(UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item {
    static NSString *cellIdentifier = @"TypeCellIdentifier";
    UITableViewCell *cell = [_treeView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    RADataObject *data = item;
    
    if (data.children.count > 0) {
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Left_Arrow_yuan2"]];
        cell.tintColor = [UIColor colorWithHexString:@"#323232"];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#323232"];
    } else {
        
        if (data.selected) {
            cell.tintColor = [UIColor colorWithHexString:@"#E60000"];
            cell.textLabel.textColor = [UIColor colorWithHexString:@"#E60000"];
            cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"choice_icon"]];
        } else {
            cell.tintColor = [UIColor colorWithHexString:@"#323232"];
            cell.textLabel.textColor = [UIColor colorWithHexString:@"#323232"];
            cell.accessoryView = nil;
        }
    }
    
    cell.textLabel.text = data.name;
    
    return cell;
}

-(NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item {
    if (item) {
        RADataObject *data = item;
        return data.children.count;
    }
    return _dataArray.count;
}

-(id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item {
    
    RADataObject *data = item;
    if (data) {
        return data.children[index];
    }
    return _dataArray[index];
}

#pragma mark- RATreeViewDelegate

-(void)treeView:(RATreeView *)treeView willExpandRowForItem:(id)item {
    RADataObject *data = item;
    if (data.children.count > 0) {
        UITableViewCell *cell = [treeView cellForItem:item];
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Left_Arrow_yuan"]];
    }
}

-(void)treeView:(RATreeView *)treeView willCollapseRowForItem:(id)item {
    RADataObject *data = item;
    if (data.children.count > 0) {
        UITableViewCell *cell = [treeView cellForItem:item];
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Left_Arrow_yuan2"]];
    }
}

-(void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item {

    
    if (item == _selectedItem) {
        RADataObject *data = item;
        UITableViewCell *cell = [treeView cellForItem:item];
        
        if (data.children.count == 0) {
            if (!data.selected) {
                
                cell.tintColor = [UIColor colorWithHexString:@"#E60000"];
                cell.textLabel.textColor = [UIColor colorWithHexString:@"#E60000"];
                cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"choice_icon"]];
                data.selected = YES;
            }
        }
    } else {
        
        RADataObject *data = item;
        if (data.children.count == 0 ) {
            
            UITableViewCell *selectedCell = [treeView cellForItem:_selectedItem];
            selectedCell.tintColor = [UIColor colorWithHexString:@"#323232"];
            selectedCell.textLabel.textColor = [UIColor colorWithHexString:@"#323232"];
            selectedCell.accessoryView = nil;
            _selectedItem.selected = NO;
            
            UITableViewCell *cell = [treeView cellForItem:item];
            cell.tintColor = [UIColor colorWithHexString:@"#E60000"];
            cell.textLabel.textColor = [UIColor colorWithHexString:@"#E60000"];
            cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"choice_icon"]];
            data.selected = YES;
            if (data.idstr) {
                NSString *spflcode = data.idstr;
                NSLog(@"num is %@",spflcode);
                if (data.dataId.intValue==0) {//商品分类
                    [paramfilterDic setObject:[NSString stringWithFormat:@"%@",spflcode] forKey:@"spflcode"];
                }
                
                if (data.dataId.intValue==1) {//品牌
                    [paramfilterDic setObject:[NSString stringWithFormat:@"%@",spflcode] forKey:@"spflcode"];
                }
            }
            _selectedItem = item;
        }
    }
}

-(NSInteger)treeView:(RATreeView *)treeView indentationLevelForRowForItem:(id)item {
    RADataObject *data = item;
    if (data) {
        if ([data.level isEqualToNumber:@0]) {
            return 0;
        } else {
            return 3;
        }
    }
    return 0;
}

#pragma mark- 价格
- (void)confirmAction {
    
    NSString * string;
    
    if ([_selectedIndexPath isEqual:_selectAllIndexPath]) {
        _minPrice = nil;
        _maxPrice = nil;
        
        string = @"";
    } else if ([_selectedIndexPath isEqual:_customIndexPath]) {
        if (![self priceValidate]) {
            return;
        }
        _minPrice = @(fromPriceTextField.text.integerValue);
        _maxPrice = @(toPriceTextField.text.integerValue);
        
        string = [NSString stringWithFormat:@"%ld~%ld",_minPrice.integerValue,_maxPrice.integerValue];
    }else if ([_selectedIndexPath isEqual:_selectMoreIndexPath]){
        string = @">10000";
    }else {
        string = _priceArray[_selectedIndexPath.row];
    }
    
    _jiage.text = string;
    [paramfilterDic setObject:_minPrice forKey:@"jgs"];
    [paramfilterDic setObject:_maxPrice forKey:@"jge"];

    
}

-(BOOL)priceValidate {
   
    if (![fromPriceTextField.text isEqualToString:@""] && ![toPriceTextField.text isEqualToString:@""] &&fromPriceTextField.text.integerValue > toPriceTextField.text.integerValue) {
//        [self alert:@"提示信息" msg:@"起始价格不能大于终止价格"];
        return NO;
    }
    return YES;
}

-(void)selectCell:(UITableViewCell *)cell {
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#e60000"];
    cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"choice_icon"]];
}

-(void)unselectCell:(UITableViewCell *)cell {
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#323232"];
    cell.accessoryView = nil;
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _priceArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PriceCellIdentifier];
    
    id data = _priceArray[indexPath.row];
    
    if ([data isKindOfClass:[HFSPriceDataObject class]]) {
        cell.textLabel.text = ((HFSPriceDataObject *)data).description;
    } else {
        if ([data isEqualToString:@"自定义"]) {
            fromPriceTextField = [[UITextField alloc]initWithFrame:CGRectMake(20.0f, 9.0f, 80.0f, 30.0f)];
            fromPriceTextField.background = [UIImage imageNamed:@"price_input_box"];
            fromPriceTextField.textAlignment = NSTextAlignmentCenter;
            fromPriceTextField.placeholder = @"起始价格";
            fromPriceTextField.keyboardType = UIKeyboardTypeNumberPad;
            fromPriceTextField.delegate = self;
            [cell.contentView addSubview:fromPriceTextField];
            
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(106.0f, 23.0f, 15.0f, 1.5f)];
            view.backgroundColor = [UIColor colorWithHexString:@"#C8C8C8"];
            [cell.contentView addSubview:view];
            
            toPriceTextField = [[UITextField alloc]initWithFrame:CGRectMake(127.0f, 9.0f, 80.0f, 30.0f)];
            toPriceTextField.background = [UIImage imageNamed:@"price_input_box"];
            toPriceTextField.textAlignment = NSTextAlignmentCenter;
            toPriceTextField.placeholder = @"终止价格";
            toPriceTextField.keyboardType = UIKeyboardTypeNumberPad;
            toPriceTextField.delegate = self;
            [cell.contentView addSubview:toPriceTextField];
            
            if (_postMaxPrice&&_postMinPrice&&_selectedIndexPath == _customIndexPath) {
                fromPriceTextField.text = [NSString stringWithFormat:@"%@",_postMinPrice];
                toPriceTextField.text = [NSString stringWithFormat:@"%@",_postMaxPrice];
            }
            
            
        } else {
            cell.textLabel.text = data;
        }
    }
    
    if ([indexPath isEqual:_selectedIndexPath]) {
        [self selectCell:cell];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id data = _priceArray[indexPath.row];
    if ([data isKindOfClass:[NSString class]] && [data isEqualToString:@"自定义"]) {
        return 48.0f;
    } else {
        return 44.0f;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([indexPath isEqual:_selectedIndexPath]) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell.accessoryView) {
            [self selectCell:cell];
        }
    } else {
        UITableViewCell *orginalCell = [tableView cellForRowAtIndexPath:_selectedIndexPath];
        [self unselectCell:orginalCell];
        
        UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
        [self selectCell:currentCell];
    }
    
    _selectedIndexPath = indexPath;
    
    if (![_selectedIndexPath isEqual:_customIndexPath]) {
        [fromPriceTextField resignFirstResponder];
        [toPriceTextField resignFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [_tableView selectRowAtIndexPath:_customIndexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
    
    UITableViewCell *orginalCell = [_tableView cellForRowAtIndexPath:_selectedIndexPath];
    [self unselectCell:orginalCell];
    
    UITableViewCell *currentCell = [_tableView cellForRowAtIndexPath:_customIndexPath];
    [self selectCell:currentCell];
    
    _selectedIndexPath = _customIndexPath;
    
    return YES;
}



@end
